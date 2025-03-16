//

import Foundation

struct DateTestUtils {
	static func defaultDate(format: String = "dd-MM-yyyy HH:mm:ss",
							date: String = "20-01-2021 00:00:00") -> Date {
		let formater = DateFormatter()
		formater.dateFormat = format

		return formater.date(from: date)!
	}
}
