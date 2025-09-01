//
//  TodoListPresenter.swift
//  ViperExample
//
//  Created by Валентин on 31.07.2025.
//

import Foundation

protocol TodoListPresenterInput {
    var output: TodoListPresenterOutput? { get set }
    func viewDidLoad()
    func searchTextChanged(_ text: String)
    func todoToggled(id: Int)
}

protocol TodoListPresenterOutput: AnyObject {
    func displayTodos(_ todos: [TodoItemViewModel])
    func displayError(_ message: String)
    func showLoading()
    func hideLoading()
}

final class TodoListPresenter {
    weak var output: TodoListPresenterOutput?
    
    private let interactor: TodoListInteractorInput
    private let router: TodoListRouterInput
    private let view: TodoListViewInput
    
    init(interactor: TodoListInteractorInput, router: TodoListRouterInput, view: TodoListViewInput) {
        self.interactor = interactor
        self.router = router
        self.view = view
    }
    
}

extension TodoListPresenter: TodoListViewOutput {
    
    func viewDidLoad() {
        output?.showLoading()
        interactor.loadTodos()
    }
    
    func searchTextChanged(_ text: String) {
        interactor.searchTodos(with: text)
    }
    
    func todoToggled(id: Int) {
        interactor.toggleTodoCompletion(id: id)
    }
}

extension TodoListPresenter: TodoListInteractorOutput {
    
    func didLoadTodos(_ todos: [TodoItemViewModel]) {
        output?.hideLoading()
        output?.displayTodos(todos)
    }
    
    func didReceiveError(_ error: String) {
        output?.hideLoading()
        output?.displayError(error)
    }
    
    func didUpdateTodos(_ todos: [TodoItemViewModel]) {
        output?.displayTodos(todos)
    }
}
