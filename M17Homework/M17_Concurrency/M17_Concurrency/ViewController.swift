//
//  ViewController.swift
//  M17_Concurrency
//
//  Created by Maxim NIkolaev on 08.12.2021.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let service = Service()
    var imageArray: [UIImageView] = []
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
        onLoad()
    }

    private func onLoad() {
        let dispatchGroup = DispatchGroup()
        
        for _ in 0...3 {
            dispatchGroup.enter()
            service.getImageURL { [weak self] urlString, error in
                guard let self = self else { return }
                guard let urlString = urlString else { return }
                DispatchQueue.main.async(group: dispatchGroup) { [weak self] in
                    guard let self = self else { return }
                    sleep(arc4random() % 4)
                    let image = self.service.loadImage(urlString: urlString)
                    let imageView = UIImageView(image: image)
                    imageView.contentMode = .scaleAspectFit
                    self.imageArray.append(imageView)
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
                guard let self = self else {return}
                self.activityIndicator.stopAnimating()
                self.stackView.removeArrangedSubview(self.activityIndicator)
                for i in 0...3 {
                    self.stackView.addArrangedSubview(self.imageArray[i])
                }
            }
        }
        
    }
    
    private func setupViews() {
        view.addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        stackView.addArrangedSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}
