//
//  DashboardMainView.swift
//  DashboardApp
//
//  Created by thinkpalm on 22/10/26.
//
import SwiftUI

public struct DashboardMainView: View {
    @State private var viewModel = DashboardViewModel()
    
    // Use flexible columns based on horizontal size class or simpler adaptive layout
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    public var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Fetching posts...")
                        .font(.headline)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 48))
                            .foregroundColor(.red)
                        Text("Oops! Something went wrong.")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Retry") {
                            Task {
                                await viewModel.loadPosts(force: true)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 280, maximum: .infinity), spacing: 16)], spacing: 16) {
                            ForEach(viewModel.posts) { post in
                                NavigationLink(value: post) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(post.title.capitalized)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                            .lineLimit(2)
                                        
                                        Text(post.body)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(3)
                                        
                                        Spacer()
                                        
                                        HStack {
                                            Label("Post #\(post.id)", systemImage: "doc.text")
                                                .font(.caption2)
                                                .foregroundColor(.blue)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.caption2)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding(16) // Corrected padding modifier syntax
                                    .frame(height: 180, alignment: .topLeading)
                                    .background(Color(.systemBackground))
                                    .cornerRadius(16)
                                    .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(16)
                    }
                    .background(Color(.secondarySystemBackground))
                }
            }
            .navigationTitle("Dashboard")
            .navigationDestination(for: Post.self) { post in
                PostDetailView(post: post)
            }
            .task {
                await viewModel.loadPosts()
            }
        }
    }
}

// Simple Detail View when a post is clicked
struct PostDetailView: View {
    let post: Post
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(post.title.capitalized)
                    .font(.title2)
                    .bold()
                
                Text("Author ID: \(post.userId)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Divider()
                
                Text(post.body)
                    .font(.body)
                    .lineSpacing(6)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Post Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DashboardMainView()
}
