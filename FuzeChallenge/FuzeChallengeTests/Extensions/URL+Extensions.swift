//

import Foundation

extension URL {
	func insertingToLastPath(_ string: String) -> URL {
		var lastPathComponent = lastPathComponent
		lastPathComponent = string + lastPathComponent

		var newURL = self.deletingLastPathComponent()
		return newURL.appendingPathComponent(lastPathComponent)
	}
}
