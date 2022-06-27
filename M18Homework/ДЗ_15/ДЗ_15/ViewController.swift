//
//  ViewController.swift
//  ДЗ_15
//
//  Created by Сергей Щукин on 10.04.2022.
//

import UIKit
import SnapKit
import Foundation

class ViewController: UIViewController {
    
    let cell = "Cell"
    
    var filmNetworkManager = FilmNetworkManager()
    private var timer: Timer?
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for films"
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    let cellInfo = [Films]()
    var welcome: Welcome? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        self.navigationItem.title = "Films"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(Cell.self, forCellReuseIdentifier: cell)
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        
        setupViews()
        setupConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(searchBar)
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.bottom.equalTo(tableView.snp.topMargin)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell) as? Cell
        let viewModel = (welcome?.results[indexPath.row])
        cell?.configure(viewModel!)
//        cell?.textLabel?.text = viewModel?.title
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return welcome?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDelegate {}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var urlString = "https://imdb-api.com/API/Search/k_07ka81uf/\(searchText)"
        if searchText != "" {
            let search = searchText.split(separator: " ").joined(separator: "%20")
            urlString = "https://imdb-api.com/API/Search/k_07ka81uf/\(search)"
        }
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.filmNetworkManager.fetchFilm(forFilm: urlString) { (searchResponse) in
                    guard let searchResponse = searchResponse else { return }
                    self.welcome = searchResponse
                    self.tableView.reloadData()
            }
        })
        
    }
}
