//
//  ProductTableViewCell.swift
//  hw4Month4
//
//  Created by Mac on 6/2/2023.
//

import UIKit

protocol ProductsCellDelegate: AnyObject {
    func didSelectionsProducts (item: Product)
    
}

class ProductTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ProductTableViewCell.self)
    @IBOutlet private weak var ratingLable: UILabel!
    @IBOutlet private weak var categoryLable: UILabel!
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var brandLable: UILabel!
    @IBOutlet private weak var descriptionLable: UILabel!
    @IBOutlet private weak var priceLable: UILabel!
    @IBOutlet private weak var discountPercentageLable: UILabel!
    @IBOutlet private weak var stock: UILabel!
    @IBOutlet private weak var productImageView: UIImageView! {
        didSet {
            productImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnImage))
            productImageView.addGestureRecognizer(tap)
        }
    }
    private var tags: [String] = []
    
    weak var delegate: ProductsCellDelegate?
    private var products: Product?
    public func display(item: Product) {
        products = item
        productImageView.getImage(from: item.thumbnail)
        descriptionLable.text = item.description
        titleLable.text = item.title
        discountPercentageLable.text = "\(item.discountPercentage)"
        brandLable.text = item.brand
        stock.text = "\(item.stock)"
        ratingLable.text = "\(item.rating)"
        categoryLable.text = item.category
        priceLable.text = "\(item.price)"
        discountPercentageLable.textColor = .lightGray
        stock.backgroundColor = .orange
        ratingLable.textColor = .lightGray
        priceLable.textColor = .lightGray
        descriptionLable.textColor = .lightGray
        
    }
    
    @objc
    private func didTapOnImage() {
        print("Selections tapped")
        
        guard let products = products else {
            return
        }
        delegate?.didSelectionsProducts(item: products)
    }
}



