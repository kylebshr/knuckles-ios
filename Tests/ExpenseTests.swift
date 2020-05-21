import XCTest
@testable import Knuckles

class ExpenseTests: XCTestCase {

    func testExpenseCreatedToday() {

        let expense = Expense(createdAt: Date(), dayDueAt: 12, amount: 100)
        let period = PayPeriod.weekly(day: 5)

        print(expense.amountSaved(using: period))
        print(expense.nextAmountSaved(using: period))
    }

}
