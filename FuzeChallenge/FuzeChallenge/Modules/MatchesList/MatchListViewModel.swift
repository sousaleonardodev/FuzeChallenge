//

import SwiftUI
import Combine

class OpponentViewModel: ObservableObject, Identifiable {
	@Published var name: String = ""
	@Published var image: URL?

	init(_ opponent: MatchOpponentResponse) {
		self.name = opponent.name
		self.image = opponent.image
	}
}
class MatchListViewModel: ObservableObject, Identifiable {
	@Published var datasource: [MatchViewModel] = []
	private var cancellables: Set<AnyCancellable> = []

	private let matchFetcher: MatchFeachable

	init(matchFetcher: MatchFeachable) {
		self.matchFetcher = matchFetcher
		self.fetchMatches()
	}

	func fetchMatches() {
		matchFetcher.listMatches()
			.map { response in
				response.map(MatchViewModel.init)
			}
			.receive(on: DispatchQueue.main)
			.sink { [weak self] value in
				guard let self = self else {
					return
				}

				switch value {
				case .failure(let error):
					self.datasource = []
					print(error.localizedDescription)
				case .finished:
					break
				}
			} receiveValue: { [weak self] matches in
				guard let self = self else {
					return
				}

				self.datasource = matches
			}
			.store(in: &cancellables)
	}
}
