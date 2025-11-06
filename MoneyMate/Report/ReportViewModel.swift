//
//  ReportViewModel.swift
//  MoneyMate
//
//  Created by Duong on 13/10/25.
//

import Foundation
import CoreData
import UIKit

class ReportViewModel: ReportViewModelProtocol {
    
    var dataForMonth: [(title: String, subTitle: String, changeDescription: String, amountChange: Double)] = []
  
    var formattedIncome: String = ""
    
    var formattedExpense: String = ""
    
    var formattedBalance: String = ""
    
    var formattedSavingRate: String = ""
    
    var totalIncome: Double = 0
    
    var totalExpense: Double = 0
    
    var balance: Double = 0
    
    var formattedIncomePrev: String = ""
    
    var formattedExpensePrev: String = ""
    
    var formattedBalancePrev: String = ""
    
    var formattedSavingRatePrev: String = ""
    
    var totalIncomePrev: Double = 0
    
    var totalExpensePrev: Double = 0
    
    var balancePrev: Double = 0
    
    
    
    
    var currentMonth: Date = Date()
    
    func fetchTotals() {
        let date = currentMonth
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
            
        let startOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        
            
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@",
                                               startOfMonth as NSDate,
                                               endOfMonth as NSDate)
        do {
            let monthlyTransactions = try context.fetch(request)
           
            totalIncome = monthlyTransactions
                .filter { $0.type == TransactionType.income.rawValue}
                .reduce(0) { $0 + $1.amount }
                
            totalExpense = monthlyTransactions
                .filter { $0.type == TransactionType.expense.rawValue }
                .reduce(0) { $0 + $1.amount }
            
            balance = totalIncome - totalExpense
            formattedIncome = "\(formatCurrency(totalIncome))₫"
            formattedExpense = "\(formatCurrency(totalExpense))₫"
            formattedBalance = "\(formatCurrency(balance))₫"
            if totalExpense < totalIncome {
                let moneySaving = balance/totalIncome
                let money = (moneySaving*100).rounded() / 100
                   
                formattedSavingRate = String(format: "%.0f", money*100) + "%"
            } else {
                formattedSavingRate = "0%"
            }
            getDataForPreviousMonth()
            getDataForTableView()
        } catch {
            totalIncome = 0
            totalExpense = 0
        }
    }
    
    
    
    func formatCurrency(_ value: Double) -> String {
       let formatter = NumberFormatter()
       formatter.numberStyle = .decimal
       formatter.groupingSeparator = "."
       return formatter.string(from: NSNumber(value: value)) ?? "0"
   }
    
    func moveToNextMonth() {
        let calendar = Calendar.current
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = nextMonth
        }
        fetchTotals()
    }

    func moveToPreviousMonth() {
        let calendar = Calendar.current
        if let prevMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = prevMonth
        }
        fetchTotals()
    }
    
    func updateMonthLabel() -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: currentMonth)
        let year = calendar.component(.year, from: currentMonth)
        let monthLable = "Tháng \(month),  \(year)"
        return monthLable
        
    }
    
    func getDataForPreviousMonth() {
        let calendar = Calendar.current
        var prevMonth: Date = Date()
        if let month = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            prevMonth = month
        }
        
        let date = prevMonth
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let startOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        
            
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@",
                                               startOfMonth as NSDate,
                                               endOfMonth as NSDate)
        do {
            let monthlyTransactions = try context.fetch(request)
            totalIncomePrev = monthlyTransactions
                .filter { $0.type == TransactionType.income.rawValue }
                .reduce(0) { $0 + $1.amount }
                
            totalExpensePrev = monthlyTransactions
                .filter { $0.type == TransactionType.expense.rawValue }
                .reduce(0) { $0 + $1.amount }
            
            balancePrev = totalIncomePrev - totalExpensePrev
            
            formattedIncomePrev = "\(formatCurrency(totalIncomePrev))₫"
            formattedExpensePrev = "\(formatCurrency(totalExpensePrev))₫"
            formattedBalancePrev = "\(formatCurrency(balancePrev))₫"
            
            if totalExpensePrev < totalIncomePrev {
                let moneySaving = balancePrev/totalIncomePrev
                let money = (moneySaving*100).rounded() / 100
                   
                formattedSavingRatePrev = String(format: "%.0f", money*100) + "%"
            } else {
                formattedSavingRatePrev = "0%"
            }
            
            
        } catch {
            totalIncomePrev = 0
            totalExpensePrev = 0
        }
    }
    
    func getDataForTableView(){
        
        let differenceIncome = totalIncome - totalIncomePrev
        let differenceExpense = totalExpense - totalExpensePrev
        let differenceBalance = balance - balancePrev
        
        dataForMonth = [
            ((title: "Thu nhập", subTitle: (formattedIncome + " vs " + formattedIncomePrev), changeDescription: getStatus(differenceIncome), amountChange: differenceIncome)),
            ((title: "Chi tiêu", subTitle: (formattedExpense + " vs " + formattedExpensePrev), changeDescription: getStatus(differenceExpense), amountChange:differenceExpense)),
            ((title: "Tiết kiệm", subTitle: (formattedBalance + " vs " + formattedBalancePrev), changeDescription: getStatus(differenceBalance), amountChange: differenceBalance))
        ]
        
    }
    
    func getStatus(_ differenceAmount: Double) -> String {
        
        if differenceAmount > 0 {
            return "↑ " + formatCurrency(differenceAmount) + "₫"
        } else if differenceAmount == 0 {
            return "---"
        } else {
            return "↓ " + formatCurrency(-differenceAmount) + "₫"
        }

    }
    
    
}


