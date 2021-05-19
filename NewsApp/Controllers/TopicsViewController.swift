//
//  conViewController.swift
//  NewsApp
//
//  Created by Manan Patel on 2021-05-18.
//

import UIKit

class TopicsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var topics = ["Business", "Entertainment", "General", "Health", "Science","Sports", "Technology"]
    private var selectedTopics = ""
    
    var topicsTableView: UITableView = {
        let tv = UITableView()
        tv.clipsToBounds = true
        return tv
    }()
    
    var delegate: NewsViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(topicsTableView)
        topicsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        topicsTableView.frame = view.frame
        topicsTableView.delegate = self
        topicsTableView.dataSource = self
        topicsTableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = topicsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = topics[indexPath.row]
        return cell
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        topicsTableView.deselectRow(at: indexPath, animated: true)
        print("set topic in vc \(topics[indexPath.row])")
        delegate?.setTopic(forTopic: topics[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}

protocol TopicsProtocol: TopicsViewController {
    func setTopic(topic: String)
}
