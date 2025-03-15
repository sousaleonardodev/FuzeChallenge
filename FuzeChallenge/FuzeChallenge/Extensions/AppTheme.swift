//

import SwiftUI
import VFont

protocol ThemeProtocol {
	// Fonts
	var fontSmallest: Font { get }
	var fontSmall: Font { get }
	var fontMedium: Font { get }
	var fontBig: Font { get }
	var fontTitle: Font { get }

	// Colors
	var background: Color { get }
	var alertActive: Color { get }
	var alertInactive: Color { get }
	var textPrimary: Color { get }
	var textSecondary: Color { get }
	var lightGray: Color { get }
}

struct DefaultTheme: ThemeProtocol {
	var fontSmallest: Font {
		.custom("Roboto-Regular", size: 8)
	}

	var fontSmall: Font {
		.custom("Roboto-Regular", size: 10)
	}

	var fontMedium: Font {
		.custom("Roboto-Regular", size: 12)
	}

	var fontBig: Font {
		.custom("Roboto-Bold", size: 14)
	}

	var fontTitle: Font {
		.custom("Roboto-Medium", size: 32)
	}

	var background: Color {
		.background
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
		.lightGray
	}
}

class ThemeManager: ObservableObject {
	@Published var currentTheme: ThemeProtocol = DefaultTheme()
}

