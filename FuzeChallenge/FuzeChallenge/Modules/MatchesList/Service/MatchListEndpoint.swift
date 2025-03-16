//

import Foundation

struct MatchListEndpoint: ApiServiceEndpoint {
	var url: String {
		"https://api.pandascore.co/csgo/matches"
	}

	var queryItems: [URLQueryItem] {
		[
			.init(name: "filter[opponents_filled]", value: "true"),
			.init(name: "sort", value: "-status"),
			.init(name: "filter[status]", value: "running, postponed, not_started"),
			// Setting a year in range
			.init(name: "range[begin_at]", value: "2025-03-15T11:00:00,2027-02-26T11:00:00")
		]
	}
}
