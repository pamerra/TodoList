//
//  TodoListRouter.swift
//  ViperExample
//
//  Created by Валентин on 01.09.2025.
//

import UIKit

protocol TodoListRouterInput {
    func openAddScreen(withLogin login: String)
}

final class TodoListRouter: TodoListRouterInput {
    weak var rootViewController: UIViewController?
    
    func openAddScreen(withLogin login: String) {
        let newVc = UIViewController(nibName: nil, bundle: nil)
        newVc.view.backgroundColor = .green
        rootViewController?.present(newVc, animated: true, completion: nil)
    }
}
