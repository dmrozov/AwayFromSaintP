//
//  SearchViewController.swift
//  AwayFromSaintP
//
//  Created by Dmitry Rozov on 21/11/2019.
//  Copyright © 2019 Dmitry Rozov. All rights reserved.
//

import UIKit

private let segueShowMap = "showMap"

class SearchViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.registerNibs(for: [LoadingTableViewCell.self, DestinationTableViewCell.self])
            tableView.tableFooterView = UIView()
        }
    }

    private lazy var messageLabel = tableView.addBackgroundMessageLabel(with: "Ничего не найдено :c")

    let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.updateHandler = { [weak self] in
            self?.tableView.reloadData()
            self?.messageLabel.isHidden = self?.viewModel.state != .error
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        searchBar.becomeFirstResponder()
    }

    @IBAction func cancelButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.state {
        case .loading: return 1
        case .list: return viewModel.destinations.count
        case .clear, .error: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.state {
        case .loading:
            return tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.identifier, for: indexPath)
        case .list:
            let cell = tableView.dequeueReusableCell(withIdentifier: DestinationTableViewCell.identifier, for: indexPath) as! DestinationTableViewCell
            cell.viewModel = viewModel.cellViewModel(for: indexPath.row)
            return cell
        case .clear, .error: return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let vc = MapViewController()
        vc.destination = viewModel.destinations[indexPath.row]
        present(vc, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.query = searchText
    }
}
