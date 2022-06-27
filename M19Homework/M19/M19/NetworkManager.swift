//
//  NetworkManager.swift
//  M19
//
//  Created by Сергей Щукин on 27.06.2022.
//

import Foundation

class NetworkManager {
    
    func getData(string: String) -> Data {
        let jsonData = string.data(using: .utf8)
        let decoder = JSONDecoder()
        
        do {
            _ = try decoder.decode(Model.self, from: jsonData!)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return jsonData!
    }
    
}
