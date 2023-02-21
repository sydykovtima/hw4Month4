//
//  SecondViewController.swift
//  hw4Month4
//
//  Created by Mac on 6/2/2023.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet private var titleLable: UITextField!
    @IBOutlet private var priceLabel: UITextField!
    @IBOutlet private var detailsLable: UITextField!
    @IBOutlet private var categoryLable: UITextField!
    @IBOutlet private var brandLable: UITextField!
    
    public var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func configUI() {
        titleLable.text = product?.title
        priceLabel.text = "\(product?.price ?? 0)"
        detailsLable.text = product?.description
        categoryLable.text = product?.category
        brandLable.text = product?.brand
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configUI()
    }
    @IBAction func createProduct() {
        guard let  product = product else {return}
        NetworkLayer.shared.postProductsData(model: product) { result in
            switch result {
            case .success( _):
                DispatchQueue.main.async {
                    self.showSuccessAlert()
                    
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorAlert(with: error.localizedDescription)
                    
                }
            }
        }
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", 
        message: "Successfull created product.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
        present(alert, animated: true)
    }
    
    private func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Error occured",
        message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}


