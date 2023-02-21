//
//  File.swift
//  hw4Month4
//
//  Created by Mac on 7/2/2023.
//

import UIKit

struct Product: Codable {
    let id: Int
    let thumbnail: String
    let title: String
    let description: String
    let price: Int
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String
    let category: String
}

struct Products: Codable {
    let products: [Product]
}

