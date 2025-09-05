//
//  TodoListInteractor.swift
//  ViperExample
//
//  Created by Валентин on 01.09.2025.
//

import Foundation
import CoreData

protocol TodoListInteractorInput {
    func loadTodos()
    func searchTodos(with query: String)
    func toggleTodoCompletion(id: Int)
    func deleteTodo(_ id: Int)
    func updateTodo(id: Int, title: String, description: String)
}

protocol TodoListInteractorOutput: AnyObject {
    func didLoadTodos(_ todos: [TodoItemViewModel])
    func didReceiveError(_ error: String)
    func didUpdateTodos(_ todos: [TodoItemViewModel])
    func didDeleteTodo(_ todos: [TodoItemViewModel])
}

final class TodoListInteractor: TodoListInteractorInput {
    weak var output: TodoListInteractorOutput?
    
    private let networkService: NetworkServiceProtocol
    private let coreDataService: CoreDataServiceProtocol
    private let userDefaultsService: UserDefaultsServiceProtocol
    private var allTodos: [TodoItemViewModel] = []
    
    init(networkService: NetworkServiceProtocol, coreDataService: CoreDataServiceProtocol, userDefaultsService: UserDefaultsServiceProtocol) {
        self.networkService = networkService
        self.coreDataService = coreDataService
        self.userDefaultsService = userDefaultsService
    }
    
    func loadTodos() {
        if userDefaultsService.isNotFirstLaunch() {
            loadTodosFromCoreData()
        } else {
            loadTodosFromAPI()
        }
    }
    
    private func loadTodosFromAPI() {
        networkService.fetchTodos { [weak self] result in
            switch result {
            case .success(let response):
                let todoViewModels = response.todos.map { TodoItemViewModel(from: $0) }
                self?.allTodos = todoViewModels
                self?.coreDataService.saveTodos(response.todos)
                self?.userDefaultsService.markAsNotFirstLaunch()
                self?.output?.didLoadTodos(todoViewModels)
            case .failure(let error):
                self?.output?.didReceiveError(error.localizedDescription)
            }
        }
    }
    
    private func loadTodosFromCoreData() {
        coreDataService.fetchTodos { [weak self] coreDataItems in
            let todoViewModels = coreDataItems.map { TodoItemViewModel(from: $0) }
            self?.allTodos = todoViewModels
            self?.output?.didLoadTodos(todoViewModels)
        }
    }
    
    func searchTodos(with query: String) {
        DispatchQueue(label: "com.todo.coredata.queue", qos: .background).async { [weak self] in
            guard let allTodos = self?.allTodos else { return }
            if query.isEmpty {
                self?.output?.didUpdateTodos(allTodos)
            } else {
                let filteredTodos = allTodos.filter { todo in
                    todo.title.localizedCaseInsensitiveContains(query) ||
                    todo.describe.localizedCaseInsensitiveContains(query)
                }
                self?.output?.didUpdateTodos(filteredTodos)
            }
        }
    }
    
    func toggleTodoCompletion(id: Int) {
        if let index = allTodos.firstIndex(where: { $0.id == id }) {
            let newCompletedState = !allTodos[index].isCompleted
                    
            allTodos[index] = TodoItemViewModel(
                id: allTodos[index].id,
                title: allTodos[index].title,
                describe: allTodos[index].describe,
                isCompleted: newCompletedState,
                createdAt: allTodos[index].createdAt,
                userId: allTodos[index].userId
            )
                    
            coreDataService.updateTodoCompletion(id: id, isCompleted: newCompletedState)
                    
            output?.didUpdateTodos(allTodos)
        }
    }
    
    func deleteTodo(_ id: Int) {
        if let index = allTodos.firstIndex(where: { $0.id == id }) {
            coreDataService.deleteTodo(id)
            allTodos.remove(at: index)
            output?.didDeleteTodo(allTodos)
        }
    }
 
    //метод перезагрузки только что отредактированной задачи в tableView
    func updateTodo(id: Int, title: String, description: String) {
        if let index = allTodos.firstIndex(where: { $0.id == id }) {
            allTodos[index] = TodoItemViewModel(
                id: allTodos[index].id,
                title: title,
                describe: description,
                isCompleted: allTodos[index].isCompleted,
                createdAt: allTodos[index].createdAt,
                userId: allTodos[index].userId
            )

            output?.didUpdateTodos(allTodos)
        }
    }

}
