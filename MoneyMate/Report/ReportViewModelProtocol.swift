//
//  ReportViewModelProtocol.swift
//  MoneyMate
//
//  Created by Duong on 13/10/25.
//

import Foundation

protocol ReportViewModelProtocol {
    var formattedIncome: String {get set}
    
    var formattedExpense: String {get set}
    
    var formattedBalance: String {get set}
    
    var formattedSavingRate: String {get set}
    
    func fetchTotals(for month: Int, year: Int)
}
