//
//  File.swift
//  hw4Month4
//
//  Created by Mac on 7/2/2023.
//

import UIKit




struct Product: Decodable {
    let productsImageView: String
    let nameProducts: String
    let openClose: String
    let delivery: String
    let madeOnTheWord: String
    let time: String
    let cost: String
    let rate: String
    let distance: String
}

struct Products: Decodable {
    let product: [Product]
}
