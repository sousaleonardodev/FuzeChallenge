//

import Foundation

extension Date {
	var isToday: Bool {
		Calendar.current.isDateInToday(self)
	}

	var isTomorrow: Bool {
		Calendar.current.isDateInTomorrow(self)
	}

	var utcString: String {
		DateFormatterHelper.toUTCString(self)
	}

	var addingYear: Date? {
		var components = DateComponents()
		components.year = 1
		return Calendar.current.date(byAdding: components, to: self)
	}
}
