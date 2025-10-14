//
//  HomeViewModelProtocol.swift
//  MoneyMate
//
//  Created by Duong on 12/10/25.
//

import Foundation
import CoreData
import UIKit

protocol HomeViewModelProtocol {
    var formattedIncome: String { get set}
    var formattedExpense: String { get set}
    var formattedBalance: String { get set}
    var onDataUpdated: (() -> Void)? {get set}
    var listTransaction: [Transaction] {get set}
    func loadListTransaction()
    func fetchTotals(for month: Int, year: Int)
    func numberOfRowsInSection(section: Int) -> Int
    func getStringIcon(index: IndexPath) -> String
    func getTitle(index: IndexPath) -> String
    func getSubTitle(index: IndexPath) -> String
    func getAmountLable(index: IndexPath) -> String
    func getTextColor(index: IndexPath) -> UIColor
    func deleteTransaction(at indexPath: IndexPath)
}
