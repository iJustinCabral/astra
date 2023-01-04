//
//  AstraWidget.swift
//  AstraWidget
//
//  Created by Justin Cabral on 1/2/23.
//

import WidgetKit
import SwiftUI


struct StarPhoto: Codable, Hashable {
    let date: String
    let explanation: String
    let hdurl : String
    let media_type : String
    let service_version: String
    let title: String
    let url: String
}

protocol Service {
    func fetchStarPhoto() async throws -> StarPhoto
}

final class AstraService: Service {
    
    enum APIendpoint {
        static let baseURL = "https://go-apod.herokuapp.com/apod"
    }
    
    func fetchStarPhoto() async throws -> StarPhoto {
        let urlSession = URLSession.shared
        let url = URL(string: APIendpoint.baseURL)
        let (data, _) = try await urlSession.data(from: url!)
        
        return try JSONDecoder().decode(StarPhoto.self, from: data)
    }
    
}

struct NetworkImage: View {

  public let url: URL?

  var body: some View {

    Group {
     if let url = url, let imageData = try? Data(contentsOf: url),
       let uiImage = UIImage(data: imageData) {

       Image(uiImage: uiImage)
         .resizable()
         .aspectRatio(contentMode: .fill)
      }
      else {
       Image("placeholder-image")
      }
    }
  }

}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
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

struct AstraPhoto: TimelineEntry {
    let date: Date
    let image: Image
}

struct AstraWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        AsyncImage(url: URL(string: "https://go-apod.herokuapp.com/apod")) { phase in
            if let photo = phase.image {
                photo
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

struct AstraWidget: Widget {
    let kind: String = "AstraWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AstraWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Astra")
        .description("A widget containing a daily astronomical photo to inspire awe and wonder.")
    }
}

struct AstraWidget_Previews: PreviewProvider {
    static var previews: some View {
        AstraWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
