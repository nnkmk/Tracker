import UIKit

final class ScheduleCell: UITableViewCell {
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.tintColor = .gray
        switcher.thumbTintColor = .white
        switcher.onTintColor = UIColor(red: 0.216, green: 0.447, blue: 0.906, alpha: 1)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        return switcher
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        contentView.addSubview(title)
        contentView.addSubview(switcher)
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            switcher.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            switcher.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc private func switchChanged() {
        if switcher.isOn {
            selectedDays.append(title.text ?? "")
            switch title.text {
            case weekdays.monday.rawValue: shortSelectedDays.append("ПН")
            case weekdays.tuesday.rawValue: shortSelectedDays.append("ВТ")
            case weekdays.wednesday.rawValue: shortSelectedDays.append("СР")
            case weekdays.thursday.rawValue: shortSelectedDays.append("ЧТ")
            case weekdays.friday.rawValue: shortSelectedDays.append("ПТ")
            case weekdays.saturday.rawValue: shortSelectedDays.append("СБ")
            case weekdays.sunday.rawValue: shortSelectedDays.append("ВС")
            case .none:
                return
            case .some(_):
                return
            }
            let notification = Notification(name: Notification.Name("schedule_changed"))
            NotificationCenter.default.post(notification)
        } else {
            selectedDays.removeAll { $0 == title.text }
        }
    }
}
