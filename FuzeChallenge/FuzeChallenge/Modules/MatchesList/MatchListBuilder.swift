//

import Foundation
import SwiftUI

struct MatchListBuilder {
	static func build() -> some View {
		let apiService = ApiService(session: URLSession.shared)
		let matchListService = MatchListService(apiService: apiService)
		let viewModel = MatchListViewModel(matchService: matchListService)

		return MatchListView(viewModel: viewModel)
	}
}
