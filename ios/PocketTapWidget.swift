import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), balance: "₦0.00", isNegative: false, burnColor: .gray)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let data = UserDefaults(suiteName: "group.com.example.pockettap")
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

struct PocketTapWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Text(entry.balance)
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundColor(entry.isNegative ? Color(red: 239/255, green: 68/255, blue: 68/255) : .white)
                Spacer()
            }
            
            VStack {
                Spacer()
                HStack {
                    Link(destination: URL(string: "pockettap://entry?type=income")!) {
                        Text("+")
                            .frame(width: 48, height: 48)
                            .background(Color(red: 16/255, green: 185/255, blue: 129/255))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Link(destination: URL(string: "pockettap://entry?type=expense")!) {
                        Text("-")
                            .frame(width: 48, height: 48)
                            .background(Color(red: 239/255, green: 68/255, blue: 68/255))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 12)
            }
            
            VStack {
                Spacer()
                Rectangle()
                    .fill(entry.burnColor)
                    .frame(height: 2)
            }
        }
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
        .supportedFamilies([.systemSmall])
    }
}
