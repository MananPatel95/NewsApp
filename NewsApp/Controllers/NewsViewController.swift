//
//  ViewController.swift
//  NewsApp
//
//  Created by Manan Patel on 2021-05-16.
//

import UIKit
import SafariServices

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    // TableView
    // CustomCell
    // API Caller
    // Open the News Story
    // Search for news stories
    
    var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemBackground
        tv.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return tv
    }()
    
    private let searchVC = UISearchController(searchResultsController: nil)
    
    private let refreshVC = UIRefreshControl()
    
    
    // Data
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = [Article]()
    private var topic = "" {
        didSet {
            fetchTopStoriesWithTopic()
            setTitle()
        }
    }
    private var country = "us" {
        didSet {
            fetchTopStories()
            setTitle()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        
        setTitle()
        fetchTopStories()
        createSearchBar()
        addRefreshControl()
        
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    //MARK: - Private Funcs
    private func setTitle() {
        self.title = "News" + " - " + country.uppercased()
    }
    
    private func setTopicTitle() {
        self.title = "News" + " - " + country.uppercased() + " (\(topic))"
    }
    
    @objc private func fetchTopStories() {
        APICaller.shared.getTopStories(country: country) { [weak self] data in
            switch data{
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title,
                                               subtitle: $0.description ?? "",
                                               imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.setTitle()
                    self?.refreshVC.endRefreshing()
                    self?.searchVC.isActive = false
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func fetchTopStoriesWithTopic() {
        APICaller.shared.searchWithTopics(topic: self.topic, country: self.country) { [weak self] data in
            switch data {
            case .success(let data):
                self?.articles = data
                self?.viewModels = data.compactMap({
                    NewsTableViewCellViewModel.init(title: $0.title,
                                                    subtitle: $0.description ?? "",
                                                    imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.setTopicTitle()
                    self?.refreshVC.endRefreshing()
                    self?.searchVC.isActive = false
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
        
        let button = UIBarButtonItem(image: UIImage.init(systemName: "map"), style: .plain, target: self, action: #selector(presentCountryPicker))
        let button2 = UIBarButtonItem(image: UIImage.init(systemName: "list.bullet.rectangle"), style: .plain, target: self, action: #selector(presentTopics))
        navigationItem.rightBarButtonItems = [button, button2]
    }
    
    @objc func presentCountryPicker() {
        let countryPickerVC = CountryPickerView()
        countryPickerVC.delegate = self
        present(countryPickerVC, animated: true, completion: nil)
        
    }
    
    @objc func presentTopics() {
        let topicsVC = TopicsViewController()
        topicsVC.delegate = self
        present(topicsVC, animated: true, completion: nil)
    }
    
    private func addRefreshControl() {
        refreshVC.addTarget(self, action: #selector(fetchTopStories), for: .valueChanged)
        tableView.refreshControl = refreshVC
    }
    
    //MARK: - Delegate Funcs
    
    // Set the country with a 2 letter code, e.g. "us", "ca", or "jp"
    func setCountry(forCountry country: String) {
        self.country = country
    }
    
    func setTopic(forTopic topic: String){
        print("set topic \(topic)")
        self.topic = topic
    }
    
    
    //MARK: - TableView Funcs
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url) else {return}
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
        
    }
    
    //MARK: - Search Func
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {return}
        
        APICaller.shared.searchWithQuery(query: text) { [weak self] data in
            switch data{
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(title: $0.title,
                                               subtitle: $0.description ?? "",
                                               imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.title = "Results for:"
                    self?.searchVC.dismiss(animated: true, completion: nil)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

