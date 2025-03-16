//

import SwiftUI

struct ErrorView: View {
	private let message: String
	private let retryAction: () -> Void

	@EnvironmentObject private var themeManager: ThemeManager

	init(message: String, action: @escaping () -> Void) {
		self.message = message
		self.retryAction = action
	}

	var body: some View {
		ZStack {
			themeManager.currentTheme.background
				.ignoresSafeArea()

			VStack {
				Spacer()
				Text(message)
					.font(themeManager.currentTheme.fontBig)
					.foregroundStyle(themeManager.currentTheme.textSecondary)
					.lineLimit(2)
					.padding(24)

				Button("Tentar novamente") {
					retryAction()
				}
				.font(themeManager.currentTheme.fontBig)
				.foregroundStyle(themeManager.currentTheme.textPrimary)
				Spacer()
			}
			.background(themeManager.currentTheme.background).ignoresSafeArea()
			.padding()
		}
	}
}
