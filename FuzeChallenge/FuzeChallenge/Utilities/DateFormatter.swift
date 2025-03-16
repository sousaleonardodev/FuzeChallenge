//

import Foundation

class DateFormatterAux {
	static func toUTCString(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		formatter.timeZone = TimeZone(abbreviation: "UTC")

		return formatter.string(from: date)
	}
}

extension Date {
	var utcString: String {
		return DateFormatterAux.toUTCString(self)
	}

	var addingYear: Date? {
		var components = DateComponents()
		components.year = 1
		return Calendar.current.date(byAdding: components, to: self)
	}
}
