//
//  DashboardViewModel.swift
//  DashboardApp
//
//  Created by thinkpalm on 22/10/26.
//
import Foundation
import Observation

@Observable
public class DashboardViewModel {
    public var posts: [Post] = []
    public var isLoading: Bool = false
    public var errorMessage: String? = nil
    
    private var hasLoadedOnce = false
    private let networkManager = NetworkManager.shared
    
    public func loadPosts(force: Bool = false) async {
        // Prevent duplicate calls if already loading or if already successfully loaded
        if isLoading { return }
        if hasLoadedOnce && !force { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedPosts = try await networkManager.fetchPosts()
            self.posts = fetchedPosts
            self.isLoading = false
            self.hasLoadedOnce = true
        } catch {
            print("❌ DEBUG NETWORK ERROR: \(error)")
            
            let nsError = error as NSError
            if nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorCancelled {
                self.isLoading = false
                return
            }
            
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
}
