import UIKit

struct Tracker: Codable {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let day: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, color, emoji, day
    }
    
    init(id: UUID, name: String, color: UIColor, emoji: String, day: [String]?) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.day = day
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        let colorData = try container.decode(Data.self, forKey: .color)
        color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor ?? .black
        emoji = try container.decode(String.self, forKey: .emoji)
        day = try container.decodeIfPresent([String].self, forKey: .day)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        try container.encode(colorData, forKey: .color)
        try container.encode(emoji, forKey: .emoji)
        try container.encodeIfPresent(day, forKey: .day)
    }
}

struct TrackerCategory: Codable {
    let label: String
    var trackers: [Tracker]
}

struct TrackerRecord: Hashable, Codable {
    let id: UUID
    let date: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(date)
    }
    
    static func == (lhs: TrackerRecord, rhs: TrackerRecord) -> Bool {
        return lhs.id == rhs.id && lhs.date == rhs.date
    }
}

var trackers: [TrackerCategory] = []
var categoryName = ""
let daysOfWeek: [weekdays] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
var selectedDays: [String] = []
var shortSelectedDays: [String] = []
var titles: [String] = []
var completedTrackers: [TrackerRecord] = []

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
