//
//  TodoListAssembly.swift
//  ViperExample
//
//  Created by Валентин on 01.09.2025.
//

import UIKit

final class TodoListAssembly {
    static func assembleTodoListModule() -> UINavigationController {
        let view = TodoListView()
        let networkService = NetworkService()
        let coreDataService = CoreDataService()
        let userDefaultsService = UserDefaultsService()
        
        let interactor = TodoListInteractor(
            networkService: networkService,
            coreDataService: coreDataService,
            userDefaultsService: userDefaultsService
        )
        let router = TodoListRouter(coreDataService: coreDataService)
        
        let presenter = TodoListPresenter(interactor: interactor,
                                        router: router,
                                        view: view)
        
        view.output = presenter
        interactor.output = presenter
        router.rootViewController = view
        
        let navigationController = UINavigationController(rootViewController: view)
        return navigationController
    }
}
