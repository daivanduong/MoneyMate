//
//  MonthlyTransactionsViewController.swift
//  MoneyMate
//
//  Created by Duong on 13/10/25.
//

import UIKit
import CoreData

class MonthlyTransactionsViewController: UIViewController {

    @IBOutlet weak var monthLable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var listTransaction: [Transaction] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        //loadListTransaction()
        fetchTotals()
    }
    func setupTableView() {
        let nib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "transactionTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    func loadListTransaction() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
          
        do {
            listTransaction =  try context.fetch(request)
        } catch {
            print("error: \(error)")
        }
        
    }
    func fetchTotals(for month: Int = 10, year: Int = 2025) {
           
            do {
                let allTransactions = try context.fetch(fetchRequest)
                let calendar = Calendar.current
                
                // Lọc theo tháng & năm
                let monthlyTransactions = allTransactions.filter { transaction in
                    guard let date = transaction.date else { return false }
                    let comps = calendar.dateComponents([.month, .year], from: date)
                    return comps.month == month && comps.year == year
                }
                listTransaction = monthlyTransactions
                
            } catch {
                print("Lỗi fetch:", error)
               
            }
        }
}


extension MonthlyTransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTransaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        cell.img.image = UIImage(named: (listTransaction[indexPath.row].category?.icon)!)
        cell.titleLable.text = listTransaction[indexPath.row].note
        cell.subTitleLable.text =  formatChatDate(listTransaction[indexPath.row].date!) + "   -   " + (listTransaction[indexPath.row].category?.name)!
        if listTransaction[indexPath.row].type == "income" {
            cell.amountLable.text = "+" + formatCurrency(listTransaction[indexPath.row].amount) + "đ"
            cell.amountLable.textColor = .green
        } else {
            cell.amountLable.text = "-" + formatCurrency(listTransaction[indexPath.row].amount) + "đ"
            cell.amountLable.textColor = .red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
            forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let transaction = listTransaction[indexPath.row]
            context.delete(transaction)
            listTransaction.remove(at: indexPath.row)
            do {
                try context.save()
            } catch {
                print("\(error)")
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}

func formatChatDate(_ date: Date) -> String {
    let calendar = Calendar.current
    
     if calendar.isDate(date, equalTo: Date(), toGranularity: .year) {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd/MM"
        return dayFormatter.string(from: date)
        
    } else {
        let fullFormatter = DateFormatter()
        fullFormatter.dateFormat = "dd/MM/yyyy"
        return fullFormatter.string(from: date)
    }
}


func formatCurrency(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = "."
    return formatter.string(from: NSNumber(value: value)) ?? "0"
}
