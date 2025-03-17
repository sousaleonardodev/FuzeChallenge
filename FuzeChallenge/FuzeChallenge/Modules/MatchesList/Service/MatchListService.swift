//

import Foundation
import Combine

protocol MatchListServiceProtocol {
	func getMatches() -> AnyPublisher<[MatchModel], RequestError>
}

final class MatchListService: MatchListServiceProtocol {
	private let apiService: ApiServiceProtocol

	init(apiService: ApiServiceProtocol) {
		self.apiService = apiService
	}
	
	func getMatches() -> AnyPublisher<[MatchModel], RequestError> {
		apiService.request(MatchListEndpoint())
	}
}
