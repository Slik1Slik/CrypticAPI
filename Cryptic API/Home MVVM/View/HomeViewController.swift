//
//  HomeViewController.swift
//  Cryptic API
//
//  Created by Slik on 04.10.2022.
//

import UIKit

final class HomeViewController: UIViewController {
    
    lazy var searchBar: UISearchBar = UISearchBar()
    
    var tableView: UITableView = UITableView()
    
    let noResultsPlugLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "No assets found"
        label.textColor = .systemGray3
        return label
    }()
    
    private var viewModel: HomeViewModelProtocol = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupConstraints()
        setupSearchBar()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.update()
    }
}
//MARK: - Setup UI
extension HomeViewController {
    
    private func addSubviews() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(noResultsPlugLabel)
    }
    
    private func setupSearchBar() {
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "BTC"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.inputAccessoryView = keyboardToolbar()
        navigationItem.titleView = searchBar
    }
    
    private func keyboardToolbar() -> UIToolbar {
        let bar = UIToolbar()
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .plain,
                                         target: self,
                                         action: #selector(keyboardToolbarDoneButtonTapped))
        bar.items = [doneButton]
        bar.sizeToFit()
        return bar
    }
    
    @objc private func keyboardToolbarDoneButtonTapped() {
        view.hideKeyboard()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseId)
    }
    
    private func updateNoResultsPlugLabelVisability(isDataLoading: Bool) {
        noResultsPlugLabel.isHidden = viewModel.representedData.isEmpty || !isDataLoading
    }
}
//MARK: - Layout
extension HomeViewController {
    
    private func setupConstraints() {
        setupTableViewConstraints()
        setupNoResultsPlugLabelConstraints()
    }
    
    private func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pin(to: view)
    }
    
    private func setupNoResultsPlugLabelConstraints() {
        noResultsPlugLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noResultsPlugLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultsPlugLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
//MARK: - SearchBar
extension HomeViewController : UISearchBarDelegate  {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        viewModel.search(text: textSearched)
    }
}
//MARK: - Table view data source
extension HomeViewController : UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.representedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseId, for: indexPath) as? HomeTableViewCell else {
            return .init()
        }
        
        cell.configure(title: viewModel.representedData[indexPath.row].title,
                       subtitle: viewModel.representedData[indexPath.row].subtitle,
                       details: viewModel.representedData[indexPath.row].details)
        
        return cell
    }
}
//MARK: - Table view delegate
extension HomeViewController : UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.select(atIndex: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: - ViewModel
extension HomeViewController : ViewModelListener {
    
    typealias ViewModel = HomeViewModelProtocol
    
    func set(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    func listen() {
        listenTaskChanged()
        listenSearchCompleted()
        listenErrorReceived()
    }
    
    private func listenTaskChanged() {
        viewModel.onTaskStateChanged = { [weak self] taskState in
            switch taskState {
            case .inProgress:
                self?.updateNoResultsPlugLabelVisability(isDataLoading: true)
                self?.startAnimatingIndicator()
            case .finished:
                self?.stopAnimatingIndicator()
                self?.tableView.reloadData()
                self?.updateNoResultsPlugLabelVisability(isDataLoading: false)
            default: self?.stopAnimatingIndicator()
            }
        }
    }
    
    private func listenSearchCompleted() {
        viewModel.onSearchCompleted = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.updateNoResultsPlugLabelVisability(isDataLoading: false)
        }
    }
    
    private func listenErrorReceived() {
        viewModel.onError = { [weak self] error in
            self?.handle(error)
        }
    }
}
//MARK: - Error handling
extension HomeViewController {
    
    private func handle(_ error: HomeViewModelError) {
        switch error {
        case .someDataLost(let apiError):
            let tryAgainAction = UIAlertAction(title: "Try again",
                                               style: .default) { [weak self] _ in
                self?.viewModel.update()
            }
            presentActionAlert(title: apiError.title,
                               message: apiError.description,
                               secondaryAction: tryAgainAction)
        case .noInternetConnection:
            presentInfoAlert(title: error.title, message: error.description)
        }
    }
}
