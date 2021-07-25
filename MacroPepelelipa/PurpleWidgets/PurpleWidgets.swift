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
    func placeholder(in context: Context) -> NotebookEntry {
        NotebookEntry(date: Date(), notebook: PreviewNotebook())
    }

    func getSnapshot(in context: Context, completion: @escaping (NotebookEntry) -> Void) {
        let entry: NotebookEntry
        if !context.isPreview,
           let notebook = try? DataManager.shared().fetchLastUsedNotebooks(max: 1).first {
            entry = NotebookEntry(date: Date(), notebook: notebook)
        } else {
            entry = NotebookEntry(date: Date(), notebook: PreviewNotebook())
        }
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [NotebookEntry] = []

        if let notebooks = try? DataManager.shared().fetchLastUsedNotebooks(max: 10) {
            for notebook in notebooks {
                entries.append(NotebookEntry(date: notebook.lastAccess ?? Date(), notebook: notebook))
            }
        }

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct NotebookEntry: TimelineEntry {
    let date: Date
    let notebook: RecentNotebook
    
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
struct RecentNotebookWidget: Widget {
    let kind: String = "RecentNotebook"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PurpleWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Recent Notebooks".localized())
        .description("Quick access your recent notebooks.".localized())
        .supportedFamilies([.systemMedium])
    }
}

struct PurpleWidgets_Previews: PreviewProvider {
    static var previews: some View {
        PurpleWidgetsEntryView(entry: NotebookEntry(date: Date(), notebook: PreviewNotebook()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

private class PreviewNote: RecentNote {
    var title: NSAttributedString = NSAttributedString(string: "Introduction to Swift".localized())
    var text: NSAttributedString = NSAttributedString()
    var images: [ImageBoxEntity] = []
    var textBoxes: [TextBoxEntity] = []
    func getNotebook() throws -> RecentNotebook {
        return PreviewNotebook()
    }
    
    func addObserver(_ observer: EntityObserver) { }
    func removeObserver(_ observer: EntityObserver) { }
    func save() throws { }
    func getID() throws -> UUID {
        return UUID()
    }
}

private class PreviewNotebook: RecentNotebook {
    var name: String = "Computer Engineering".localized()
    var colorName: String = "nb1"
    var notes: [RecentNote] = [
        PreviewNote(),
        PreviewNote(),
        PreviewNote(),
        PreviewNote(),
        PreviewNote()
    ]
    var lastAccess: Date? = Date()
    func getWorkspace() throws -> RecentWorkspace {
        return PreviewWorkspace()
    }
}

private class PreviewWorkspace: RecentWorkspace {
    var name: String = "College".localized()
    var notebooks: [RecentNotebook] = []
}
