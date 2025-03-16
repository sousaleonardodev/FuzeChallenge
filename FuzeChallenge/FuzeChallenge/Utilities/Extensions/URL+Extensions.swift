//

import Foundation

extension URL {
	func insertingToLastPath(_ string: String) -> URL {
		var lastPathComponent = lastPathComponent
		lastPathComponent = string + lastPathComponent

		let newURL = self.deletingLastPathComponent()
		return newURL.appendingPathComponent(lastPathComponent)
	}
}
