//

import Testing
import Foundation
@testable import FuzeChallenge

struct DateExtensionTests {
	@Test("Adding a year to date")
	func addingYearToDateShouldReturnAValidDate() {
		let date = DateTestUtils.defaultDate()

		let alteredDate = date.addingYear
		let expectedDate = DateTestUtils.defaultDate(format: "dd-MM-yyyy HH:mm:ssZ", date: "20-01-2022 03:00:00Z")

		#expect(alteredDate == expectedDate)
	}

	@Test("Checking if a date is today")
	func isTomorrowShouldReturnTrueIfDateIsToday() {
		let date = Date()

		#expect(date.isToday)
	}

	@Test("Checking if a date is today")
	func isTomorrowShouldReturnFalseIfDateIsNotToday() {
		let date = DateTestUtils.defaultDate()

		#expect(!date.isToday)
	}

	@Test("Checking if a date is tomorrow")
	func isTomorrowShouldReturnFalseIfDateIsNotTomorrow() {
		let date = Date()

		#expect(!date.isTomorrow)
	}
}
