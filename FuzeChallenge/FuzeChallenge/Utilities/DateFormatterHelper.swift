//

import Foundation

final class DateFormatterHelper {
	enum DateFormat: String {
		/// yyyy-MM-dd'T'HH:mm:ssZ
		case utcFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		/// dd.MM HH:mm
		case localShortFormat = "dd.MM HH:mm"
		/// HH:mm
		case timeShort = "HH:mm"
		/// weekday short
		case weekdayShort = "EEE"
	}

	static func toUTCString(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
		formatter.timeZone = TimeZone(abbreviation: "UTC")

		return formatter.string(from: date)
	}

	static func toLocalDate(_ date: String) -> Date? {
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone(abbreviation: "UTC")
		formatter.dateFormat = DateFormat.utcFormat.rawValue

		guard let convertedDate = formatter.date(from: date) else {
			return nil
		}

		formatter.timeZone = .current

		return formatter.date(from: formatter.string(from: convertedDate))
	}

	static func toString(_ date: Date, format: DateFormat) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = format.rawValue

		return formatter.string(from: date)
	}

	static func toWeekday(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "EEE"

		// Used to get day localized
		formatter.locale = Locale(identifier: "pt_BR")

		return formatter.string(from: date)
	}

	static func formatMatchDate(_ date: String?) -> String? {
		guard let dateString = date,
				let localDate = DateFormatterHelper.toLocalDate(dateString) else {
			return nil
		}

		if localDate.isToday {
			return "Hoje, " + DateFormatterHelper.toString(localDate, format: .timeShort)
		} else if localDate.isTomorrow {
			let weekDay = DateFormatterHelper.toWeekday(localDate).capitalized

			return weekDay + ", " + DateFormatterHelper.toString(localDate, format: .timeShort)
		}

		return DateFormatterHelper.toString(localDate, format: .localShortFormat)
	}
}
