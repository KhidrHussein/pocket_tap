import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), balance: "$0.00", isNegative: false, burnColor: .gray)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let data = UserDefaults(suiteName: "group.com.khidr.pockettap")
        let balance = data?.string(forKey: "balance") ?? "₦0.00"
        let isNegative = data?.bool(forKey: "is_negative") ?? false
        let colorInt = data?.integer(forKey: "burn_color") ?? 0xFF333333
        
        let red = Double((colorInt >> 16) & 0xFF) / 255.0
        let green = Double((colorInt >> 8) & 0xFF) / 255.0
        let blue = Double(colorInt & 0xFF) / 255.0
        let color = Color(red: red, green: green, blue: blue)
        
        let entry = SimpleEntry(date: Date(), balance: balance, isNegative: isNegative, burnColor: color)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { entry in
            let timeline = Timeline(entries: [entry], policy: .never)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let balance: String
    let isNegative: Bool
    let burnColor: Color
}

// iOS 17 Compatibility Wrappers
extension View {
    @ViewBuilder
    func applyWidgetBackground() -> some View {
        if #available(iOS 17.0, *) {
            self.containerBackground(for: .widget) {
                Color.black
            }
        } else {
            self.background(Color.black)
        }
    }
    
    @ViewBuilder
    func applyLegacyPadding() -> some View {
        if #available(iOS 17.0, *) {
            self
        } else {
            self.padding(16)
        }
    }
}

struct PocketTapWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            if #available(iOS 17.0, *) { } else {
                Color.black.edgesIgnoringSafeArea(.all)
            }
            
            if family == .systemSmall {
                Link(destination: URL(string: "pockettap://entry")!) {
                    VStack(spacing: 0) {
                        Spacer()
                        Text("TODAY")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.gray)
                            .unredacted()
                        
                        Text(entry.balance)
                            .font(.system(size: 32, weight: .heavy, design: .default))
                            .foregroundColor(entry.isNegative ? Color(red: 239/255, green: 68/255, blue: 68/255) : .white)
                            .minimumScaleFactor(0.4)
                            .lineLimit(1)
                            .unredacted()
                            .padding(.vertical, 8)
                        
                        Text("TAP TO LOG")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color(white: 0.3))
                            .unredacted()
                        Spacer()
                        
                        Rectangle()
                            .fill(entry.burnColor)
                            .frame(height: 3)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .applyLegacyPadding()
                }
            } else {
                VStack(spacing: 0) {
                    Spacer()
                    Text(entry.balance)
                        .font(.system(size: 42, weight: .heavy, design: .default))
                        .foregroundColor(entry.isNegative ? Color(red: 239/255, green: 68/255, blue: 68/255) : .white)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .unredacted()
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Link(destination: URL(string: "pockettap://entry?type=income")!) {
                            Text("+ INCOME")
                                .font(.system(size: 14, weight: .bold))
                                .frame(maxWidth: .infinity, maxHeight: 48)
                                .background(Color(red: 16/255, green: 185/255, blue: 129/255))
                                .foregroundColor(.black)
                                .unredacted()
                        }
                        
                        Link(destination: URL(string: "pockettap://entry?type=expense")!) {
                            Text("- EXPENSE")
                                .font(.system(size: 14, weight: .bold))
                                .frame(maxWidth: .infinity, maxHeight: 48)
                                .background(Color(red: 239/255, green: 68/255, blue: 68/255))
                                .foregroundColor(.white)
                                .unredacted()
                        }
                    }
                    
                    Spacer().frame(height: 16)
                    
                    Rectangle()
                        .fill(entry.burnColor)
                        .frame(height: 3)
                }
                .applyLegacyPadding()
            }
        }
        .applyWidgetBackground()
    }
}

@main
struct PocketTapWidget: Widget {
    let kind: String = "PocketTapWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PocketTapWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("PocketTap")
        .description("Track your daily allowance instantly.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
