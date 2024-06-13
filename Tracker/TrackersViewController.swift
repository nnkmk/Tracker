import UIKit

protocol TrackersViewControllerProtocol: AnyObject {
    func saveDoneEvent(id: UUID, index: IndexPath)
    var localTrackers: [TrackerCategory] { get set }
}

protocol TrackerCellDelegate: AnyObject {
    func didTapPlusButton(in cell: TrackerCell)
}

class TrackersViewController: UIViewController {
    
    var categories: [TrackerCategory] = []
    var localTrackers: [TrackerCategory] = []
    var completedTrackers: Set<TrackerRecord> = []
    var currentDate: Date = Date()
    var dateString: String = ""
    var changeByNumbers: String = ""
    var choosenDay = ""
    
    var trackersCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 9
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(TrackerCell.self, forCellWithReuseIdentifier: "trackers")
        collection.register(CollectionHeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    let plusButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 19, height: 18))
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)), for: .normal)
        button.tintColor = .black
        button.addTarget(nil, action: #selector(plusTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let trackersLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.calendar = Calendar(identifier: .iso8601)
        picker.maximumDate = Date()
        picker.locale = Locale(identifier: "ru_RU")
        return picker
    }()
    
    let starImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "star"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 8.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Поиск"
        search.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideCollection()
        setupProperties()
        setupView()
        loadCompletedTrackers()
        updateCollection()
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    private func loadInitialCategories() {
        categories = loadCategories() ?? []
        localTrackers = categories
        print("Категории при загрузке TrackersViewController: \(categories)")
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            plusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            plusButton.widthAnchor.constraint(equalToConstant: 19),
            plusButton.heightAnchor.constraint(equalToConstant: 18),
    
            trackersLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 13),
            trackersLabel.leadingAnchor.constraint(equalTo: plusButton.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            datePicker.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 13),
            datePicker.widthAnchor.constraint(equalToConstant: 120),
            
            searchBar.topAnchor.constraint(equalTo: trackersLabel.bottomAnchor, constant: 7),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            trackersCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 7),
            trackersCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackersCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            plusButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
//            plusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            plusButton.widthAnchor.constraint(equalToConstant: 19),
//            plusButton.heightAnchor.constraint(equalToConstant: 18),
//            
//            trackersLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 13),
//            trackersLabel.leadingAnchor.constraint(equalTo: plusButton.leadingAnchor),
//            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            datePicker.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 13),
//            datePicker.widthAnchor.constraint(equalToConstant: 120),
//            
//            searchBar.topAnchor.constraint(equalTo: trackersLabel.bottomAnchor, constant: 7),
//            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
//            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
//            
//            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
//            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            trackersCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 7),
//            trackersCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            trackersCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            trackersCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
        
        trackersCollection.isHidden = true
        if !localTrackers.isEmpty {
            stackView.isHidden = true
            trackersCollection.isHidden = false
        }
    }
    
    private func setupProperties() {
        makeDate(dateFormat: "EEEE")
        NotificationCenter.default.addObserver(self, selector: #selector(addEvent), name: Notification.Name("addEvent"), object: nil)
        stackView.addArrangedSubview(starImage)
        stackView.addArrangedSubview(questionLabel)
        
        view.addSubview(plusButton)
        view.addSubview(trackersLabel)
        view.addSubview(datePicker)
        view.addSubview(stackView)
        view.addSubview(trackersCollection)
        view.addSubview(searchBar)
        
        trackersCollection.dataSource = self
        trackersCollection.delegate = self
        
        searchBar.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func updateCollection() {
        var newEvents: [Tracker] = []
        var newCategory: String = ""
        var newTrackers: [TrackerCategory] = []
        localTrackers = []
        var isGood = false
        
        for category in categories {
            newCategory = category.label
            for event in category.trackers {
                if event.day?.contains(choosenDay) ?? false || event.day == nil {
                    newEvents.append(event)
                    isGood = true
                }
            }
            if isGood {
                newTrackers.append(TrackerCategory(label: newCategory, trackers: newEvents))
                newEvents = []
                isGood = false
                newCategory = ""
            }
        }
        localTrackers = newTrackers
    }
    
    private func hideCollection() {
        if !localTrackers.isEmpty {
            stackView.isHidden = true
            trackersCollection.isHidden = false
        } else {
            stackView.isHidden = false
            trackersCollection.isHidden = true
        }
        print("Состояние коллекции скрыто: \(localTrackers.isEmpty ? "пусто" : "не пусто")")
    }
    
    private func saveCategories() {
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: "categories")
            print("Категории успешно сохранены")
        } else {
            print("Ошибка при сохранении категорий")
        }
    }
    
    private func loadCategories() -> [TrackerCategory]? {
        if let savedCategories = UserDefaults.standard.data(forKey: "categories") {
            if let loadedCategories = try? JSONDecoder().decode([TrackerCategory].self, from: savedCategories) {
                print("Категории успешно загружены")
                return loadedCategories
            } else {
                print("Ошибка при загрузке категорий")
            }
        } else {
            print("Нет сохраненных категорий")
        }
        return nil
    }
    
    private func makeDate(from date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    private func updateTrackerCell(at indexPath: IndexPath) {
        let tracker = localTrackers[indexPath.section].trackers[indexPath.row]
        let dateString = makeDate(from: currentDate, format: "yyyy/MM/dd")
        
        if let cell = trackersCollection.cellForItem(at: indexPath) as? TrackerCell {
            let numberOfDays = completedTrackers.filter { $0.id == tracker.id }.count
            cell.quantity.text = "\(numberOfDays) дней"
            
            if completedTrackers.contains(TrackerRecord(id: tracker.id, date: dateString)) {
                cell.plusButton.backgroundColor = tracker.color.withAlphaComponent(0.5)
                cell.plusButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            } else {
                cell.plusButton.backgroundColor = tracker.color
                cell.plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
            }
            print("Ячейка с indexPath \(indexPath) успешно обновлена")
        } else {
            print("Ошибка: не удалось найти ячейку для indexPath \(indexPath)")
        }
    }
    
    private func saveCompletedTrackers() {
        do {
            let encodedData = try JSONEncoder().encode(Array(completedTrackers))
            UserDefaults.standard.set(encodedData, forKey: "completedTrackers")
            print("Выполненные трекеры успешно сохранены: \(completedTrackers)")
        } catch {
            print("Ошибка при сохранении выполненных трекеров: \(error)")
        }
    }
    
    private func loadCompletedTrackers() {
        if let savedData = UserDefaults.standard.data(forKey: "completedTrackers") {
            do {
                completedTrackers = try JSONDecoder().decode(Set<TrackerRecord>.self, from: savedData)
                print("Выполненные трекеры успешно загружены: \(completedTrackers)")
            } catch {
                print("Ошибка при загрузке выполненных трекеров: \(error)")
            }
        } else {
            print("Нет сохраненных выполненных трекеров")
        }
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        currentDate = sender.date
        choosenDay = makeDate(from: currentDate, format: "EEEE")
        updateCollection()
        hideCollection()
        trackersCollection.reloadData()
    }
    
    @objc private func plusTapped() {
        let selecterTrackerVC = TypeViewController()
        show(selecterTrackerVC, sender: self)
    }
    
    @objc private func addEvent() {
        print("Получено уведомление addEvent")
        categories = loadCategories() ?? []
        updateCollection()
        trackersCollection.reloadData()
        hideCollection()
        print("Категории после обновления: \(categories)")
        print("Текущие локальные трекеры: \(localTrackers)")
    }
    
    @objc func dismissKeyboard() {
        updateCollection()
        searchBar.resignFirstResponder()
    }
}


