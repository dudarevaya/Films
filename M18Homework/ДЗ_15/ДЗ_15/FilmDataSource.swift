//
//  DataSource.swift
//  ДЗ_15
//
//  Created by Сергей Щукин on 15.06.2022.
//

import Foundation

struct Welcome: Decodable {
    let expression: String
    let results: [Results]
}

// MARK: - Result
struct Results: Decodable {
    let id: String
    let resultType: String
    let image: String
    let title: String
    let resultDescription: String

    enum CodingKeys: String, CodingKey {
        case id, resultType, image, title
        case resultDescription = "description"
    }
}
