//
//  Widget.swift
//  Widget
//
//  Created by Kyle Bashour on 9/20/20.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let balance = BalanceController.shared.balance ?? BalanceState(account: 100, expenses: [], goals: [])
        return SimpleEntry(date: Date(), configuration: ConfigurationIntent(), balance: balance)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        print("------ Getting snapshot")

        BalanceController.shared.refresh { _ in
            print("------ Returning snapshot")
            let entry = SimpleEntry(date: Date(), configuration: ConfigurationIntent(), balance: BalanceController.shared.balance)
            completion(entry)
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {

        print("------ Getting timeline")

        BalanceController.shared.refresh { _ in
            print("----- Returning timeline")

            let currentDate = Date()
            let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
            let entry = SimpleEntry(date: refreshDate, configuration: configuration, balance: BalanceController.shared.balance)
            let timeline: Timeline<SimpleEntry> = Timeline(entries: [entry], policy: .atEnd)

            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let balance: BalanceState?
}

struct WidgetEntryView: View {
    var entry: SimpleEntry

    var body: some View {
        ZStack {
            Color.white
            HStack {
                VStack(alignment: .leading) {
                    Text("Balance")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.customLabel))
                    Text(entry.balance?.balance(using: .current).currency() ?? "Loading...")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.brand))
                        .minimumScaleFactor(0.1)
                        .scaledToFit()
                    Spacer(minLength: 15)
                    ZStack {
                        Color(.bubbleBackground)
                            .clipShape(ContainerRelativeShape())
                        VStack(alignment: .leading) {
                            Text("Due next")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)

                        HStack {
                            VStack(alignment: .leading) {

                                Text("Netflix")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                Text("$15.99")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(Font.system(size: 15, weight: .semibold))
                                .foregroundColor(.red)
                        }
                        }
                        .padding(8)
                    }
                    .padding([.leading, .trailing, .bottom], -8)
                }
                .padding()
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
        .description("Show your balance (account value less expenses and goals).")
        .supportedFamilies([.systemSmall])
    }
}

struct Widget_Previews: PreviewProvider {
    static var previews: some View {
        let entry = SimpleEntry(date: Date(), configuration: ConfigurationIntent(), balance: BalanceState(account: 473.19, expenses: [], goals: []))
        WidgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        WidgetEntryView(entry: entry).redacted(reason: .placeholder)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
