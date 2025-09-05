//
//  NetworkService.swift
//  TodoList
//
//  Created by Валентин on 05.09.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchTodos(completion: @escaping (Result<TodoResponse, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://dummyjson.com/todos"
    
    func fetchTodos(completion: @escaping (Result<TodoResponse, any Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(TodoResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
            
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}
