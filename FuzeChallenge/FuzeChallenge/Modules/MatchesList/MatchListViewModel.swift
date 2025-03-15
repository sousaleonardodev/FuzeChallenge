//

import SwiftUI
import Combine

class TeamViewModel: ObservableObject, Identifiable {
	@Published var name: String = ""
	@Published var image: URL?

	init(_ opponent: MatchTeamResponse) {
		self.name = opponent.name

		// TODO: Add image size url
		self.image = opponent.image
	}
}

class MatchViewModel: ObservableObject, Identifiable {
	@Published var leagueSerie: String
	@Published var leagueImage: URL?
	@Published var firstOpponent: TeamViewModel
	@Published var secondOpponent: TeamViewModel
	@Published var matchStatus: String

	init(_ match: MatchResponse) {
		leagueSerie = match.leagueName + "" + match.serieName
			.trimmingCharacters(in: .whitespacesAndNewlines)

		// TODO: Add image size url
		leagueImage = match.leagueImageUrl

		//TODO: Add validation
		firstOpponent = TeamViewModel(match.opponents[0])
		secondOpponent = TeamViewModel(match.opponents[1])

		//TODO: Set default status or filter null ones
		matchStatus = match.status?.rawValue ?? "Unknown"
	}
}

class MatchListViewModel: ObservableObject, Identifiable {
	enum State {
		case loading
		case loaded
		case error(Error)
	}

	@Published var datasource: [MatchViewModel] = []
	@Published var state: State = .loading

	private var cancellables: Set<AnyCancellable> = []

	private let matchFetcher: MatchFeachable

	init(matchFetcher: MatchFeachable) {
		self.matchFetcher = matchFetcher
		self.fetchMatches()
	}

	func fetchMatches() {
		datasource = []
		state = .loading

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
					state = .error(error)
				case .finished:
					break
				}
			} receiveValue: { [weak self] matches in
				guard let self = self else {
					return
				}

				self.datasource = matches
				state = .loaded
			}
			.store(in: &cancellables)
	}
}
