import XCTest
@testable import Knuckles

class GoalTests: XCTestCase {

    /*

     Every test should test:
     - Day before it's due (fully funded)
     - Day it's due (spent or partially funded)
     - Day of a payday (funded including that pay day)
     - Midway due

     */

    func testGoalDueOnPayDayWeeklyFunding() {
        let goal = Goal(emoji: "🌯", name: "Fri May 1", amount: 100, dayDueAt: "06/01/2020", createdAt: "04/01/2020")
        let payPeriod = PayPeriod.weekly(day: 6)

        let fundingAmount = Decimal(100) / 9.0

        let dayBeforeDue: Date = "05/31/2020"
        XCTAssertEqual(goal.amountSaved(using: payPeriod, on: dayBeforeDue), fundingAmount * 9,
                       "It should be fully funded the day before it's due")

        let dayDue: Date = "06/01/2020"
        XCTAssertEqual(goal.amountSaved(using: payPeriod, on: dayDue), fundingAmount * 9,
                       "It should be funded on the day it's due")

        let dayOfAnotherPayDay: Date = "05/15/2020"
        XCTAssertEqual(goal.amountSaved(using: payPeriod, on: dayOfAnotherPayDay), fundingAmount * 7,
                       "It should be funded on pay day")

        let dayInbetweenPayDays: Date = "05/16/2020"
        XCTAssertEqual(goal.amountSaved(using: payPeriod, on: dayInbetweenPayDays), fundingAmount * 7,
                       "It should be funded the correct amount in between pay days")

        let dayFarPastDueDay: Date = "08/01/2020"
        XCTAssertEqual(goal.amountSaved(using: payPeriod, on: dayFarPastDueDay), fundingAmount * 9,
                       "It should be stop being funded on after the due day")
    }

}
