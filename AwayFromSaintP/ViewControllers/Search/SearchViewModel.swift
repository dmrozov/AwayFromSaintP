//
//  SearchViewModel.swift
//  AwayFromSaintP
//
//  Created by Dmitry Rozov on 20/11/2019.
//  Copyright © 2019 Dmitry Rozov. All rights reserved.
//

import Foundation

class SearchViewModel {
    
    enum State {
        case loading, list, clear, error
    }
    
    private let searchService = SearchService()
    
    var state = State.clear {
        didSet {
            updateHandler?()
        }
    }
    var destinations = [Destination]() {
        didSet {
            updateHandler?()
        }
    }
    var updateHandler: (() -> Void)?
    
    var query: String = "" {
        didSet {
            guard !query.isEmpty else {
                state = .clear
                destinations.removeAll()
                return
            }
            getDestinations()
        }
    }
    
    func cellViewModel(for index: Int) -> DestinationCellModel {
        return DestinationCellModel(destination: destinations[index])
    }
    
    private func getDestinations() {
        state = .loading
        searchService.getDestinations(for: query) { [weak self] (destinations, eror) in
            if let destinations = destinations {
                self?.state = destinations.isEmpty ? .error : .list
                self?.destinations = destinations
            } else {
                self?.destinations.removeAll()
                self?.state = .error
            }
        }
    }
}
