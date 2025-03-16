//

import SwiftUI

@main
struct FuzeChallengeApp: App {
	@StateObject private var themeManager = ThemeManager()

	var body: some Scene {
		WindowGroup {
			let apiService = ApiService(session: URLSession.shared)
			let matchListService = MatchListService(apiService: apiService)
			let viewModel = MatchListViewModel(matchFetcher: matchListService)
			MatchListView(viewModel: viewModel)
				.environmentObject(themeManager)
		}
	}
}
