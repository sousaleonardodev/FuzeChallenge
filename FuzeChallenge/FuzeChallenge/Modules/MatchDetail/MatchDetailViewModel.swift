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

	private var cancellables: Set<AnyCancellable> = []
	private let matchDetailService: MatchDetailServiceProtocol

	init(service: MatchDetailServiceProtocol) {
		self.matchDetailService = service
	}

	func loadDetails() {
		state = .loading
		matchDetailService.getPlayersFor(firstTeam: 126944, secondTeam: 133542)
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
					state = .error(error)
				case .finished:
					break
				}
			} receiveValue: { [weak self] players in
				guard let self else {
					return
				}

				self.state = .loaded
			}
			.store(in: &cancellables)


	}
}
