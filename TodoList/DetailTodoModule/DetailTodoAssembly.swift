//
//  DetailTodoAssembly.swift
//  TodoList
//
//  Created by Валентин on 01.09.2025.
//

import UIKit

final class DetailTodoAssembly {
    static func assembleDetailTodoModule(todo: TodoItemViewModel?, coreDataService: CoreDataServiceProtocol, todoListener: TodoUpdateListener?) -> UIViewController {
        let view = DetailTodoView()
        let interactor = DetailTodoInteractor(todo: todo, coreDataService: coreDataService)
        let router = DetailTodoRouter()
        
        let presenter = DetailTodoPresenter(interactor: interactor, view: view, router: router, todoListener: todoListener)
        
        view.output = presenter
        interactor.output = presenter
        router.viewController = view
        
        let navigationController = UINavigationController(rootViewController: view)
        return navigationController
    }
}
