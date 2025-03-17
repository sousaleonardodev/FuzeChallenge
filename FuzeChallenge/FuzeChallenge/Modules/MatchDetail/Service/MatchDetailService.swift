//

import Foundation
import Combine

protocol MatchDetailServiceProtocol {
	func getPlayersFor(firstTeam: Int, secondTeam: Int) -> AnyPublisher<[MatchPlayerModel], RequestError>
}

final class MatchDetailService: MatchDetailServiceProtocol {
	private let apiService: ApiServiceProtocol

	init(apiService: ApiServiceProtocol) {
		self.apiService = apiService
	}

	func getPlayersFor(firstTeam: Int, secondTeam: Int) -> AnyPublisher<[MatchPlayerModel], RequestError> {
		let ids: String = "\(firstTeam), \(secondTeam)"

		return apiService.request(MatchDetailEndpoint(teamIDs: ids))
	}
}
