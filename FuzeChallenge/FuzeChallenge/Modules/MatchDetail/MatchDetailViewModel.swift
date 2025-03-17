//

import Foundation
import Combine

final class MatchPlayerViewModel: ObservableObject, Identifiable {
	private let player: MatchPlayerModel

	var name: String {
		"\(player.name) \(player.lastName)"
	}

	var nickname: String {
		player.nickname
	}

	var photo: URL? {
		player.photo
	}

	init(player: MatchPlayerModel) {
		self.player = player
	}
}

final class MatchDetailViewModel: ObservableObject, Identifiable {
	enum State {
		case loading
		case loaded
		case error(Error)
	}

	@Published var state: State = .loading
	@Published var dataSource: [MatchPlayerViewModel] = []

	private var cancellables: Set<AnyCancellable> = []
	private let matchDetailService: MatchDetailServiceProtocol

	private let match: MatchModel

	init(service: MatchDetailServiceProtocol, match: MatchModel) {
		self.matchDetailService = service
		self.match = match
	}

	func loadDetails() {
		state = .loading
		guard let opponentsID = match.getOpponentIDs() else {
			state = .error(NSError(domain: "", code: 0, userInfo: nil))
			return
		}

		matchDetailService.getPlayersFor(firstTeam: opponentsID.0, secondTeam: opponentsID.1)
			.map { response in
				response.map(MatchPlayerViewModel.init)
			}
			.receive(on: DispatchQueue.main)
			.sink { [weak self] value in
				guard let self else {
					return
				}

				switch value {
				case .failure(let error):
					dataSource = []
					state = .error(error)
				case .finished:
					break
				}
			} receiveValue: { [weak self] players in
				guard let self else {
					return
				}
				dataSource = players
				self.state = .loaded
			}
			.store(in: &cancellables)


	}
}
