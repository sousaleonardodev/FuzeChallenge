//

import Foundation
import Combine

protocol MatchFeachable {
	func listMatches() -> AnyPublisher<[MatchResponse], RequestError>
}

class MatchFetcher: MatchFeachable {
	func listMatches() -> AnyPublisher<[MatchResponse], RequestError> {
		guard let url = URL(string: "https://api.pandascore.co/csgo/matches?filter[opponents_filled]=true") else {
			return Fail(error: .network("Invalid URL")).eraseToAnyPublisher()
		}
		var request = URLRequest(url: url)
		request.addValue("mXd8AO-tg_mxlncpnTlIqVarlbVK_nwKn888SIxa59Ef2Te2PQ4", forHTTPHeaderField: "Authorization")

		return URLSession.shared.dataTaskPublisher(for: request)
			.mapError { error in
				.network(error.localizedDescription)
			}
			.flatMap(maxPublishers: .max(1)) { output in
				decode(output.data)
			}
			.breakpointOnError()
			.eraseToAnyPublisher()
	}
}
