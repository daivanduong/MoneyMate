//
//  ProfileViewController.swift
//  MoneyMate
//
//  Created by Duong on 8/10/25.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let data: [[[String]]] = [
        [
            ["user.png", "Đại Văn Dương", "Hồ sơ cá nhân"],
            
        ],
        [
            ["wallet.png", "Ví chính", "9.500.000đ"],
            ["atm-card.png", "Thẻ ngân hàng", "2 thẻ đã liên kết"]
        ],
        [
            ["bell.png", "Thông báo", "Bật"],
            ["lock.png", "Bảo mật", "Face ID, Mật khẩu"],
            ["cloud.png", "Sao lưu", "Đã sao lưu 2 giờ trước"],
            ["half-moon.png", "Chế độ tối", "Tắt"],
            
        ],
        [
            ["question-mark", "Trung tâm trợ giúp", "Câu hỏi thường gặp"],
            ["star.png", "Đánh giá ứng dụng", "Chia sẻ ý kiến của bạn"]
        ]
    ]
    
    let sectionTitles = ["Tôi", "Tài khoản", "Cài đặt", "Hỗ trợ"]
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setLeftNavTitle("Tôi")
        setupTableView()
        setupHeaderView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "profileTableViewCell")
    }
    
    func setupHeaderView() {
        let nib = UINib(nibName: "CustomHeaderView", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "customHeaderView")
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileTableViewCell") as! ProfileTableViewCell
        let dataForSection = data[indexPath.section][indexPath.row]
        cell.img.image = UIImage(named: "\(dataForSection[0])")
        cell.titleLable.text = dataForSection[1]
        cell.subTitleLable.text = dataForSection[2]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "customHeaderView") as! CustomHeaderView
        header.titleForLable.text = sectionTitles[section]
        
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 40
    }
}
