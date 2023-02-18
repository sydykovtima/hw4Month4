//
//  File.swift
//  hw4Month4
//
//  Created by Mac on 7/2/2023.
//

import UIKit


//let productJSON = """
//[{
//        "productsImageView": "Burger Craze",
//        "nameProducts": "Burger Craze",
//        "openClose": "Open ",
//        "delivery": "Free",
//        "madeOnTheWord": "American: Burgers",
//        "time": "1.5 km",
//        "cost": "minimum 10$",
//        "rate": "4.6(601)",
//        "distance": "15-20 min"
//},
//{
//        "productsImageView": "Vegetarian Pizza",
//        "nameProducts": "Vegetarian Pizza",
//        "openClose": "Open",
//        "delivery": "Free",
//        "madeOnTheWord": "American: Pizza",
//        "time": "1.5 km",
//        "cost": "minimum 10$",
//        "rate": "4.6(601)",
//        "distance": "15-20 min"
//}
//]
//"""

//id": 1,
//            "title": "iPhone 9",
//            "description": "An apple mobile which is nothing like apple",
//            "price": 549,
//            "discountPercentage": 12.96,
//            "rating": 4.69,
//            "stock": 94,
//            "brand": "Apple",
//            "category": "smartphones",
//            "thumbnail": "https:/
struct Product: Decodable {
    let productsImageView: String
    let title: String
    let description: String
    let price: Int
    let discountPercentage: String
    let rating: String
    let stock: String
    let brand: String
    let category: String
    
}

struct Products: Decodable {
    let product: [Product]
}
