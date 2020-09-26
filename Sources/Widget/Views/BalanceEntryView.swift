//
//  BalanceEntryView.swift
//  Widget
//
//  Created by Kyle Bashour on 9/25/20.
//

import SwiftUI
import WidgetKit

struct BalanceEntryView: View {
    var entry: BalanceEntry

    var body: some View {
        let string: String = {
            if let balance = entry.balance?.balance(using: .current).abbreviated() {
                return balance
            } else {
                return "-"
            }
        }()

        ZStack {
            Color(.customBackground)
            if entry.isLoggedIn {
                HStack {
                    VStack {
                        Spacer()
                        (Text("$").foregroundColor(Color(UIColor.emphasis.withAlphaComponent(0.5)))
                            .font(.system(size: 80, weight: .bold)) +
                            Text(string)
                            .foregroundColor(Color(.emphasis)))
                        .font(.system(size: 100, weight: .black))
                        .minimumScaleFactor(0.1)
                        .scaledToFit()
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
            } else {
                LogInView()
            }
        }
    }
}

struct BalanceEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let balance = BalanceState(account: 47.19, expenses: [], goals: [])
        let bigBalance = BalanceState(account: 44937.39, expenses: [], goals: [])

        let entry = BalanceEntry(date: Date(), configuration: .init(), isLoggedIn: true, balance: balance)
        let bigEntry = BalanceEntry(date: Date(), configuration: .init(), isLoggedIn: true, balance: bigBalance)
        let loggedOut = BalanceEntry(date: Date(), configuration: .init(), isLoggedIn: false, balance: nil)

        BalanceEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))

        BalanceEntryView(entry: bigEntry)
            .previewContext(WidgetPreviewContext(family: .systemMedium))

        BalanceEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemMedium))

        BalanceEntryView(entry: loggedOut)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
