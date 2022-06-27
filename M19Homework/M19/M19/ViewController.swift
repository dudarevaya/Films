//
//  ViewController1.swift
//  M19
//
//  Created by Сергей Щукин on 26.06.2022.
//

import Foundation
import UIKit
import SnapKit
import Alamofire


class ViewController: UIViewController {
    
    let networkManager = NetworkManager()
    
    var nameText = ""
    var lastNameText = ""
    var birthText = 0
    var countryText = ""
    var occupationText = ""
    
    var json = """
        {
        }
    """
    let model: Model? = nil
    
    //MARK: Views
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name:"
        return label
    }()
    
    private lazy var nameInput: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        
        textField.addTarget(self, action: #selector(checkError(textField:)), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var errorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last name:"
        return label
    }()
    
    private lazy var lastNameInput: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        
        textField.addTarget(self, action: #selector(checkError(textField:)), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var errorLastNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var birthLabel: UILabel = {
        let label = UILabel()
        label.text = "Year of birth:"
        return label
    }()
    
    private lazy var birthInput: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        
        textField.addTarget(self, action: #selector(checkError(textField:)), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var errorBirthLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var occupationLabel: UILabel = {
        let label = UILabel()
        label.text = "Type of employment:"
        return label
    }()
    
    private lazy var occupationInput: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        
        textField.addTarget(self, action: #selector(checkError(textField:)), for: .editingChanged)
        
        return textField
    }()
    
    private lazy var errorOccupationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.text = "Country:"
        return label
    }()
    
    var countries: [String] = []
    
    private lazy var countryInput: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        textField.inputView = pickerView
        
        return textField
    }()
    
    private lazy var buttonURLSession: UIButton = {
        let button = UIButton()
        button.setTitle("URLSession", for: .normal)
        button.backgroundColor = .gray
        
        button.addTarget(self, action: #selector(sendRequestWithURLSession), for: .touchUpInside)
        return button
    }()
    
    private lazy var resultURLSession: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var buttonAlamofire: UIButton = {
        let button = UIButton()
        button.setTitle("Alamofire", for: .normal)
        button.backgroundColor = .gray
        
        button.addTarget(self, action: #selector(sendRequestWithAlamofire), for: .touchUpInside)
        return button
    }()
    private lazy var resultAlamofire: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(nameInput)
        stackView.addArrangedSubview(errorNameLabel)
        stackView.addArrangedSubview(lastNameLabel)
        stackView.addArrangedSubview(lastNameInput)
        stackView.addArrangedSubview(errorLastNameLabel)
        stackView.addArrangedSubview(birthLabel)
        stackView.addArrangedSubview(birthInput)
        stackView.addArrangedSubview(errorBirthLabel)
        stackView.addArrangedSubview(occupationLabel)
        stackView.addArrangedSubview(occupationInput)
        stackView.addArrangedSubview(errorOccupationLabel)
        stackView.addArrangedSubview(countryLabel)
        stackView.addArrangedSubview(countryInput)
        stackView.addArrangedSubview(buttonURLSession)
        stackView.addArrangedSubview(resultURLSession)
        stackView.addArrangedSubview(buttonAlamofire)
        stackView.addArrangedSubview(resultAlamofire)
        stackView.spacing = 5
        stackView.setCustomSpacing(20, after: countryInput)
        return stackView
    }()
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "POST"
        
        self.countries = self.getCountryList()
        
        setupViews()
        setupConstraints()
    }
    
    // MARK: ViewModels
    
    @objc func sendRequestWithURLSession() {
        let jsonData = networkManager.getData(string: json)
        var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                if error != nil {
                    self?.displayErrorURLSession()
                }
                guard data != nil else { return }
                self?.displaySuccessURLSession()
            }
        }.resume()
    }
    
    func displayErrorURLSession() {
        resultURLSession.textColor = .systemRed
        resultURLSession.text = "Failure"
    }
    func displaySuccessURLSession() {
        resultURLSession.textColor = .systemGreen
        resultURLSession.text = "Success"
    }
    
    @objc func sendRequestWithAlamofire() {
        let jsonData = networkManager.getData(string: json)
        AF.request(
            "https://jsonplaceholder.typicode.com/posts",
            method: .post,
            parameters: jsonData,
            encoder: JSONParameterEncoder.default
        ).response { [weak self] response in
            guard response.error == nil else {
                self?.displayErrorAlamofire()
                return
            }
            self?.displaySuccessAlamofire()
            
            debugPrint(response)
        }
    }
    
    func displayErrorAlamofire() {
        resultAlamofire.textColor = .systemRed
        resultAlamofire.text = "Failure"
    }
    func displaySuccessAlamofire() {
        resultAlamofire.textColor = .systemGreen
        resultAlamofire.text = "Success"
    }
    
    @objc func checkError(textField: UITextField) {
         if textField == nameInput {
             for t in textField.text! {
                 if t.isNumber {
                     errorNameLabel.text = "invalid input"
                     errorNameLabel.textColor = .systemRed
                 } else {
                     errorNameLabel.text = ""
                 }
             }
             nameText = textField.text!
         } else if textField == lastNameInput {
             for t in textField.text! {
                 if t.isNumber {
                     errorLastNameLabel.text = "invalid input"
                     errorLastNameLabel.textColor = .systemRed
                 } else {
                     errorLastNameLabel.text = ""
                 }
             }
             lastNameText = textField.text!
         } else if textField == birthInput {
             for t in textField.text! {
                 if t.isNumber == false || textField.text?.count != 4 {
                     errorBirthLabel.text = "invalid input"
                     errorBirthLabel.textColor = .systemRed
                 } else {
                     errorBirthLabel.text = ""
                 }
             }
             birthText = Int(textField.text!) ?? 0
         } else if textField == occupationInput {
             for t in textField.text! {
                 if t.isNumber {
                     errorOccupationLabel.text = "invalid input"
                     errorOccupationLabel.textColor = .systemRed
                 } else {
                     errorOccupationLabel.text = ""
                 }
             }
             occupationText = textField.text!
         }
        json = """
            {
            "birth": \(birthText),
            "occupation": \(occupationText),
            "name": \(nameText),
            "lastname": \(lastNameText),
            "country": \(countryText)
            }
        """
    }

    func getCountryList() -> [String] {
        var countries: [String] = []
        for code in NSLocale.isoCountryCodes {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: .identifier, value: id) ?? "Country not found"
            countries.append(name)
        }
        return countries
    }
    
    private func setupViews() {
    view.addSubview(stackView)
    }
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
    }
}

// MARK: Extensions
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.countries.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countries[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.countryInput.text = self.countries[row]
    }
}
