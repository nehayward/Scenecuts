//
//  ScenecutsWidget.swift
//  ScenecutsWidget
//
//  Created by Nick Hayward on 11/2/21.
//

import WidgetKit
import SwiftUI
import Intents

private class SceneUpdater {
    var scenesUpdated: (([WidgetInfo]) -> Void)?
    var hasCompleted: Bool = false

    init() {
        setupObserver()
    }

    func setupObserver() {
        DistributedNotificationCenter.default.addObserver(self, selector: #selector(updateScenes), name: .widgetTimelineScenes, object: nil)
    }

    func getUpdatedScene(completion: @escaping ([WidgetInfo]) -> Void) {
        scenesUpdated = { scenes in
            self.hasCompleted = true
            completion(scenes)
        }
        DistributedNotificationCenter.default().postNotificationName(.getScenesTimeline, object: nil, userInfo: nil, deliverImmediately: true)
    }

    @objc func updateScenes(_ notification: Notification) {
        guard let jsonEncodedString = notification.object as? String,
              let jsonEncoded = jsonEncodedString.removingPercentEncoding,
              let data = jsonEncoded.data(using: .utf8),
              let actionsSets = try? JSONDecoder().decode([WidgetInfo].self, from: data) else { return }

        print(actionsSets)
        scenesUpdated?(actionsSets)
    }

    deinit {
        DistributedNotificationCenter.default.removeObserver(self, name: .widgetTimelineScenes, object: nil)

    }
}

struct Provider: IntentTimelineProvider {
    private let sceneUpdater = SceneUpdater()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        sceneUpdater.getUpdatedScene { widgets in
            guard let scenes = configuration.HomekitScene else {
                completion(Timeline(entries: [], policy: .never))
                return
            }

            let foundList = widgets.filter { m in scenes.contains(where: { $0.identifier == m.id.uuidString }) }

            let homeScenes = foundList.map { widgetInfo -> HomeScene in
                let homeScene = HomeScene(identifier: widgetInfo.id.uuidString, display: widgetInfo.name)
                homeScene.iconName = widgetInfo.imageName
                return homeScene
            }
//            let homeScene = HomeScene(identifier: widget?.id.uuidString, display: widget?.name ?? "Weird")
//            homeScene.iconName = widget?.imageName

            let configuration = ConfigurationIntent()
            configuration.HomekitScene = homeScenes

            let entry = SimpleEntry(date: Date(), configuration: configuration)
            //
            //        // Create the timeline and call the completion handler. The .never reload
            //        // policy indicates that the containing app will use WidgetCenter methods
            //        // to reload the widget's timeline when the details change.
            let timeline = Timeline(entries: [entry], policy: .never)
            
            completion(timeline)
        }
        //
        //        // Construct a timeline entry for the current date, and include the character details.
        //        let entry = CharacterDetailEntry(date: Date(), detail: characterDetail)
        //
        //        // Create the timeline and call the completion handler. The .never reload
        //        // policy indicates that the containing app will use WidgetCenter methods
        //        // to reload the widget's timeline when the details change.
        //        let timeline = Timeline(entries: [entry], policy: .never)
        //        completion(timeline)
    }


}


struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct ScenecutsWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily

    var entry: Provider.Entry

    var body: some View {
        if widgetFamily == .systemSmall {
            VStack(spacing: 10) {
                if let iconName = entry.configuration.HomekitScene?.first?.iconName {
                    Image(systemName: iconName)
                        .font(.system(size: 60))
                        .symbolRenderingMode(.monochrome)
                        .foregroundColor(.white)
                        
                }
                Text(entry.configuration.HomekitScene?.first?.displayString ?? "Please select a scene")
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()
                    .multilineTextAlignment(.center)
            }
            .padding()
            .widgetURL(URL(string: "scenecuts://scene?id=\(entry.configuration.HomekitScene?.first?.identifier ?? "")"))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.linearGradient(Gradient(colors: [.red, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
        } else {
            ScenecutsWidgetEntryViewMultipleScenes(entry: entry)
        }
    }
}

struct ScenecutsWidgetEntryViewMultipleScenes: View {
    @Environment(\.widgetFamily) var widgetFamily

    var entry: Provider.Entry

    var body: some View {
        if let scenes = entry.configuration.HomekitScene {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], alignment: .center, spacing: 20) {
                ForEach(scenes, id: \.self) { scene in
                    Link(destination: URL(string: "scenecuts://scene?id=\(scene.identifier!)")!) {
                        VStack(spacing: 8) {
                            if let iconName = scene.iconName, !iconName.isEmpty {
                                Image(systemName: iconName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40, alignment: .center)
                                    .padding([.top, .leading, .trailing])
                                    .symbolRenderingMode(.monochrome)
                                    .foregroundColor(.white)
                            }
                            Text(scene.displayString)
                                .font(.title2)
                                .bold()
                                .minimumScaleFactor(0.4)
                                .lineLimit(1)
                                .padding([.bottom, .leading, .trailing])
                        }
                        .frame(width: 100, height: widgetFamily == .systemMedium ? 120 : 150, alignment: .center)
                        .background(ContainerRelativeShape().fill(.linearGradient(Gradient(colors: [.scenecutsRed, .scenecutsBlue]), startPoint: .topLeading, endPoint: .bottomTrailing)))
                    }
                }
            }.padding(.horizontal)
        } else {
            Text("Please select a scene (up to 3)")
                .foregroundColor(.white)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)    // << here !!
                .background(.linearGradient(Gradient(colors: [.red, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
        }
        
    }
}


extension Color {

    static let scenecutsBlue = Color(red: 40 / 255, green: 153 / 255, blue: 222 / 255)
    static let scenecutsRed = Color(red: 210 / 255, green: 69 / 255, blue: 76 / 255)
}



@main
struct ScenecutsWidget: Widget {
    let kind: String = "ScenecutsWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ScenecutsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Trigger HomeKit Scenes")
        .description("Easily trigger HomeKit scenes.")
    }
}

struct ScenecutsWidget_Previews: PreviewProvider {
    static var previews: some View {
        ScenecutsWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
