//

import Testing
import Foundation
@testable import FuzeChallenge

struct DateFormatterHelperTests {
	@Test("Local date time to UTC format")
	func fromLocalToUTCStringShouldReturnAValidDate() async throws {
		let date = defaultDate()

		let formatedDate = DateFormatterHelper.toUTCString(date)
		// Add 3 hrs due to TimeZone
		let expectedString = "2021-01-20T03:00:00"
		
		#expect(formatedDate == expectedString)
	}

	@Test("Format date to only weekday")
	func toStringWithWeekdayFormatShouldReturnAValidString() async throws {
		let date = defaultDate()
		
		let formatedDate = DateFormatterHelper.toString(date, format: .weekdayShort)
		let expectedDate = "Wed"

		#expect(formatedDate == expectedDate)
	}

	@Test("Format date to only show time shor")
	func toStringWithTimeShortFormatShouldReturnAValidString() async throws {
		let date = defaultDate()

		let formatedDate = DateFormatterHelper.toString(date, format: .timeShort)
		let expectedTime = "00:00"

		#expect(formatedDate == expectedTime)
	}

	@Test("Format date to local time short")
	func toStringWithLocalTimeShortFormatShouldReturnAValidString() async throws {
		let date = defaultDate()

		let formatedDate = DateFormatterHelper.toString(date, format: .localShortFormat)
		let expectedDate = "20.01 00:00"

		#expect(formatedDate == expectedDate)
	}

	@Test("Format date to local weekday")
	func toStringWithLocalWeekdayFormatShouldReturnAValidString() async throws {
		let date = defaultDate(date: "16-03-2025 23:00:00")

		let formatedDate = DateFormatterHelper.toWeekday(date)
		let expectedDate = "Sun"

		#expect(formatedDate == expectedDate)
	}
}

extension DateFormatterHelperTests {
	private func defaultDate(format: String = "dd-MM-yyyy HH:mm:ss", date: String = "20-01-2021 00:00:00") -> Date {
		let formater = DateFormatter()
		formater.dateFormat = format

		return formater.date(from: date)!
	}
}
