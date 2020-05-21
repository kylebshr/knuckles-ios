import XCTest
@testable import Knuckles

class PayPeriodTests: XCTestCase {

    // MARK: - Weekly

    func testWeeklyNoMatchingDays() {
        let payPeriod = PayPeriod.weekly(day: 5)
        let previousDate: Date = "01/01/2020"
        let nextDate: Date = "01/31/2020"

        let dates: [Date] = [
            "01/02/2020",
            "01/09/2020",
            "01/16/2020",
            "01/23/2020",
            "01/30/2020",
        ]

        XCTAssertEqual(dates, payPeriod.from(date: previousDate, to: nextDate))
    }

    func testWeeklyNoOverlap() {
        let payPeriod = PayPeriod.weekly(day: 5)
        let previousDate: Date = "01/03/2020"
        let nextDate: Date = "01/04/2020"

        XCTAssertEqual([], payPeriod.from(date: previousDate, to: nextDate))
    }

    func testWeeklyStartsOnPayPeriod() {
        let payPeriod = PayPeriod.weekly(day: 5)
        let previousDate: Date = "01/02/2020"
        let nextDate: Date = "01/31/2020"

        let dates: [Date] = [
            "01/09/2020",
            "01/16/2020",
            "01/23/2020",
            "01/30/2020",
        ]

        XCTAssertEqual(dates, payPeriod.from(date: previousDate, to: nextDate))
    }

    func testWeeklyEndsOnPayPeriod() {
        let payPeriod = PayPeriod.weekly(day: 5)
        let previousDate: Date = "01/02/2020"
        let nextDate: Date = "01/30/2020"

        let dates: [Date] = [
            "01/09/2020",
            "01/16/2020",
            "01/23/2020",
            "01/30/2020",
        ]

        XCTAssertEqual(dates, payPeriod.from(date: previousDate, to: nextDate))
    }

    // MARK: - First and fifteenth

    func testFirstAndFifteenthFirstMatches() {
        let payPeriod = PayPeriod.firstAndFifteenth(adjustForWeekends: false)
        let previousDate: Date = "01/01/2020"
        let nextDate: Date = "01/31/2020"

        let dates: [Date] = [
            "01/15/2020",
        ]

        XCTAssertEqual(dates, payPeriod.from(date: previousDate, to: nextDate))
    }

    func testFirstAndFifteenthPayPeriodNoOverlap() {
        let payPeriod = PayPeriod.firstAndFifteenth(adjustForWeekends: false)
        let previousDate: Date = "01/03/2020"
        let nextDate: Date = "01/04/2020"

        XCTAssertEqual([], payPeriod.from(date: previousDate, to: nextDate))
    }

    func testFirstAndFifteenthEndsOnPayPeriod() {
        let payPeriod = PayPeriod.firstAndFifteenth(adjustForWeekends: false)
        let previousDate: Date = "01/01/2020"
        let nextDate: Date = "02/01/2020"

        let dates: [Date] = [
            "01/15/2020",
            "02/01/2020",
        ]

        XCTAssertEqual(dates, payPeriod.from(date: previousDate, to: nextDate))
    }

    func testFirstAndFifteenthNoMatchingDays() {
        let payPeriod = PayPeriod.firstAndFifteenth(adjustForWeekends: false)
        let previousDate: Date = "01/02/2020"
        let nextDate: Date = "04/18/2020"

        let dates: [Date] = [
            "01/15/2020",
            "02/01/2020",
            "02/15/2020",
            "03/01/2020",
            "03/15/2020",
            "04/01/2020",
            "04/15/2020",
        ]

        XCTAssertEqual(dates, payPeriod.from(date: previousDate, to: nextDate))
    }

    func testFirstAndFifteenthAdjustsForWeekends() {
        let payPeriod = PayPeriod.firstAndFifteenth(adjustForWeekends: true)
        let previousDate: Date = "01/02/2020"
        let nextDate: Date = "04/18/2020"

        let dates: [Date] = [
            "01/15/2020",
            "01/31/2020",
            "02/14/2020",
            "02/28/2020",
            "03/13/2020",
            "04/01/2020",
            "04/15/2020",
        ]

        XCTAssertEqual(dates, payPeriod.from(date: previousDate, to: nextDate))
    }

    // MARK: - Fifteenth and last

    func testFifteenthAndLastFirstMatches() {
        let payPeriod = PayPeriod.fifteenthAndLast(adjustForWeekends: false)
        let previousDate: Date = "01/15/2020"
        let nextDate: Date = "02/01/2020"

        let dates: [Date] = [
            "01/31/2020",
        ]

        XCTAssertEqual(dates, payPeriod.from(date: previousDate, to: nextDate))
    }

    func testFifteenthAndLastPayPeriodNoOverlap() {
        let payPeriod = PayPeriod.fifteenthAndLast(adjustForWeekends: false)
        let previousDate: Date = "01/03/2020"
        let nextDate: Date = "01/04/2020"

        XCTAssertEqual([], payPeriod.from(date: previousDate, to: nextDate))
    }

    func testFifteenthAndLastEndsOnPayPeriod() {
        let payPeriod = PayPeriod.fifteenthAndLast(adjustForWeekends: false)
        let previousDate: Date = "01/01/2020"
        let nextDate: Date = "01/31/2020"

        let dates: [Date] = [
            "01/15/2020",
            "01/31/2020",
        ]

        XCTAssertEqual(dates, payPeriod.from(date: previousDate, to: nextDate))
    }

    func testFifteenthAndLastNoMatchingDays() {
        let payPeriod = PayPeriod.fifteenthAndLast(adjustForWeekends: false)
        let previousDate: Date = "01/02/2020"
        let nextDate: Date = "05/01/2020"

        let dates: [Date] = [
            "01/15/2020",
            "01/31/2020",
            "02/15/2020",
            "02/29/2020",
            "03/15/2020",
            "03/31/2020",
            "04/15/2020",
            "04/30/2020",
        ]

        XCTAssertEqual(dates, payPeriod.from(date: previousDate, to: nextDate))
    }

    func testFifteenthAndLastAdjustsForWeekends() {
        let payPeriod = PayPeriod.fifteenthAndLast(adjustForWeekends: true)
        let previousDate: Date = "01/02/2020"
        let nextDate: Date = "05/01/2020"

        let dates: [Date] = [
            "01/15/2020",
            "01/31/2020",
            "02/14/2020",
            "02/28/2020",
            "03/13/2020",
            "03/31/2020",
            "04/15/2020",
            "04/30/2020",
        ]

        XCTAssertEqual(dates, payPeriod.from(date: previousDate, to: nextDate))
    }
}
