//

import SwiftUI
import Combine

final class TeamViewModel: ObservableObject, Identifiable {
	@Published var name: String = ""
	@Published var image: URL?

	init(_ opponent: MatchTeamModel) {
		self.name = opponent.name
		self.image = opponent.image
	}
}

final class MatchViewModel: ObservableObject, Identifiable {
	@Published var leagueSerie: String
	@Published var leagueImage: URL?
	@Published var firstOpponent: TeamViewModel?
	@Published var secondOpponent: TeamViewModel?
	@Published var matchStatus: MatchStatusViewModel

	init(_ match: MatchModel) {
		leagueSerie = match.leagueName + " " + match.serieName
			.trimmingCharacters(in: .whitespacesAndNewlines)

		// Using thumb_ to optimize data consumption and rendering
		leagueImage = match.leagueImageUrl?.insertingToLastPath("thumb_")

		if match.opponents.count > 0 {
			firstOpponent = TeamViewModel(match.opponents[0])
		}

		if match.opponents.count > 1 {
			secondOpponent = TeamViewModel(match.opponents[1])
		}

		matchStatus = .init(match.status, date: match.scheduledDate)
	}
}

final class MatchStatusViewModel: ObservableObject, Identifiable {
	@Published var status: MatchStatus
	private var date: String?

	init(_ status: MatchStatus, date: String?) {
		self.status = status
		self.date = date
	}

	func getDate() -> String? {
		guard status != .running else {
			return "AGORA"
		}

		guard let dateString = date,
				let localDate = DateFormatterHelper.toLocalDate(dateString) else {
			return nil
		}

		if localDate.isToday {
			return "Hoje, " + DateFormatterHelper.toString(localDate, format: .timeShort)
		} else if localDate.isTomorrow {
			let weekDay = DateFormatterHelper.toWeekday(localDate).capitalized

			return weekDay + ", " + DateFormatterHelper.toString(localDate, format: .timeShort)
		}

		return DateFormatterHelper.toString(localDate, format: .localShortFormat)
	}
}

final class MatchListViewModel: ObservableObject, Identifiable {
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
