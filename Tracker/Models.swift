import UIKit

var trackers: [TrackerCategory] = []
var categoryName = ""
let daysOfWeek: [weekdays] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
var selectedDays: [String] = []
var shortSelectedDays: [String] = []
var titles: [String] = []
var completedTrackers: [TrackerRecord] = []

struct TrackerCategory {
    let label: String
    let trackers: [Tracker]
    
    init(label: String, trackers: [Tracker]) {
        self.label = label
        self.trackers = trackers
    }
}

struct TrackerRecord {
    let id: UUID
    let day: String
    
    init(id: UUID, day: String) {
        self.id = id
        self.day = day
    }
}

struct Tracker {
    let id: UUID
    let name: String
    let emoji: String
    let color: UIColor
    let day: [String]?
    
    init(id: UUID = UUID(), name: String, emoji: String, color: UIColor, day: [String]?) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.color = color
        self.day = day
    }
}

enum weekdays: String {
    case monday = "понедельник"
    case tuesday = "вторник"
    case wednesday = "среда"
    case thursday = "четверг"
    case friday = "пятница"
    case saturday = "суббота"
    case sunday = "воскресенье"
}

let emojiCollectionData = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]

let colorCollectionData = [
    UIColor.colorOne, UIColor.colorTwo, UIColor.colorThree, UIColor.colorFour, UIColor.colorFive, UIColor.colorSix,
    UIColor.colorSeven, UIColor.colorEight, UIColor.colorNine, UIColor.colorTen, UIColor.colorEleven, UIColor.colorTwelve,
    UIColor.colorThirteen, UIColor.сolorFourteen, UIColor.сolorFiveteen,
    UIColor.colorSixteen, UIColor.colorSeventeen, UIColor.colorEighteen
]
