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
        let goal = Goal(emoji: "🌯", name: "Fri May 1", amount: 100, dayDueAt: "05/01/2020")
        let payPeriod = PayPeriod.weekly(day: 6)

        let dayBeforeDue: Date = "04/30/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: dayBeforeDue), expense.amount,
                       "It should be fully funded the day before it's due")

        let dayDue: Date = "05/01/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: dayDue), 20,
                       "It should be funded once the day it's due")

        let dayOfAnotherPayDay: Date = "05/15/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: dayOfAnotherPayDay), 60,
                       "It should be funded on pay day")

        let dayInbetweenPayDays: Date = "05/16/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: dayInbetweenPayDays), 60,
                       "It should be funded the correct amount in between pay days")
    }

    func testExpenseDueOffPayDayWeeklyFunding() {
        let expense = Expense(emoji: "🌯", name: "Wed May 5", amount: 100, dayDueAt: 5)
        let payPeriod = PayPeriod.weekly(day: 6)

        let dayBeforeDue: Date = "05/04/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: dayBeforeDue), expense.amount,
                       "It should be fully funded the day before it's due")

        let dayDue: Date = "05/05/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: dayDue), 0,
                       "It should be empty the day it's due")

        let payDay: Date = "05/08/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: payDay), 25,
                       "It should be funded on pay day")

        let dayInbetweenPayDays: Date = "05/16/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: dayInbetweenPayDays), 50,
                       "It should be funded the correct amount in between pay days")
    }

    func testExpenseDueOnPayDayFirstFifteenFunding() {
        let expense = Expense(emoji: "🌯", name: "Fri May 1", amount: 100, dayDueAt: 1)
        let payPeriod = PayPeriod.firstAndFifteenth(adjustForWeekends: false)

        let dayBeforeDue: Date = "04/30/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: dayBeforeDue), expense.amount,
                       "It should be fully funded the day before it's due")

        let dayDue: Date = "05/01/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: dayDue), 50,
                       "It should be funded once the day it's due")

        let dayOfAnotherPayDay: Date = "05/15/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: dayOfAnotherPayDay), expense.amount,
                       "It should be funded on pay day")

        let dayInbetweenPayDays: Date = "05/16/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: dayInbetweenPayDays), expense.amount,
                       "It should be funded the correct amount in between pay days")
    }

    func testExpenseDueOffPayDayFifteenLastFunding() {
        let expense = Expense(emoji: "🌯", name: "Wed May 5", amount: 100, dayDueAt: 5)
        let payPeriod = PayPeriod.fifteenthAndLast(adjustForWeekends: false)

        let dayBeforeDue: Date = "05/04/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: dayBeforeDue), expense.amount,
                       "It should be fully funded the day before it's due")

        let dayDue: Date = "05/05/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: dayDue), 0,
                       "It should be empty the day it's due")

        let payDay: Date = "05/15/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: payDay), 50,
                       "It should be funded on pay day")

        let dayInbetweenPayDays: Date = "05/16/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: dayInbetweenPayDays), 50,
                       "It should be funded the correct amount in between pay days")

        let lastPayDayBeforeDue: Date = "05/31/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: lastPayDayBeforeDue), expense.amount,
                       "It should be fully funded on the pay day before due")
    }

}
