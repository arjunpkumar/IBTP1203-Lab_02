//
//  Post.swift
//  DashboardApp
//
//  Created by thinkpalm on 22/10/26.
//

import Foundation

public struct Post: Codable, Identifiable, Hashable {
    public let userId: Int
    public let id: Int
    public let title: String
    public let body: String
}
