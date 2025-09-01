//
//  DetailTodoRouter.swift
//  TodoList
//
//  Created by Валентин on 01.09.2025.
//

import UIKit

protocol DetailTodoRouterInput {
    func closeView()
}

final class DetailTodoRouter: DetailTodoRouterInput {
    weak var viewController: UIViewController?
    
    func closeView() {
        viewController?.dismiss(animated: true)
    }
}
