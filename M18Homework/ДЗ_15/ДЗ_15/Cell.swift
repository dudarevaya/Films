//
//  TabCell.swift
//  ДЗ_15
//
//  Created by Сергей Щукин on 15.04.2022.
//

import Foundation
import UIKit
import SnapKit

class Cell: UITableViewCell {
    
    private lazy var title: UILabel = {
       let label = UILabel()
        label.font = Constants.Fonts.header
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var info: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = Constants.Fonts.info
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        image.backgroundColor = Constants.Colors.gray
        return image
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.frame = CGRect(x: 45, y: 45, width: 10, height: 10)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(title)
        contentView.addSubview(info)
        contentView.addSubview(image)
        
        setupConstraints()
        
        image.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadImage(urlString: String) -> UIImage? {
        guard
            let url = URL(string: urlString),
            let data = try? Data(contentsOf: url)
        else {
            print("Ошибка, не удалось загрузить изображение")
            return nil
        }
        return UIImage(data: data)
    }
    
    func configure(_ viewModel: Results) {
        let dispatchGroup = DispatchGroup()
        
        title.text = viewModel.title
        info.text = viewModel.resultDescription
        dispatchGroup.enter()
        DispatchQueue.main.async(group: dispatchGroup) { [weak self] in
            self?.image.image = self?.loadImage(urlString: viewModel.image)
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else {return}
            self.activityIndicator.stopAnimating()
            self.image.backgroundColor = .white
        }
    }
    
    private func setupConstraints() {
        image.translatesAutoresizingMaskIntoConstraints = false
        image.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(10)
            make.top.equalTo(15)
            make.trailing.equalToSuperview()
        }
        
        info.translatesAutoresizingMaskIntoConstraints = false
        info.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(10)
            make.top.equalTo(title.snp.bottom).offset(10)
            make.trailing.equalToSuperview()
        }
//
//        date.translatesAutoresizingMaskIntoConstraints = false
//        date.snp.makeConstraints { make in
//            make.trailing.equalTo(-16)
//            make.top.equalTo(18)
//        }
    }
}
