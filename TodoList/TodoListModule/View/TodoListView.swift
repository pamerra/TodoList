//
//  TodoListView.swift
//  ViperExample
//
//  Created by Валентин on 01.09.2025.
//

import UIKit

protocol TodoListViewInput {
    var output: TodoListViewOutput? { get set }
}

protocol TodoListViewOutput: AnyObject {
    func viewDidLoad()
    func searchTextChanged(_ text: String)
    func todoToggled(id: Int)
    func editTodo(_ todo: TodoItemViewModel)
    func shareTodo(_ todo: TodoItemViewModel)
    func deleteTodo(_ id: Int)
}

final class TodoListView: UIViewController, TodoListViewInput {
    var output: TodoListViewOutput?
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    private var todos: [TodoItemViewModel] = []
    private var currentContextTodo: TodoItemViewModel?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupTableView()
        output?.viewDidLoad()
    }
    
    private func setupNavigationBar() {
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        
        // Search Bar
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = .clear
        searchBar.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        searchBar.tintColor = .white
        
        // TableView
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(TodoTableViewCell.self, forCellReuseIdentifier: "TodoCell")
        
        // Loading Indicator
        loadingIndicator.color = .white
        loadingIndicator.hidesWhenStopped = true
        
        // Add to view hierarchy
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        
        // Constraints
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
           
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension TodoListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoTableViewCell
        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension TodoListView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        output?.searchTextChanged(searchText)
    }
}

extension TodoListView: TodoTableViewCellDelegate {
    
    func todoCellDidToggle(_ cell: TodoTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let todo = todos[indexPath.row]
        output?.todoToggled(id: todo.id)
    }
    
    func todoCellDidTap(_ cell: TodoTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let todo = todos[indexPath.row]
        showContextMenu(for: todo, at: indexPath)
    }
    
    func showContextMenu(for todo: TodoItemViewModel, at indexPath: IndexPath) {
        currentContextTodo = todo
        
        let contextMenu = ContextMenuViewController()
        contextMenu.delegate = self
        
        let cell = tableView.cellForRow(at: indexPath)
        
        contextMenu.presentFrom(viewController: self, sourceView: cell ?? view)
    }
}

extension TodoListView: ContextMenuViewControllerDelegate {
    func contextMenuDidSelectEdit() {
        guard let todo = currentContextTodo else { return }
        output?.editTodo(todo)
    }
    
    func contextMenuDidSelectShare() {
        guard let todo = currentContextTodo else { return }
        output?.shareTodo(todo)
    }
    
    func contextMenuDidSelectDelete() {
        guard let todo = currentContextTodo else { return }
        output?.deleteTodo(todo.id)
    }
}

// MARK: TodoListPresenterOutput
extension TodoListView: TodoListPresenterOutput {
    func displayTodos(_ todos: [TodoItemViewModel]) {
        self.todos = todos
        tableView.reloadData()
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoading() {
        loadingIndicator.stopAnimating()
    }
}
