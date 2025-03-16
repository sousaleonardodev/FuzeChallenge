//

import Foundation

extension Date {
	var isToday: Bool {
		Calendar.current.isDateInToday(self)
	}

	var isWithinCurrentWeek: Bool {
		Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
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
