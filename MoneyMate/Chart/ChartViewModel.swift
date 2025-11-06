//
//  ChartViewModel.swift
//  MoneyMate
//
//  Created by Duong on 15/10/25.
//

import Foundation
import CoreData
import UIKit

class ChartViewModel: ChartViewModelProtocol {
    var pieChartViewName: String = "Chi tiêu"
    
    var expenseSummary: [(category: String, icon: String, total: Double)] = []
    var segmentIndex: Int = 0
    var totalIncome: Double = 0
    var totalExpense: Double = 0
    var totalAmount: Double = 0
    
    var incomeSummary: [(category: String, icon: String, total: Double)] = []
    
    var currentMonth: Date = Date()
    
    func loadTransactionSummary() {
        let date = currentMonth
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let startOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let expenseRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        expenseRequest.predicate = NSPredicate(format: "type == %@ AND date >= %@ AND date < %@",
                                               TransactionType.expense.rawValue,
                                               startOfMonth as NSDate,
                                               endOfMonth as NSDate)
        
        let incomeRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        incomeRequest.predicate = NSPredicate(format: "type == %@ AND date >= %@ AND date < %@",
                                              TransactionType.income.rawValue,
                                              startOfMonth as NSDate,
                                              endOfMonth as NSDate)
        
        do {
            let expense = try context.fetch(expenseRequest)
            let income = try context.fetch(incomeRequest)
            
            // Gom nhóm theo category
            expenseSummary = groupAndSum(expense)
            incomeSummary = groupAndSum(income)
            
            totalIncome = income
                .filter { $0.type == TransactionType.income.rawValue }
                .reduce(0) { $0 + $1.amount }
            
            totalExpense = expense
                .filter { $0.type == TransactionType.expense.rawValue }
                .reduce(0) { $0 + $1.amount }
            
        } catch {
            print("Load transaction summary error: \(error)")
        }
    }
    
    
    func groupAndSum(_ transactions: [Transaction]) -> [(category: String, icon: String, total: Double)] {
        let grouped = Dictionary(grouping: transactions, by: { $0.category })
        
        let result = grouped.compactMap { (key, value) -> (category: String, icon: String, total: Double)? in
            guard let category = key else { return nil }
            let total = value.reduce(0) { $0 + $1.amount }
            return (category: category.name ?? "Khác",
                    icon: category.icon ?? "questionmark.circle",
                    total: total)
        }
        
        return result.sorted { $0.total > $1.total }
    }
    
    
    func getDataForChart() -> [(category: String, icon: String, total: Double)] {
        if segmentIndex == 0 {
            totalAmount = totalExpense
            pieChartViewName = "Chi tiêu"
            return expenseSummary
        } else {
            totalAmount = totalIncome
            pieChartViewName = "Thu nhập"
            return incomeSummary
        }
    }
    
    func moveToNextMonth() {
        let calendar = Calendar.current
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = nextMonth
        }
        loadTransactionSummary()
    }
    
    func moveToPreviousMonth() {
        let calendar = Calendar.current
        if let prevMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = prevMonth
        }
        loadTransactionSummary()
    }
    
    func updateMonthLabel() -> String {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: currentMonth)
        let year = calendar.component(.year, from: currentMonth)
        let monthLable = "Tháng \(month),  \(year)"
        return monthLable
        
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }
    
    
}
