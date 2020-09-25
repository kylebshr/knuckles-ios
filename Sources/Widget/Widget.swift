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
    let controller = BalanceController()
    var cancellable: AnyCancellable?

    init() {
        cancellable = controller.$balance.sink { _ in
            print("--- Published balance change")
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    func placeholder(in context: Context) -> SimpleEntry {
        print("--- Requesting placeholder")

        let balance = controller.balance ?? BalanceState(account: 100, expenses: [], goals: [])
        return SimpleEntry(date: Date(), configuration: ConfigurationIntent(), balance: balance)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        print("--- Requesting snapshot")

        let balance = controller.balance ?? BalanceState(account: 100, expenses: [], goals: [])
        let entry = SimpleEntry(date: Date(), configuration: configuration, balance: balance)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        print("--- Requesting timeline")

        controller.refresh { didRefresh in
            print("--- Controller refreshed \(didRefresh)")
        }

        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!

        let entry = SimpleEntry(date: currentDate, configuration: configuration, balance: controller.balance)
        let timeline = Timeline<SimpleEntry>(entries: [entry], policy: .after(refreshDate))

        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let balance: BalanceState?
}

struct WidgetEntryView: View {
    var entry: SimpleEntry

    private var showUpNext: Bool {
        entry.configuration.showUpNext.flatMap(Bool.init) ?? true
    }

    var body: some View {
        let willShowUpNext = showUpNext && entry.balance?.expenses.first != nil
        ZStack {
            Color(.customBackground)
            HStack {
                VStack(alignment: .leading) {
                    if !willShowUpNext {
                        Spacer()
                    }

                    Text("Balance")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(.customSecondaryLabel))
                    let balance = entry.balance?.balance(using: .current).currency() ?? "Loading..."
                    Text(balance)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(.emphasis))
                        .minimumScaleFactor(0.1)
                        .scaledToFit()
                    Spacer()

                    if showUpNext, let expense = entry.balance?.expenses.first {
                        Text("Up next")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(.customSecondaryLabel))
                        Spacer()
                        ZStack {
                            Color(.bubbleBackground)
                                .clipShape(ContainerRelativeShape())
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(expense.name)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Color(.customLabel))
                                    Text(DateFormatter.readyByFormatter.string(from: expense.nextDueDate()))
                                        .font(.system(size: 16, weight: .regular))
                                        .foregroundColor(Color(.customLabel))
                                }
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(Font.system(size: 16, weight: .semibold))
                                    .foregroundColor(.red)
                            }
                            .padding(8)
                        }
                        .padding([.leading, .trailing, .bottom], -8)
                    }
                }
                .padding()

                if !willShowUpNext {
                    Spacer()
                }
            }
        }
    }
}

@main
struct BalanceWidget: Widget {
    let kind: String = "Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Balance")
        .description("Check your balance and see your next expense.")
        .supportedFamilies([.systemSmall])
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        let expense = Expense(emoji: " ", name: "Netflix", amount: 15.99, dayDueAt: 27)
        let entry = SimpleEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            balance: BalanceState(account: 47.19, expenses: [], goals: [])
        )

        let expenseEntry = SimpleEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            balance: BalanceState(account: 47.19, expenses: [expense], goals: [])
        )

        WidgetEntryView(entry: entry)
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
