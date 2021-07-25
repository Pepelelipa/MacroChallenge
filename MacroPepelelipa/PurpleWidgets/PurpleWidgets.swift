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
        SimpleEntry(date: Date(), notebook: PreviewNotebook())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), notebook: PreviewNotebook())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, notebook: PreviewNotebook())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let notebook: NotebookEntity
    
    func nonOptionalWorkspaceName() -> String {
        (try? notebook.getWorkspace().name) ?? ""
    }
    func amountOfNotes() -> String {
        return String(format: "%02d", notebook.notes.count) + " " + "Notes".localized()
    }
    func amountOfNoteViews() -> Int {
        return min(4, notebook.notes.count)
    }
    func lastNoteName() -> String {
        if notebook.notes.count > 4 {
            return "+\(notebook.notes.count - 3) " + "notes".localized()
        } else {
            return notebook.notes[amountOfNoteViews() - 1].title.string
        }
    }
    func hasMoreNotesThanFits() -> Bool {
        return notebook.notes.count > 4
    }
}

struct PurpleWidgetsEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            VStack(alignment: .leading, spacing: 2) {
                Image("Book").foregroundColor(Color(entry.notebook.colorName)).overlay(Image("BooklikeShadow"))
                Text(entry.notebook.name).font(.headline.weight(.bold)).lineLimit(2).minimumScaleFactor(0.9)
                Text(entry.nonOptionalWorkspaceName()).font(.caption2.weight(.light).italic())
                Text(entry.amountOfNotes()).font(.caption2.weight(.light).italic())
            }.padding(.leading, 15).padding(.vertical, 15)
            VStack(alignment: .leading) {
                ForEach((0 ..< entry.amountOfNoteViews()), id: \.self) {
                    if $0 == entry.amountOfNoteViews() - 1 {
                        Text(entry.lastNoteName()).font(.caption2.bold())
                    } else {
                        Text(entry.notebook.notes[$0].title.string).font(.caption2.bold())
                        Divider()
                    }
                }
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
        PurpleWidgetsEntryView(entry: SimpleEntry(date: Date(), notebook: PreviewNotebook()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

private class PreviewNote: NoteEntity {
    var title: NSAttributedString = NSAttributedString(string: "Introduction to Swift")
    var text: NSAttributedString = NSAttributedString()
    var images: [ImageBoxEntity] = []
    var textBoxes: [TextBoxEntity] = []
    func getNotebook() throws -> NotebookEntity {
        return PreviewNotebook()
    }
    
    func addObserver(_ observer: EntityObserver) { }
    func removeObserver(_ observer: EntityObserver) { }
    func save() throws { }
    func getID() throws -> UUID {
        return UUID()
    }
}

private class PreviewNotebook: NotebookEntity {
    var name: String = "Computer Engineering"
    var colorName: String = "nb1"
    var notes: [NoteEntity] = [
        PreviewNote(),
        PreviewNote(),
        PreviewNote(),
        PreviewNote(),
        PreviewNote()
    ]
    var indexes: [NotebookIndexEntity] = []
    func getWorkspace() throws -> WorkspaceEntity {
        return PreviewWorkspace()
    }
    func addObserver(_ observer: EntityObserver) { }
    func removeObserver(_ observer: EntityObserver) { }
    func save() throws { }
    func getID() throws -> UUID {
        return UUID()
    }
}

private class PreviewWorkspace: WorkspaceEntity {
    var name: String = "College"
    var notebooks: [NotebookEntity] = []
    var isEnabled: Bool = false
    
    func addObserver(_ observer: EntityObserver) { }
    func removeObserver(_ observer: EntityObserver) { }
    func save() throws { }
    func getID() throws -> UUID {
        return UUID()
    }
}
