//
//  NetworkManager.swift
//  DashboardApp
//
//  Created by thinkpalm on 22/10/26.
//
import Foundation

public enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed(Error)
    case serverError(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL: return "The URL was invalid."
        case .invalidResponse: return "Received an invalid response from the server."
        case .decodingFailed(let error): return "Failed to decode data: \(error.localizedDescription)"
        case .serverError(let message): return "Server error: \(message)"
        }
    }
}

public actor NetworkManager {
    public static let shared = NetworkManager()
    private init() {}
    
    public func fetchPosts() async throws -> [Post] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let posts = try JSONDecoder().decode([Post].self, from: data)
            return posts
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}
