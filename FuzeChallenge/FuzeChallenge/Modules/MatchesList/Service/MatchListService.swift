//

import Foundation
import Combine

protocol MatchListServiceProtocol {
	func getMatches() -> AnyPublisher<[MatchResponse], RequestError>
}

class MatchListService: MatchListServiceProtocol {
	private let apiService: ApiServiceProtocol

	init(apiService: ApiServiceProtocol) {
		self.apiService = apiService
	}
	
	func getMatches() -> AnyPublisher<[MatchResponse], RequestError> {
		apiService.request(MatchListEndpoint())
	}
}
