//

import SwiftUI

struct LoadingView: View {
	@EnvironmentObject private var themeManager: ThemeManager

	var body: some View {
		ZStack {
			themeManager.currentTheme.background
				.ignoresSafeArea()
			ProgressView()
				.scaleEffect(2)
				.tint(themeManager.currentTheme.textPrimary)
		}
	}
}
