//

import Foundation

struct MatchDetailEndpoint: ApiServiceEndpoint {
	private let teamIDs: String

	init(teamIDs: String) {
		self.teamIDs = teamIDs
	}

	var url: String {
		"https://api.pandascore.co/csgo/players"
	}

	var queryItems: [URLQueryItem] {
		[
			.init(name: "filter[team_id]", value: teamIDs),
			.init(name: "sort", value: "team_id")
		]
	}
}
