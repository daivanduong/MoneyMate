//
//  HomeViewController.swift
//  MoneyMate
//
//  Created by Duong on 8/10/25.
//

import UIKit
import CoreData
import Charts

class HomeViewController: UIViewController {
    
    @IBOutlet weak var balanceCardView: UIView!
    
    @IBOutlet weak var previousMonthButton: UIButton!
    
    @IBOutlet weak var monthLable: UILabel!
    
    @IBOutlet weak var nextMonthButton: UIButton!
    
    @IBOutlet weak var dateLable: UILabel!
    
    @IBOutlet weak var incomeStackView: UIStackView!
    
    @IBOutlet weak var incomeLable: UILabel!
    
    @IBOutlet weak var expenseStackView: UIStackView!
    
    @IBOutlet weak var expenseLable: UILabel!
    
    @IBOutlet weak var notificationLable: UILabel!
    
    @IBOutlet weak var detailButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var viewModel: HomeViewModelProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLeftNavTitle("Trang chủ")
        setupUI()
        setupTableView()
        updateUI()
        viewModel.getDataForCollectionView()
        setupCollectionView()
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.getDataBalanceCard()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupBalanceCardView()
        
    }
    
    func setupCollectionView() {
        let nib = UINib(nibName: "CategoryViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "categoryViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    

    func setupUI() {
        
        //Button
        [previousMonthButton, nextMonthButton].forEach { button in
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
        }
        //View
        
        [ incomeStackView, expenseStackView].forEach { view in
            view?.layer.cornerRadius = 7
            view?.clipsToBounds = true
            view?.backgroundColor = .clear
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.systemGray4.cgColor
        }
        
    }

    func setupBalanceCardView(){
        balanceCardView.backgroundColor = UIColor.white
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = balanceCardView.bounds
        gradientLayer.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.systemPurple.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        gradientLayer.cornerRadius = 8
        balanceCardView.layer.masksToBounds = true
               
        balanceCardView.layer.insertSublayer(gradientLayer, at: 0)
       
       }
    
    func getDataBalanceCard() {
        viewModel.fetchTotals()
        expenseLable.text = viewModel.formattedExpense
        incomeLable.text = viewModel.formattedIncome
    }
    
    func setupTableView() {
        let nib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "transactionTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.reloadData()
    }
    
    func updateUI() {
        viewModel.loadListTransaction()
        monthLable.text = viewModel.updateMonthLabel()
        notificationLable.isHidden = viewModel.isNotificationShow
        detailButton.isHidden = viewModel.isDetailButtonShow
    }
    
    @IBAction func moveToPreviousMonthButton(_ sender: UIButton) {
        viewModel.moveToPreviousMonth()
        updateUI()
    }
    
    
    @IBAction func moveToNextMonthButton(_ sender: UIButton) {
        viewModel.moveToNextMonth()
        updateUI()

    }
    
    @IBAction func tapOnDetailVC(_ sender: UIButton) {
        
        let monthVC = MonthlyTransactionsViewController(nibName: "MonthlyTransactionsViewController", bundle: nil)
        
        monthVC.listTransaction = viewModel.listTransaction
        monthVC.monthString = viewModel.updateMonthLabel()
        
        
        monthVC.presentationController?.delegate = self
        present(monthVC, animated: true)
        
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < viewModel.listTransaction.count else {
               return UITableViewCell()
           }
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        cell.img.image = UIImage(named: viewModel.getStringIcon(index: indexPath))
        cell.titleLable.text = viewModel.getTitle(index: indexPath)
        cell.subTitleLable.text =  viewModel.getSubTitle(index: indexPath)
        cell.amountLable.text = viewModel.getAmountLable(index: indexPath)
        
        cell.amountLable.textColor = viewModel.getTextColor(index: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Xoá") { _, _, completion in
            self.viewModel.deleteTransaction(at: indexPath)
            self.updateUI()
            tableView.reloadData()
            completion(true)
        }
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

extension HomeViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewModel.loadListTransaction()
        tableView.reloadData()
        getDataBalanceCard()
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataColectionView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryViewCell", for: indexPath) as! CategoryViewCell
        cell.imgView.image = UIImage(named: viewModel.dataColectionView[indexPath.row].icon!)
        cell.titleLable.text = viewModel.dataColectionView[indexPath.row].name
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (collectionView.frame.width - 15) / 4
        return CGSize(width: w, height: 70)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let addVC = AddViewController(nibName: "AddViewController", bundle: nil)
        addVC.viewModel = AddViewModel()
        addVC.viewModel.selectedCategory = viewModel.dataColectionView[indexPath.row]
        addVC.viewModel.backToHomeScreen = {
            self.updateUI()
        }
        
        addVC.modalPresentationStyle = .formSheet
        present(addVC, animated: true)
    }
    
}
