//

import Foundation

struct MatchResponse: Decodable {
	let id: Int
	let leagueName: String
	let leagueImageUrl: URL?
	let serieName: String
	let opponents: [MatchTeamResponse]
	let status: MatchStatus
	let scheduledDate: String?

	private enum RootKeys: String, CodingKey {
		case id
		case league
		case serie
		case opponents
		case status
		case scheduledDate = "scheduled_at"
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
		status = try container.decode(MatchStatus.self, forKey: .status)
		scheduledDate = try? container.decode(String?.self, forKey: .scheduledDate)

		let leagueContainer = try container.nestedContainer(keyedBy: LeagueKeys.self, forKey: .league)
		leagueName = try leagueContainer.decode(String.self, forKey: .name)
		leagueImageUrl = try? leagueContainer.decodeIfPresent(URL.self, forKey: .imageUrl)

		let serieContainer = try container.nestedContainer(keyedBy: SerieKeys.self, forKey: .serie)
		serieName = try serieContainer.decode(String.self, forKey: .name)

		opponents = try container.decode([MatchTeamResponse].self, forKey: .opponents)
	}
}

struct MatchTeamResponse: Decodable {
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

struct MatchStatusResponse: Decodable {
	let status: MatchStatus
	let scheduledDate: String?

	private enum CodingKeys: String, CodingKey {
		case status
		case scheduledDate = "scheduled_at"
	}
}

enum MatchStatus: String, Decodable {
	case running
	case notStarted = "not_started"
	case postponed
	case canceled
	case finished
}
