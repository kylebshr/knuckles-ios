//
//  Widget.swift
//  Widget
//
//  Created by Kyle Bashour on 9/20/20.
//

import Combine
import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    private let controller = BalanceController()
    private var cancellable: AnyCancellable?

    private var isLoggedIn: Bool {
        UserDefaults.shared.loggedInUser != nil
    }

    init() {
        cancellable = controller.$balance.sink { _ in
            print("--- Published balance change")
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    func placeholder(in context: Context) -> BalanceEntry {
        print("--- Requesting placeholder")

        let nextDay = Calendar.current.component(.day, from: Date()) + 1
        let balance = BalanceState(account: 109.99, expenses: [Expense(name: "Apple Music", amount: 9.99, dayDueAt: nextDay)], goals: [])
        return BalanceEntry(date: Date(), configuration: ConfigurationIntent(), isLoggedIn: true, balance: balance)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (BalanceEntry) -> Void) {
        print("--- Requesting snapshot")

        if context.isPreview, !isLoggedIn {
            completion(placeholder(in: context))
        } else {
            let entry = BalanceEntry(date: Date(), configuration: configuration, isLoggedIn: isLoggedIn, balance: controller.balance)
            completion(entry)
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        print("--- Requesting timeline")

        controller.refresh { didRefresh in
            print("--- Controller refreshed \(didRefresh)")
        }

        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!

        let entry = BalanceEntry(date: currentDate, configuration: configuration, isLoggedIn: isLoggedIn, balance: controller.balance)
        let timeline = Timeline<BalanceEntry>(entries: [entry], policy: .after(refreshDate))

        completion(timeline)
    }
}

struct BalanceEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent

    let isLoggedIn: Bool
    let balance: BalanceState?
}

@main
struct Widgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        BalanceWidget()
        UpNextWidget()
    }
}

struct UpNextWidget: Widget {
    let kind = "UpNextWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            UpNextEntryView(entry: entry)
        }
        .configurationDisplayName("Up Next")
        .description("Check your balance and see your next expense.")
        .supportedFamilies([.systemSmall])
    }
}

struct BalanceWidget: Widget {
    let kind = "BalanceWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            BalanceEntryView(entry: entry)
        }
        .configurationDisplayName("Current Balance")
        .description("Check your available balance, bigly.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
