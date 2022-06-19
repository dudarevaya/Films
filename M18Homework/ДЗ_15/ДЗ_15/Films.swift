//
//  Films.swift
//  ДЗ_15
//
//  Created by Сергей Щукин on 15.06.2022.
//

import Foundation
import UIKit

struct Films {
    let filmTitle: String
    let description: String
    let imageString: String
    
    init?(films: Welcome) {
        filmTitle = films.results.first!.title
        description = films.results.first!.resultDescription
        imageString = films.results.first!.image
    }
}
