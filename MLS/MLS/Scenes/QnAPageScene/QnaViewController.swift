//
//  QnaViewController.swift
//  MLS
//
//  Created by JINHUN CHOI on 2024/01/24.
//

import UIKit

import SnapKit

class QnaViewController: UIViewController {
    // MARK: Properties
    private let viewModel = QnAPageViewModel()
    
    // MARK: Components
    private let qnaTableView = UITableView()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

private extension QnaViewController {
    // MARK: SetUp
    func setUp() {
        qnaTableView.delegate = self
        qnaTableView.dataSource = self
        
        setUpConstraints()
    }
    
    func setUpConstraints() {
        view.addSubview(qnaTableView)
        
        qnaTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

private extension QnaViewController {
    // MARK: Bind
}

private extension QnaViewController {
    // MARK: Method
}

extension QnaViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
            return 2
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.viewModel.getContactCount() : self.viewModel.getQuestionCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if indexPath.section == 0 {
            let item = self.viewModel.getContactList()[indexPath.row]
            cell.imageView?.tintColor = .systemOrange
            cell.imageView?.image = item.icon
            cell.textLabel?.text = item.title
        } else {
            let item = self.viewModel.getQuestionList()[indexPath.row]
            cell.textLabel?.text = "\(indexPath.row + 1) . \(item.title)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLabel = UILabel()
        headerLabel.font = UIFont.boldSystemFont(ofSize: 24)
        headerLabel.textAlignment = .center
        headerLabel.textColor = .black
        headerLabel.text = section == 0 ? "문의하기" : "자주 찾는 질문"
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(headerLabel)

        headerLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(headerView)
            $0.bottom.equalTo(headerView).inset(Constants.defaults.vertical)
        }

        return headerView
    }
}
