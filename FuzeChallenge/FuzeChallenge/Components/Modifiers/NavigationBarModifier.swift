//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
	private let themeManager: ThemeManager

	init(_ themeManager: ThemeManager) {
		self.themeManager = themeManager

		let appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = UIColor(themeManager.currentTheme.background)

		appearance.titleTextAttributes = [
			.foregroundColor: UIColor(themeManager.currentTheme.textPrimary),
			.font: themeManager.currentTheme.fontNavigationTitleSmall
		]

		appearance.largeTitleTextAttributes = [
			.foregroundColor: UIColor(themeManager.currentTheme.textPrimary),
			.font: themeManager.currentTheme.fontNavigationTitle
		]

		appearance.backButtonAppearance = setupBackButtonAppearence()

		UINavigationBar.appearance().standardAppearance = appearance
		UINavigationBar.appearance().compactAppearance = appearance
		UINavigationBar.appearance().scrollEdgeAppearance = appearance
	}

	func body(content: Content) -> some View {
		content
			.background(themeManager.currentTheme.background)
			.navigationBarTitleDisplayMode(.automatic)
			.navigationBarBackButtonHidden()
	}

	private func setupBackButtonAppearence() -> UIBarButtonItemAppearance {
		let appearance = UIBarButtonItemAppearance()

		let settings: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.clear
		]

		appearance.normal.titleTextAttributes = settings
		appearance.highlighted.titleTextAttributes = settings
		appearance.focused.titleTextAttributes = settings
		appearance.disabled.titleTextAttributes = settings

		return appearance
	}
}
