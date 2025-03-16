//

import SwiftUI
import Combine

class TeamViewModel: ObservableObject, Identifiable {
	@Published var name: String = ""
	@Published var image: URL?

	init(_ opponent: MatchTeamModel) {
		self.name = opponent.name

		// TODO: Add image size url
		self.image = opponent.image
	}
}

class MatchViewModel: ObservableObject, Identifiable {
	@Published var leagueSerie: String
	@Published var leagueImage: URL?
	@Published var firstOpponent: TeamViewModel?
	@Published var secondOpponent: TeamViewModel?
	@Published var matchStatus: MatchStatusViewModel

	init(_ match: MatchModel) {
		leagueSerie = match.leagueName + " " + match.serieName
			.trimmingCharacters(in: .whitespacesAndNewlines)

		// TODO: Add image size url
		leagueImage = match.leagueImageUrl

		if match.opponents.count > 0 {
			firstOpponent = TeamViewModel(match.opponents[0])
		}

		if match.opponents.count > 1 {
			secondOpponent = TeamViewModel(match.opponents[1])
		}

		matchStatus = .init(match.status, date: match.scheduledDate)
	}
}

class MatchStatusViewModel: ObservableObject, Identifiable {
	@Published var status: MatchStatus
	private var date: String?

	init(_ status: MatchStatus, date: String?) {
		self.status = status
		self.date = date
	}

	func getDate() -> String {
		guard status != .running else {
			return "AGORA"
		}

		guard let date = date, let localDate = DateFormatterHelper.toLocalString(date) else {
			return ""
		}

		return DateFormatterHelper.toShortDateTimeString(localDate) ?? ""
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

	private let matchFetcher: MatchListServiceProtocol

	init(matchFetcher: MatchListServiceProtocol) {
		self.matchFetcher = matchFetcher
		self.fetchMatches()
	}

	func fetchMatches() {
		datasource = []
		state = .loading

		matchFetcher.getMatches()
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
