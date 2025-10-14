//
//  MainTabBarController.swift
//  MoneyMate
//
//  Created by Duong on 8/10/25.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTabBar()
        self.delegate = self
    }
    
    private func setupTabBar() {
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
        homeVC.viewModel = HomeViewModel()
        let chartVC = ChartViewController(nibName: "ChartViewController", bundle: nil)
        let addVC = AddViewController(nibName: "AddViewController", bundle: nil)
        let reportVC = ReportViewController(nibName: "ReportViewController", bundle: nil)
        reportVC.viewmodel = ReportViewModel()
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        
        homeVC.tabBarItem = UITabBarItem(title: "Home",
                                            image: UIImage(systemName: "house"),
                                            selectedImage: UIImage(systemName: "house.fill"))
        homeVC.tabBarItem.tag = 0
        
        chartVC.tabBarItem = UITabBarItem(title: "Chart",
                                           image: UIImage(systemName: "chart.pie"),
                                           selectedImage: UIImage(systemName: "chart.pie.fill"))
        chartVC.tabBarItem.tag = 1
        addVC.tabBarItem = UITabBarItem(title: "Add",
                                            image: UIImage(systemName: "plus.circle"),
                                            selectedImage: UIImage(systemName: "plus.circle.fill"))
        addVC.tabBarItem.tag = 2
        reportVC.tabBarItem = UITabBarItem(title: "Report",
                                           image: UIImage(systemName: "chart.pie"),
                                           selectedImage: UIImage(systemName: "chart.pie.fill"))
        
        reportVC.tabBarItem.tag = 3
        profileVC.tabBarItem = UITabBarItem(title: "Me",
                                            image: UIImage(systemName: "person"),
                                            selectedImage: UIImage(systemName: "person.fill"))
        profileVC.tabBarItem.tag = 4
            
            let controllers = [
                UINavigationController(rootViewController: homeVC),
                UINavigationController(rootViewController: chartVC),
                UINavigationController(rootViewController: addVC),
                UINavigationController(rootViewController: reportVC),
                UINavigationController(rootViewController: profileVC)
            ]
            viewControllers = controllers

            tabBar.tintColor = .systemBlue      // Màu icon được chọn
            tabBar.unselectedItemTintColor = .gray
            tabBar.backgroundColor = .systemBackground
        }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            if viewController.tabBarItem.tag == 2 {
                let addVC = AddViewController(nibName: "AddViewController", bundle: nil)
                addVC.modalPresentationStyle = .formSheet
                addVC.backToHomeScreen = { [weak self] in
                    guard let self = self else { return }
                    self.selectedIndex = 0
                    if let homeNav = self.viewControllers?.first as? UINavigationController,
                        let homeVC = homeNav.topViewController as? HomeViewController {
                        homeVC.viewModel.loadListTransaction()
                    }
                }
                present(addVC, animated: true)
                return false
            }
            return true
    }

}

extension UIViewController {
    func setLeftNavTitle(_ title: String, font: UIFont = .boldSystemFont(ofSize: 30)) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = font
        titleLabel.textColor = .label
        
        let titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = titleItem
    }
}

