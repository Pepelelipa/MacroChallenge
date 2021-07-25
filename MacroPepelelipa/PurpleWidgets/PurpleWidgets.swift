//
//  PurpleWidgets.swift
//  PurpleWidgets
//
//  Created by Pedro Farina on 25/07/21.
//  Copyright © 2021 Pedro Giuliano Farina. All rights reserved.
//

import WidgetKit
import SwiftUI
import Database

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct PurpleWidgetsEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            VStack(alignment: .leading, spacing: 2) {
                Image("Book").foregroundColor(.blue).overlay(Image("BooklikeShadow"))
                Text("Computação Visual").font(.headline.weight(.bold)).lineLimit(2).minimumScaleFactor(0.9)
                Text("Universidade").font(.caption2.weight(.light).italic())
                Text("07 Notas").font(.caption2.weight(.light).italic())
            }.padding(.leading, 15).padding(.vertical, 15)
            VStack(alignment: .leading) {
                Text("Computação Visual").font(.caption2.bold())
                Divider()
                Text("Computação Visual").font(.caption2.bold())
                Divider()
                Text("Computação Visual").font(.caption2.bold())
                Divider()
                Text("+3 notas").font(.caption2.bold())
            }.padding(.vertical, 15)
        }
    }
}

@main
struct PurpleWidgets: Widget {
    let kind: String = "PurpleWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PurpleWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct PurpleWidgets_Previews: PreviewProvider {
    static var previews: some View {
        PurpleWidgetsEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
