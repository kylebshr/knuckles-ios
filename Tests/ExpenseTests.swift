import XCTest
@testable import Knuckles

class ExpenseTests: XCTestCase {

    func testExpenseDueOnPayDay() {
        let expense = Expense(name: "Fri May 1", amount: 100, dayDueAt: 1)
        let payPeriod = PayPeriod.weekly(day: 6)

        let payDay: Date = "05/01/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: payDay), expense.amount,
                       "The expense should be fully funded on the pay day")

        let dayBeforePayDay: Date = "04/30/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: dayBeforePayDay), 80,
                       "The expense should not be fully funded before the pay day")

        let dayAfterPayDay: Date = "05/02/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: dayAfterPayDay), 0,
                       "The expense should have no funding after pay day")
    }

    func testExpenseDueInBetweenPayDay() {
        let expense = Expense(name: "Fri May 4", amount: 100, dayDueAt: 4)
        let payPeriod = PayPeriod.weekly(day: 6)

        let payDay: Date = "05/01/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: payDay), expense.amount,
                       "The expense should be fully funded on the pay day")

        let dueDay: Date = "05/04/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: dueDay), expense.amount,
                       "The expense should be fully funded the day it's due")

        let dayAfterDue: Date = "05/05/2020"
        XCTAssertEqual(expense.amountSaved(using: payPeriod, on: dayAfterDue), 0,
                       "The expense should have no funding after it's due")
    }
}
