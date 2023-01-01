//
//  AstraService.swift
//  Astra
//
//  Created by Justin Cabral on 12/31/22.
//

import Foundation

protocol Service {
    func fetchStarPhoto() async throws -> StarPhoto
}

final class AstraService: Service {
    
    enum APIendpoint {
        static let baseURL = "https://go-apod.herokuapp.com/apod"
    }
    
    func fetchStarPhoto() async throws -> StarPhoto {
        let urlSession = URLSession.shared
        let url = URL(string: APIendpoint.baseURL)
        let (data, _) = try await urlSession.data(from: url!)
        
        return try JSONDecoder().decode(StarPhoto.self, from: data)
    }
    
}
