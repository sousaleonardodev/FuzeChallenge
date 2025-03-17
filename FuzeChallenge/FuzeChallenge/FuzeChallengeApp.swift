//

import SwiftUI

@main
struct FuzeChallengeApp: App {
	@StateObject private var themeManager = ThemeManager()

	var body: some Scene {
		WindowGroup {
			MatchListBuilder.build()
				.environmentObject(themeManager)
		}
	}
}
