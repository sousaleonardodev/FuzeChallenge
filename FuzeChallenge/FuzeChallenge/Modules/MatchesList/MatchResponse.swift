//

import Foundation

struct MatchResponse: Decodable {
	let id: Int
	let leagueName: String
	let leagueImageUrl: URL?
	let serieName: String
	let opponents: [MatchOpponentResponse]
	let status: MatchStatus?

	private enum RootKeys: String, CodingKey {
		case id
		case league
		case serie
		case opponents
		case status
	}

	private enum LeagueKeys: String, CodingKey {
		case name
		case imageUrl = "image_url"
	}

	private enum SerieKeys: String, CodingKey {
		case name
	}

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: RootKeys.self)
		id = try container.decode(Int.self, forKey: .id)
		status = try? container.decode(MatchStatus.self, forKey: .status)

		let leagueContainer = try container.nestedContainer(keyedBy: LeagueKeys.self, forKey: .league)
		leagueName = try leagueContainer.decode(String.self, forKey: .name)
		leagueImageUrl = try? leagueContainer.decodeIfPresent(URL.self, forKey: .imageUrl)

		let serieContainer = try container.nestedContainer(keyedBy: SerieKeys.self, forKey: .serie)
		serieName = try serieContainer.decode(String.self, forKey: .name)

		opponents = try container.decode([MatchOpponentResponse].self, forKey: .opponents)
	}
}

struct MatchOpponentResponse: Decodable {
	let id: Int
	let name: String
	let image: URL?

	private enum RootKeys: String, CodingKey {
		case opponent
	}

	private enum OpponentKeys: String, CodingKey {
		case id
		case name
		case image = "image_url"
	}

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: RootKeys.self)
		let opponentContainer = try container.nestedContainer(keyedBy: OpponentKeys.self, forKey: .opponent)

		id = try opponentContainer.decode(Int.self, forKey: .id)
		name = try opponentContainer.decode(String.self, forKey: .name)
		image = try? opponentContainer.decode(URL.self, forKey: .image)
	}
}

enum MatchStatus: String, Decodable {
	case notStarted = "not_started"
	case started = "running"
}
