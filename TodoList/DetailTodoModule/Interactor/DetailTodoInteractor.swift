//
//  DetailTodoInteractor.swift
//  TodoList
//
//  Created by Валентин on 01.09.2025.
//

import Foundation

protocol DetailTodoInteractorInput {
    func loadTodo()
    func saveTodo(title: String, description: String)
}

protocol DetailTodoInteractorOutput: AnyObject {
    func didLoadTodo(_ todo: TodoItemViewModel)
    func didSaveTodo(id: Int, title: String, description: String, isNew: Bool)
    func didReceiveError(_ error: String)
}

final class DetailTodoInteractor: DetailTodoInteractorInput {
    var output: DetailTodoInteractorOutput?
    
    private let todo: TodoItemViewModel?
    private let coreDataService: CoreDataServiceProtocol
    
    init(todo: TodoItemViewModel?, coreDataService: CoreDataServiceProtocol) {
        self.todo = todo
        self.coreDataService = coreDataService
    }
    
    func loadTodo() {
        if let todo = todo {
            output?.didLoadTodo(todo)
        } else {
            let emptyTodo = TodoItemViewModel(
                id: 0,//временный id
                title: "",
                describe: "",
                isCompleted: false,
                createdAt: Date(),
                userId: 1
            )
            output?.didLoadTodo(emptyTodo)
        }
    }
    
    func saveTodo(title: String, description: String) {
        if let existingTodo = todo {
            coreDataService.updateTodo(id: existingTodo.id, title: title, description: description)
            output?.didSaveTodo(id: existingTodo.id, title: title, description: description, isNew: false)    //для обновления на основном экране
        } else {
            coreDataService.createTodo(title: title, description: description) { newId in
                self.output?.didSaveTodo(id: newId, title: title, description: description, isNew: true)    //для обновления на основном экране
            }
        }
    }
}

