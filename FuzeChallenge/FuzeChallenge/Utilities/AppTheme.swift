//

import SwiftUI

protocol ThemeProtocol {
	// Fonts
	/// 8 pts
	var fontSmallest: Font { get }
	/// 10 pts
	var fontSmall: Font { get }
	/// 12 pts
	var fontMedium: Font { get }
	/// 12 pts
	var fontMediumBold: Font { get }
	/// 14 pts
	var fontBig: Font { get }

	// Using UIFont due limitations of UIAppereance
	var fontNavigationTitle: UIFont { get }
	var fontNavigationTitleSmall: UIFont { get }

	// Colors
	var background: Color { get }
	var primary: Color { get }
	var alertActive: Color { get }
	var alertInactive: Color { get }
	var textPrimary: Color { get }
	var textSecondary: Color { get }
	var lightGray: Color { get }
	var darkGray: Color { get }
}

struct DefaultTheme: ThemeProtocol {
	var fontSmallest: Font {
		.custom("Roboto-Bold", size: 8)
	}

	var fontSmall: Font {
		.custom("Roboto-Regular", size: 10)
	}

	var fontMedium: Font {
		.custom("Roboto-Regular", size: 12)
	}

	var fontMediumBold: Font {
		.custom("Roboto-Bold", size: 12)
	}


	var fontBig: Font {
		.custom("Roboto-Bold", size: 14)
	}

	var fontNavigationTitle: UIFont {
		.init(name: "Roboto-Medium", size: 32) ?? .systemFont(ofSize: 32, weight: .medium)
	}

	var fontNavigationTitleSmall: UIFont {
		.init(name: "Roboto-Medium", size: 18) ?? .systemFont(ofSize: 18, weight: .medium)
	}

	var background: Color {
		.background
	}

	var primary: Color {
		.cardPrimary
	}

	var alertActive: Color {
		.alertActive
	}

	var alertInactive: Color{
		.alertInactive
	}

	var textPrimary: Color {
		.textPrimary
	}

	var textSecondary: Color {
		.textSecondary
	}

	var lightGray: Color {
		.grayByAlpha50
	}

	var darkGray: Color {
		.grayByAlpha20
	}
}

class ThemeManager: ObservableObject {
	@Published var currentTheme: ThemeProtocol = DefaultTheme()
}

