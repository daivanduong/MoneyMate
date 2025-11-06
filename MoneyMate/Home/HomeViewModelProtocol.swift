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
    var currentMonth: Date {get set}
    var formattedIncome: String { get set}
    var formattedExpense: String { get set}
    var formattedBalance: String { get set}
    var onDataUpdated: (() -> Void)? {get set}
    var listTransaction: [Transaction] {get set}
    var isDetailButtonShow: Bool {get set}
    var isNotificationShow: Bool {get set}
    var dataColectionView: [Category] {get set}
    
    func getCategoryByName(_ name: String) -> Category?
    func moveToNextMonth()
    func moveToPreviousMonth()
    func loadListTransaction()
    func updateMonthLabel() -> String
    func getDataForCollectionView()
    func fetchTotals()
    func numberOfRowsInSection(section: Int) -> Int
    func getStringIcon(index: IndexPath) -> String
    func getTitle(index: IndexPath) -> String
    func getSubTitle(index: IndexPath) -> String
    func getAmountLable(index: IndexPath) -> String
    func getTextColor(index: IndexPath) -> UIColor
    func deleteTransaction(at indexPath: IndexPath)
}
