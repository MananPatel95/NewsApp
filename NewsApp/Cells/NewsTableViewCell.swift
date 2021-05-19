//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Manan Patel on 2021-05-16.
//

import UIKit

class NewsTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init (
        title: String,
        subtitle: String,
        imageURL: URL?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}

class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.layer.masksToBounds = true
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(newsImageView)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 16,
                                  y: 0,
                                  width: contentView.frame.width - 170,
                                  height: 80)
        subtitleLabel.frame = CGRect(x: 16,
                                     y: 80,
                                     width: contentView.frame.width - 170,
                                     height: contentView.frame.height / 2)
        newsImageView.frame = CGRect(x: contentView.frame.size.width - 140,
                                     y: 10,
                                     width: 150,
                                     height: contentView.frame.size.height - 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        newsImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        }
        
        else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else { return }
                
                viewModel.imageData = data
                
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }

}
