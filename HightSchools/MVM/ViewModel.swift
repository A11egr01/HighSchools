//
//  ViewModel.swift
//  HightSchools
//
//  Created by Allegro on 10/25/23.
//

import Foundation
import Combine

protocol DataService {
    func fetchHighSchools() -> AnyPublisher<[HighSchool], Error>
    func fetchSATScores() -> AnyPublisher<[SatScores], Error>
}

class DefaultDataService: DataService {
    private let highSchoolsURL = URL(string: "https://data.cityofnewyork.us/resource/s3k6-pzi2.json")!
    private let satScoresURL = URL(string: "https://data.cityofnewyork.us/resource/f9bf-2cp4.json")!

    func fetchHighSchools() -> AnyPublisher<[HighSchool], Error> {
        URLSession.shared.dataTaskPublisher(for: highSchoolsURL)
            .map(\.data)
            .decode(type: [HighSchool].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func fetchSATScores() -> AnyPublisher<[SatScores], Error> {
        URLSession.shared.dataTaskPublisher(for: satScoresURL)
            .map(\.data)
            .decode(type: [SatScores].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

class HighSchoolViewModel {
    @Published var highSchools: [HighSchool] = []
    @Published var satScores: [SatScores] = []

    private let dataService: DataService
    var cancellables: Set<AnyCancellable> = []

    init(dataService: DataService = DefaultDataService()) {
        self.dataService = dataService
    }

    func fetchHighSchools() -> AnyPublisher<[HighSchool], Error> {
        return dataService.fetchHighSchools()
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [unowned self] highSchools in
                self.highSchools = highSchools
            })
            .eraseToAnyPublisher()
    }

    func fetchSATScores() -> AnyPublisher<[SatScores], Error> {
        return dataService.fetchSATScores()
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [unowned self] satScores in
                self.satScores = satScores
            })
            .eraseToAnyPublisher()
    }
    
    func getCountOfHighSchools() -> AnyPublisher<Int, Never> {
        return $highSchools
            .map { highSchools in
                return highSchools.count
            }
            .eraseToAnyPublisher()
    }

    func findScores(dbn: String) -> SatScores? {
        return satScores.first { $0.dbn == dbn }
    }
}
