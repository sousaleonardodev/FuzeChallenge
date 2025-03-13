//

import Foundation

struct MatchResponse: Decodable {
	let id: Int
	let leagueName: String
	let serieName: String
	let oponents: [MatchOponentResponse]

	private enum CodingKeys: String, CodingKey {
		case id
		case leagueName = "league.name"
		case serieName = "serie.name"
		case oponents
	}
}

struct MatchOponentResponse: Decodable {
	let id: Int
	let name: String
	let image: URL
}

struct MatchStatusResponse: Decodable {
	let status: String
}

enum MatchStatus: String {
	case notStarted = "not_started"
	case started = "running"
}
