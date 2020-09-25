//
//  WidgetEntryView.swift
//  Widget
//
//  Created by Kyle Bashour on 9/25/20.
//

import SwiftUI
import WidgetKit

struct WidgetEntryView: View {
    var entry: BalanceEntry

    private var showUpNext: Bool {
        entry.configuration.showUpNext.flatMap(Bool.init) ?? true
    }

    var body: some View {
        let balance = entry.balance?.balance(using: .current).currency() ?? "-"

        ZStack {
            Color(.customBackground)
            if entry.isLoggedIn {
                BalanceView(
                    balance: balance,
                    showUpNext: showUpNext,
                    upNext: entry.balance?.expenses.first
                )
            } else {
                LogInView()
            }
        }
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        let expense = Expense(emoji: " ", name: "Netflix", amount: 15.99, dayDueAt: 27)
        let balance = BalanceState(account: 47.19, expenses: [expense], goals: [])

        let entry = BalanceEntry(date: Date(), configuration: .init(), isLoggedIn: true, balance: balance)
        let expenseEntry = BalanceEntry(date: Date(), configuration: .init(), isLoggedIn: true, balance: balance)
        let loggedOut = BalanceEntry(date: Date(), configuration: .init(), isLoggedIn: false, balance: nil)

        WidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        WidgetEntryView(entry: loggedOut)
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        WidgetEntryView(entry: expenseEntry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        WidgetEntryView(entry: expenseEntry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .environment(\.colorScheme, .dark)

        WidgetEntryView(entry: expenseEntry).redacted(reason: .placeholder)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
