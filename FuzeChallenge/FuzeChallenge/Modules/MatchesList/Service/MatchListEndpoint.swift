//

import Foundation

struct MatchListEndpoint: ApiServiceEndpoint {
	var url: String {
		"https://api.pandascore.co/csgo/matches"
	}

	var queryItems: [URLQueryItem] {
		[
			.init(name: "filter[opponents_filled]", value: "true"),
			.init(name: "sort", value: "begin_at, -status"),
			.init(name: "filter[status]", value: "running, postponed, not_started"),

			// Setting a year in range to get next scheduled matches
			.init(name: "range[begin_at]", value: dateRangeQueryItem())
		]
	}

	private func dateRangeQueryItem() -> String {
		let today = Date().utcString
		let nextYear = Date().addingYear?.utcString ?? today

		return "\(today),\(nextYear)"
	}
}
