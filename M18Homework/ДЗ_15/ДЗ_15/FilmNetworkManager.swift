//
//  FilmNetworkManager.swift
//  ДЗ_15
//
//  Created by Сергей Щукин on 15.06.2022.
//

import Foundation

class FilmNetworkManager {
    
    var onCompletion: ((Films) -> Void)?
    
    func fetchFilm(forFilm film: String, response: @escaping (Welcome?) -> Void) {
        performRequest(urlString: film) { (result) in
            switch result {
            case .success(let data):
                do {
                    let films = try JSONDecoder().decode(Welcome.self, from: data)
                    response(films)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    response(nil)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
    
    func performRequest(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }.resume()
    }
}
