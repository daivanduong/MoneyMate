//
//  ReportViewModelProtocol.swift
//  MoneyMate
//
//  Created by Duong on 13/10/25.
//

import Foundation

protocol ReportViewModelProtocol {
    
    var dataForMonth: [(title: String, subTitle: String, changeDescription: String, amountChange: Double)] {get set}
    var currentMonth: Date {get set}
    var formattedIncome: String {get set}
    var formattedExpense: String {get set}
    var formattedBalance: String {get set}
    var formattedSavingRate: String {get set}
    var balance: Double {get set}
    
    func getDataForPreviousMonth()
    func fetchTotals()
    func moveToPreviousMonth()
    func moveToNextMonth()
    func updateMonthLabel() -> String
}
