//
//  ChartViewModelProtocol.swift
//  MoneyMate
//
//  Created by Duong on 15/10/25.
//

import Foundation
protocol ChartViewModelProtocol {
    var expenseSummary: [(category: String, icon: String, total: Double)] {get set}
    var incomeSummary: [(category: String, icon: String, total: Double)] {get set}
    var totalAmount: Double {get set}
    var currentMonth: Date {get set}
    var segmentIndex: Int {get set}
    var pieChartViewName: String {get set}
    
    func loadTransactionSummary()
    func moveToPreviousMonth()
    func moveToNextMonth()
    func getDataForChart() -> [(category: String, icon: String, total: Double)] 
    func updateMonthLabel() -> String
    func formatCurrency(_ value: Double) -> String
}