extension TrackersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return localTrackers[section].trackers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return localTrackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackers", for: indexPath) as? TrackerCell
        cell?.delegate = self
        cell?.viewBackground.backgroundColor = localTrackers[indexPath.section].trackers[indexPath.row].color
        cell?.emoji.text = localTrackers[indexPath.section].trackers[indexPath.row].emoji
        cell?.name.text = localTrackers[indexPath.section].trackers[indexPath.row].name
        cell?.plusButton.backgroundColor = localTrackers[indexPath.section].trackers[indexPath.row].color
        let numberOfDays = completedTrackers.filter {$0.id == localTrackers[indexPath.section].trackers[indexPath.row].id}.count
        if numberOfDays == 0 {
            changeByNumbers = "дней" }
        else if numberOfDays < 2 {
            changeByNumbers = "день" }
        else if numberOfDays < 5 {
            changeByNumbers = "дня" }
        else { changeByNumbers = "дней"
        }
        cell?.quantity.text = "\(numberOfDays) \(changeByNumbers)"
        makeDate(dateFormat: "yyyy/MM/dd")
        if completedTrackers.filter({$0.id == localTrackers[indexPath.section].trackers[indexPath.row].id}).contains(where: {$0.date == dateString}) {
            cell?.plusButton.backgroundColor = localTrackers[indexPath.section].trackers[indexPath.row].color.withAlphaComponent(0.5)
            cell?.plusButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            cell?.plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! CollectionHeaderSupplementaryView
        header.title.text = localTrackers[indexPath.section].label
        return header
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 41) / 2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
}

extension TrackersViewController: UICollectionViewDelegate {}

extension TrackersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var newEvents: [Tracker] = []
        var newCategory: String = ""
        var newTrackers: [TrackerCategory] = []
        datePickerValueChanged(sender: datePicker)
        let searchingTrackers = localTrackers
        localTrackers = []
        var isGood = false
        for tracker in searchingTrackers {
            newCategory = tracker.label
            for event in tracker.trackers {
                if event.name.hasPrefix(searchText) {
                    newEvents.append(event)
                    isGood = true
                }
            }
            
            if isGood {
                newTrackers.append(TrackerCategory(label: newCategory, trackers: newEvents))
                newEvents = []
                isGood = false
                newCategory = ""
            }
        }
        localTrackers = newTrackers
        trackersCollection.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension TrackersViewController: TrackersViewControllerProtocol {
    
    func saveDoneEvent(id: UUID, index: IndexPath) {
        let tracker = localTrackers[index.section].trackers[index.row]
        let dateString = makeDate(from: currentDate, format: "yyyy/MM/dd")
        let record = TrackerRecord(id: id, date: dateString)
        
        if completedTrackers.contains(record) {
            completedTrackers.remove(record)
            print("Трекер \(tracker.name) удален из списка выполненных на дату \(dateString)")
        } else {
            completedTrackers.insert(record)
            print("Трекер \(tracker.name) добавлен в список выполненных на дату \(dateString)")
        }
        saveCompletedTrackers()
        updateTrackerCell(at: index)
        trackersCollection.reloadItems(at: [index])
        print("Коллекция обновлена после сохранения выполнения трекера")
    }
}

extension TrackersViewController {
    
    private func makeDate(dateFormat: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = dateFormat
        if dateFormat == "EEEE" {
            choosenDay = dateFormatter.string(from: currentDate)
        } else if dateFormat == "yyyy/MM/dd" {
            dateString = dateFormatter.string(from: currentDate)
        }
    }
}
