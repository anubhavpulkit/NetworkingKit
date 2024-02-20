// The Swift Programming Language

import Foundation
import SwiftUI
import UIKit

public enum MovieError: Error, CustomNSError {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    public var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    public var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

@available(iOS 13.0.0, *)
public func loadURLAndDecode<D: Decodable>(url: URL, apiKey: String, params: [String: String]? = nil) async throws -> D {
    guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
        throw MovieError.invalidEndpoint
    }
    
    var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
    if let params = params {
        queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
    }
    
    urlComponents.queryItems = queryItems
    
    guard let finalURL = urlComponents.url else {
        throw MovieError.invalidEndpoint
    }
    
    let (data, response) = try await URLSession.shared.data(from: finalURL)
    
    guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
        throw MovieError.invalidResponse
    }
    return try Utils.jsonDecoder.decode(D.self, from: data)
}
