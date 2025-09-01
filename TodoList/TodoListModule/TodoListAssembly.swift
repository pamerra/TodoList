//
//  TodoListAssembly.swift
//  ViperExample
//
//  Created by Валентин on 01.09.2025.
//

import UIKit

class TodoListAssembly {
    static func assembleTodoListModule() -> UINavigationController {
        let view = TodoListView()
        let networkService = TodoNetworkService()
        let coreDataService = TodoCoreDataService()
        let interactor = TodoListInteractor(networkService: networkService, coreDataService: coreDataService)
        let router = TodoListRouter()
        
        let presenter = TodoListPresenter(interactor: interactor,
                                       router: router,
                                       view: view)
        
        interactor.output = presenter
        view.output = presenter
        presenter.output = view
        router.rootViewController = view

        let navigationController = UINavigationController(rootViewController: view)
        return navigationController
    }
}
