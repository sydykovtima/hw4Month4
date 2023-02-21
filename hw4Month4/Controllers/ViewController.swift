//
//  ViewController.swift
//  hw4Month4
//
//  Created by Mac on 6/2/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var searchProduct: UISearchBar!
    @IBOutlet private weak var typeOfOrderCollectionView: UICollectionView!
    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    @IBOutlet private weak var productTableView: UITableView!
    
    private var categoryArray: [Category] = []
    private var orderType: [TypeOfOrder] = []
    private var products: [Product] = []
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCategoryCV()
        typeOfOrderCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.showsVerticalScrollIndicator = false
        categoryCollectionView.showsHorizontalScrollIndicator = false
        productTableView.showsVerticalScrollIndicator = false
        productTableView.showsHorizontalScrollIndicator = false
        fetchProducts()
        fetchOrderType()
        fetchCategory()
    }
    
    private func configureCategoryCV() {
        productTableView.dataSource = self
        productTableView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        typeOfOrderCollectionView.dataSource = self
        typeOfOrderCollectionView.delegate = self
        typeOfOrderCollectionView.register (
        UINib(
        nibName: String(describing: OrderTypeCollectionViewCell.self),
        bundle: nil
        ),
        forCellWithReuseIdentifier:
        OrderTypeCollectionViewCell.reuseIdentifierForOrderType
        )
        categoryCollectionView.register(UINib(nibName: String(
        describing:
        CategoryCollectionViewCell.self), bundle: nil),
        forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        productTableView.register(UINib(nibName:
        String( describing: ProductTableViewCell.self)
        , bundle: nil), forCellReuseIdentifier:
        ProductTableViewCell.reuseIdentifier)
    }
    
    private func fetchCategory() {
        do { categoryArray = try NetworkLayer.shared.fetchCategory()
            categoryCollectionView.reloadData()
        }catch {
            print("error \(error.localizedDescription)")
        }
    }
    
    private func fetchOrderType() {
        do { orderType = try NetworkLayer.shared.fetchOrderType()
            typeOfOrderCollectionView.reloadData()
        } catch {
            print("error \(error.localizedDescription)")
        }
    }
    
    private func fetchProducts() {
        isLoading = true
        
        NetworkLayer.shared.fetchProducts{ result in
            self.isLoading = false
            switch result {
            case .success(let model):
                self.products = model
                DispatchQueue.main.async {
                    self.productTableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showError(with: error)
                }
            }
        }
    }
    
    private func searchProducts(by word: String) {
        isLoading = true
        
        NetworkLayer.shared.searchProducts(by: word) { result in
            self.isLoading = false
            switch result {
            case .success(let model):
            self.products = model
            DispatchQueue.main.async {
            self.productTableView.reloadData()
                }
            case .failure(let error):
                self.showError(with: error)
            }
        }
    }
    
    
    private func showError(with message: Error) {
        let alert = UIAlertController(title: "Error",
         message: message.localizedDescription,
         preferredStyle: .alert)
        alert.addAction(.init(title: "Okay", style: .cancel))
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
     numberOfRowsInSection section: Int
    ) -> Int {
        products.count
    }
    
    func tableView(_ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCell(
         withIdentifier: ProductTableViewCell.reuseIdentifier,
         for: indexPath
        ) as! ProductTableViewCell
        let model = products[indexPath.row]
        cell.display(item: model)
        cell.delegate = self
        print("cell created")
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
     heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 350
    }
    func tableView(_ tableView: UITableView, 
     canEditRowAt indexPath: IndexPath
     ) -> Bool {
        return true
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            handleDeleteTakeaways(indexPath: indexPath)
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Create new product") 
            { _, _, _ in
            self.askUserConfirmAlert(for: indexPath, deleteAction: false)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    private func handleDeleteTakeaways(indexPath:IndexPath) {
        askUserConfirmAlert(for: indexPath, deleteAction: true)
    }
    
    private func deleteProducts(by id: Int) {
        NetworkLayer.shared.deleteProductsData(id: id) { result in
            switch result {
            case .success(_) :
                DispatchQueue.main.async {
                    self.showSuccessAlert()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showError(with: error)
                }
            }
        }
    }
    
    private func askUserConfirmAlert(for indexPath: IndexPath, deleteAction: Bool) {
        if deleteAction {
            let alert = UIAlertController(title: "Вы действительн хотите удалить?",
            message: "Данное действие нельзя вернуть обратно", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Да", style: .destructive) { [unowned self] action in
            
                let id = self.products[indexPath.row].id
                self.deleteProducts(by: id)
                self.products.remove(at: indexPath.row)
                self.productTableView.reloadData()
                
            }
            alert.addAction(yesAction)
            alert.addAction(UIAlertAction(title: "нет", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Хотите создать новый продукт?", message: nil, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Да", style: .default) { [unowned self] action in
                let vc = storyboard?.instantiateViewController(withIdentifier: "second_vc")
                as! SecondViewController
                vc.product = products[indexPath.row]
                present(vc, animated: true)
            }
            alert.addAction(yesAction)
            alert.addAction(UIAlertAction(title: "нет", style: .default))
            present(alert, animated: true)
        }
       
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(title: "Успешно удалено",
        message: "Продукт удален", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
    
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == categoryCollectionView {
            return categoryArray.count
        }
        if collectionView == typeOfOrderCollectionView {
            
        }
        return orderType.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(
             withReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier,
             for: indexPath
            ) as! CategoryCollectionViewCell
            let model = categoryArray[indexPath.row]
            cell.display(item: model)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier:
                    OrderTypeCollectionViewCell
                    .reuseIdentifierForOrderType,
                for: indexPath) as! OrderTypeCollectionViewCell
            let model = orderType[indexPath.row]
            cell.display(item: model)
            return cell
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
     layout collectionViewLayout: UICollectionViewLayout,
     sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == categoryCollectionView {
            return CGSize(width: 80, height: 100)
        } else if collectionView == typeOfOrderCollectionView {
            
        }
        return CGSize(width: 105, height: 80)
    }
    
}

extension ViewController: ProductsCellDelegate {
    func didSelectionsProducts(item: Product) {
        let secondVC = storyboard?
            .instantiateViewController(withIdentifier: "second_vc"
            ) as! SecondViewController
        navigationController?.pushViewController(secondVC, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !isLoading {
            searchProducts(by: searchText)
        }
    }
}


