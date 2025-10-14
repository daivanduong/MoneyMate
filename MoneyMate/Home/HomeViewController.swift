//
//  HomeViewController.swift
//  MoneyMate
//
//  Created by Duong on 8/10/25.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var balanceCardView: UIView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var dateLable: UILabel!
    
    @IBOutlet weak var forthButton: UIButton!
    
    @IBOutlet weak var incomeView: UIView!
    
    @IBOutlet weak var incomeLable: UILabel!
    
    
    @IBOutlet weak var expenditureView: UIView!
    
    @IBOutlet weak var expenseLable: UILabel!
    
    @IBOutlet weak var shoppingView: UIView!
    
    @IBOutlet weak var gasView: UIView!
    
    @IBOutlet weak var eatingView: UIView!
    
    @IBOutlet weak var otherView: UIView!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: HomeViewModelProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setLeftNavTitle("Trang chủ")
        setupUI()
        setupTableView()
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.getDataBalanceCard()
            }
        }
        viewModel.loadListTransaction()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadListTransaction()
        tableView.reloadData()
        getDataBalanceCard()
        print(1)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupBalanceCardView()
        
    }

    func setupUI() {
        
        //Button
        [backButton, forthButton].forEach { button in
            button.layer.cornerRadius = button.frame.height / 2
            button.clipsToBounds = true
        }
        //View
        
        [ incomeView, expenditureView].forEach { view in
            view?.layer.cornerRadius = 7
            view?.clipsToBounds = true
            view?.backgroundColor = .clear
            view?.layer.borderWidth = 1
            view?.layer.borderColor = UIColor.systemGray4.cgColor
        }
        
        [shoppingView, gasView, eatingView, otherView].forEach { view in
            view?.layer.cornerRadius = 8
            view?.clipsToBounds = true
            
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
        viewModel.fetchTotals(for: 10, year: 2025)
        expenseLable.text = viewModel.formattedExpense
        incomeLable.text = viewModel.formattedIncome
    }
    
    func setupTableView() {
        let nib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "transactionTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    
    @IBAction func tapOnDetailVC(_ sender: UIButton) {
        
        let monthVC = MonthlyTransactionsViewController(nibName: "MonthlyTransactionsViewController", bundle: nil)
        monthVC.presentationController?.delegate = self
        present(monthVC, animated: true)
        
    }
    
    
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        cell.img.image = UIImage(named: viewModel.getStringIcon(index: indexPath))
        cell.titleLable.text = viewModel.getTitle(index: indexPath)
        cell.subTitleLable.text =  viewModel.getSubTitle(index: indexPath)
        cell.amountLable.text = viewModel.getAmountLable(index: indexPath)
        
        cell.amountLable.textColor = viewModel.getTextColor(index: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            viewModel.deleteTransaction(at: indexPath)
        }
        tableView.reloadData()
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
