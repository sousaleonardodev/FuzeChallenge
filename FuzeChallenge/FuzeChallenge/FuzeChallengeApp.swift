//

import SwiftUI

@main
struct FuzeChallengeApp: App {
	@StateObject private var themeManager = ThemeManager()

	var body: some Scene {
		WindowGroup {
			let matchFetcher = MatchFetcher()
			let viewModel = MatchListViewModel(matchFetcher: matchFetcher)
			MatchListView(viewModel: viewModel)
				.environmentObject(themeManager)
		}
	}
}
