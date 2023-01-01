//
//  HomeViewModel.swift
//  Astra
//
//  Created by Justin Cabral on 12/31/22.
//

import Foundation

protocol ViewModel : ObservableObject {}

extension ViewModel {
    func getStarPhoto() async {}
}

@MainActor
final class HomeViewModel : ViewModel {
    enum State {
        case no_photo
        case loading
        case success(photo: StarPhoto)
        case failed(error: Error)
    }
    
    @Published private(set) var starPhoto: StarPhoto = StarPhoto(date: "", explanation: "", hdurl: "", media_type: "", service_version: "", title: "", url: "")
    @Published private(set) var state: State = .no_photo
    
    private let service: Service
    
    init(service: Service) {
        self.service = service
    }
    
    func getStarPhoto() async {
        self.state = .loading
        
        do {
            self.starPhoto = try await service.fetchStarPhoto()
            self.state = .success(photo: self.starPhoto)
        } catch {
            self.state = .failed(error: error)
        }
    }
}
