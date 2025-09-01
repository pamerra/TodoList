//
//  DetailTodoInteractor.swift
//  TodoList
//
//  Created by Валентин on 01.09.2025.
//

import Foundation

protocol DetailTodoInteractorInput {
    var output: DetailTodoInteractorOutput? { get set }
    func loadTodo()
    func saveTodo(title: String, description: String)
}

protocol DetailTodoInteractorOutput: AnyObject {
    func didLoadTodo(_ todo: TodoItemViewModel)
    func didSaveTodo()
    func didReceiveError(_ error: String)
}

final class DetailTodoInteractor: DetailTodoInteractorInput {
    var output: DetailTodoInteractorOutput?
    
    private let todo: TodoItemViewModel
    private let coreDataService: TodoCoreDataServiceProtocol
    
    init(todo: TodoItemViewModel, coreDataService: TodoCoreDataServiceProtocol) {
        self.todo = todo
        self.coreDataService = coreDataService
    }
    
    func loadTodo() {
        output?.didLoadTodo(todo)
    }
    
    func saveTodo(title: String, description: String) {
        coreDataService.updateTodo(id: todo.id, title: todo.title, description: todo.describe)
        output?.didSaveTodo()
    }
}

