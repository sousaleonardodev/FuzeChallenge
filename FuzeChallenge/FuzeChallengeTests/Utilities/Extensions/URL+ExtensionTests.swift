//

import Testing
import Foundation
@testable import FuzeChallenge

struct URL_ExtensionTests {

	@Test("Insert string at the beginning of url last path")
	func insertingToLastPathShouldReturnAValidURL() async throws {
		let url = URL(string: "https://cdn.pandascore.co/images/league/image/5296/exort-gg_lightmode-png")!

		let newURL = url.insertingToLastPath("Tests_")
		let expectedURL = URL(string: "https://cdn.pandascore.co/images/league/image/5296/Tests_exort-gg_lightmode-png")!

		#expect(newURL == expectedURL)
	}
}
