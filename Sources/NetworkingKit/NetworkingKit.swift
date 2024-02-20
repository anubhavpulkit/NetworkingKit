// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

// NetworkService.swift
public protocol NetworkServiceProtocol {
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

public class NetworkService: NetworkServiceProtocol {
    public init() {}

    public func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            completion(.success(data))
        }.resume()
    }
}

public enum NetworkError: Error {
    case noData
}
