//
//  Constraints.swift
//  ДЗ_15
//
//  Created by Сергей Щукин on 15.04.2022.
//

import Foundation
import UIKit

enum Constants {
    enum Image {
        static var image = UIImage()
    }
    
    enum Colors {
        static let gray = UIColor(named: "Gray")
        static let date = UIColor(named: "Date")
    }
    
    enum Fonts {
        static let header = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let info = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    static var apiKey = "k_07ka81uf"
}
