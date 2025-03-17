//

import SwiftUI
import Combine

final class TeamViewModel: ObservableObject, Identifiable {
	private let model: MatchTeamModel

	var name: String {
		model.name
	}

	var image: URL? {
		model.image
	}

	init(_ opponent: MatchTeamModel) {
		self.model = opponent
	}
}

final class MatchViewModel: ObservableObject, Identifiable {
	var leagueSerie: String {
		"\(model.leagueName) \(model.serieName)".trimmingCharacters(in: .whitespacesAndNewlines)
	}

	var leagueImage: URL? {
		// Using thumb_ to optimize data consumption and rendering
		model.leagueImageUrl?.insertingToLastPath("thumb_")
	}

	var firstOpponent: TeamViewModel? {
		model.opponents.count > 0 ? TeamViewModel(model.opponents[0]) : nil
	}

	var secondOpponent: TeamViewModel? {
		model.opponents.count > 1 ? TeamViewModel(model.opponents[1]) : nil
	}

	var matchStatus: MatchStatusViewModel {
		MatchStatusViewModel(model.status, date: model.scheduledDate)
	}

	internal let model: MatchModel

	init(_ match: MatchModel) {
		self.model = match
	}
}

extension MatchViewModel: Hashable {
	static func == (lhs: MatchViewModel, rhs: MatchViewModel) -> Bool {
		lhs.leagueSerie == rhs.leagueSerie
	}

	var hashValue: Int {
		leagueSerie.hashValue
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
	private let matchlistService: MatchListServiceProtocol

	init(matchService: MatchListServiceProtocol) {
		self.matchlistService = matchService
		loadMatches()
	}

	func loadMatches() {
		datasource = []
		state = .loading

		matchlistService.getMatches()
			.map { response in
				response.map(MatchViewModel.init)
			}
			.receive(on: DispatchQueue.main)
			.sink { [weak self] value in
				guard let self else {
					return
				}

				switch value {
				case .failure(let error):
					datasource = []
					state = .error(error)
				case .finished:
					break
				}
			} receiveValue: { [weak self] matches in
				guard let self else {
					return
				}

				datasource = matches
				state = .loaded
			}
			.store(in: &cancellables)
	}
}

extension MatchListViewModel {
	func matchDetailView(for match: MatchViewModel) -> some View {
		MatchDetailBuilder.build(match: match.model)
	}
}
