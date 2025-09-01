//
//  DetailTodoAssembly.swift
//  TodoList
//
//  Created by Валентин on 01.09.2025.
//

import UIKit

class DetailTodoAssembly {
    static func assembleDetailTodoModule(todo: TodoItemViewModel, coreDataService: TodoCoreDataServiceProtocol) -> UIViewController {
        let view = DetailTodoView()
        let interactor = DetailTodoInteractor(todo: todo, coreDataService: coreDataService)
        let router = DetailTodoRouter()
        
        let presenter = DetailTodoPresenter(interactor: interactor, view: view, router: router)
        
        interactor.output = presenter
        view.output = presenter
        router.viewController = view
        
        let navigationController = UINavigationController(rootViewController: view)
        return navigationController        
    }
}
