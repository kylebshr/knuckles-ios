import XCTest
@testable import Knuckles

class ExpenseTests: XCTestCase {

    /*

     Every test should test:
     - Day before it's due (fully funded)
     - Day it's due (spent or partially funded)
     - Day of a payday (funded including that pay day)
     - Midway due

     */

    func testExpenseDueOnPayDay() {
        let expense = Expense(name: "Fri May 1", amount: 100, dayDueAt: 1)
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

    func testExpenseDueOffPayDay() {
        let expense = Expense(name: "Wed May 5", amount: 100, dayDueAt: 5)
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
}
