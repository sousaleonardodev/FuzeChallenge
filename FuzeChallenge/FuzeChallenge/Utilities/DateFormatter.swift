//

import Foundation

final class DateFormatterHelper {
	static private let utcFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
	static private let localShortFormat = "dd.MM HH:mm"

	static func toUTCString(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		formatter.timeZone = TimeZone(abbreviation: "UTC")

		return formatter.string(from: date)
	}

	static func toLocalString(_ date: String) -> String? {
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone(abbreviation: "UTC")
		formatter.dateFormat = utcFormat

		guard let convertedDate = formatter.date(from: date) else {
			return nil
		}
		formatter.timeZone = .current
		
		return formatter.string(from: convertedDate)
	}

	static func toShortDateTimeString(_ dateString: String) -> String? {
		let formatter = DateFormatter()
		formatter.dateFormat = utcFormat
		formatter.timeZone = .current

		guard let date = formatter.date(from: dateString) else {
			return nil
		}

		formatter.dateFormat = localShortFormat

		return formatter.string(from: date)
	}
}

extension Date {
	var utcString: String {
		DateFormatterHelper.toUTCString(self)
	}

	var addingYear: Date? {
		var components = DateComponents()
		components.year = 1
		return Calendar.current.date(byAdding: components, to: self)
	}
}
