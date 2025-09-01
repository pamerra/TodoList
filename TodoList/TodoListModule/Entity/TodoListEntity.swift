//
//  TodoListEntity.swift
//  ViperExample
//
//  Created by Валентин on 01.09.2025.
//

import Foundation

struct TodoListEntity {
    let items: [TodoItemViewModel]
    let totalCount: Int
    let filteresItems: [TodoItemViewModel]
    let searchText: String
}
