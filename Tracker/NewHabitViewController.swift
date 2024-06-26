import UIKit

final class NewHabitViewController: UIViewController, CategorySelectionDelegate {
    
    var categories: [TrackerCategory] = []
    var selectedCategory: TrackerCategory?
    var isRegular: Bool = true
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let enterNameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Введите название трекера"
        field.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        field.layer.cornerRadius = 16
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 65).isActive = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: field.frame.height))
        field.leftView = paddingView
        field.leftViewMode = .always
        return field
    }()
    
    let categoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Категория", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        button.layer.cornerRadius = 16
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrow.tintColor = .lightGray
        arrow.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(arrow)
        NSLayoutConstraint.activate([
            arrow.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            arrow.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16)
        ])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 65).isActive = true
        button.addTarget(nil, action: #selector(categoryTapped), for: .touchUpInside)
        return button
    }()
    
    let scheduleButton: UIButton = {
        let button = UIButton()
        button.setTitle("Расписание", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        button.layer.cornerRadius = 16
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrow.tintColor = .lightGray
        arrow.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(arrow)
        NSLayoutConstraint.activate([
            arrow.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            arrow.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16)
        ])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 65).isActive = true
        button.addTarget(nil, action: #selector(scheduleTapped), for: .touchUpInside)
        return button
    }()
    
    let firstStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let colorCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(ColorCell.self, forCellWithReuseIdentifier: "colorCell")
        collection.register(CollectionHeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        return collection
    }()
    
    let emojiCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(EmojiCell.self, forCellWithReuseIdentifier: "emojiCell")
        collection.register(CollectionHeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        return collection
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1), for: .normal)
        button.layer.borderColor = UIColor(red: 0.961, green: 0.42, blue: 0.424, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    
    let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(create), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    let secondStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.indicatorStyle = .white
        return scroll
    }()
    
    let categoriesTable: UITableView = {
        let table = UITableView()
        table.register(HabitCategoryCell.self, forCellReuseIdentifier: "category")
        table.isScrollEnabled = false
        table.separatorStyle = .singleLine
        table.layer.cornerRadius = 16
        table.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProperties()
        setupView()
    }
    
    private func setupView() {
        titleLabel.text = isRegular ? "Новая привычка" : "Новое нерегулярное событие"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            firstStack.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 24),
            firstStack.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            firstStack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            
            emojiCollection.topAnchor.constraint(equalTo: firstStack.bottomAnchor, constant: 24),
            emojiCollection.heightAnchor.constraint(equalToConstant: 200),
            emojiCollection.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            emojiCollection.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            emojiCollection.widthAnchor.constraint(equalTo: firstStack.widthAnchor),
            
            colorCollection.topAnchor.constraint(equalTo: emojiCollection.bottomAnchor),
            colorCollection.heightAnchor.constraint(equalToConstant: 200),
            colorCollection.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            colorCollection.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            colorCollection.widthAnchor.constraint(equalTo: firstStack.widthAnchor),
            
            secondStack.heightAnchor.constraint(equalToConstant: 60),
            secondStack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 28),
            secondStack.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            secondStack.topAnchor.constraint(equalTo: colorCollection.bottomAnchor, constant: 24),
        ])
        
        if isRegular {
            firstStack.addArrangedSubview(scheduleButton)
        }
    }
    
    private func setupProperties() {
        categoryName = ""
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeFirstCell), name: Notification.Name("category_changed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeSchedule), name: Notification.Name("schedule_changed"), object: nil)
        
        view.backgroundColor = .white
        
        firstStack.addArrangedSubview(enterNameTextField)
        firstStack.addArrangedSubview(categoryButton)
        if isRegular {
            firstStack.addArrangedSubview(scheduleButton)
        }
        
        secondStack.addArrangedSubview(cancelButton)
        secondStack.addArrangedSubview(createButton)
        
        scroll.addSubview(firstStack)
        scroll.addSubview(emojiCollection)
        scroll.addSubview(colorCollection)
        scroll.addSubview(secondStack)
        scroll.addSubview(categoriesTable)
        
        view.addSubview(titleLabel)
        view.addSubview(scroll)
        view.addGestureRecognizer(tapGesture)
        
        scroll.contentSize = CGSize(width: view.frame.width, height: 779)
        
        categoriesTable.dataSource = self
        categoriesTable.delegate = self
        colorCollection.delegate = self
        colorCollection.dataSource = self
        emojiCollection.delegate = self
        emojiCollection.dataSource = self
        enterNameTextField.delegate = self
    }
    
    private func activateButton() {
        if enterNameTextField.hasText && !categoryName.isEmpty && (!isRegular || !selectedDays.isEmpty) && !(emojiCollection.indexPathsForSelectedItems?.isEmpty ?? false) && !(colorCollection.indexPathsForSelectedItems?.isEmpty ?? false) {
            createButton.backgroundColor = .black
            createButton.isEnabled = true
        }
    }
    
    internal func categorySelected(_ category: TrackerCategory) {
        selectedCategory = category
        categoryName = category.label
        print("Выбрана категория: \(category.label)")
        changeFirstCell()
        activateButton()
    }
    
    private func saveCategories(categories: [TrackerCategory]) {
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: "categories")
            print("Категории успешно сохранены")
        } else {
            print("Ошибка при сохранении категорий")
        }
    }
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
    
    @objc private func create() {
        guard let name = enterNameTextField.text, !name.isEmpty else { return }
        guard !categoryName.isEmpty else { return }
        
        let emojiIndex = emojiCollection.indexPathsForSelectedItems?.first
        guard let emoji = emojiCollectionData[emojiIndex?.row ?? 0] as? String else { return }
        
        let colorIndex = colorCollection.indexPathsForSelectedItems?.first
        guard let color = colorCollectionData[colorIndex?.row ?? 0] as? UIColor else { return }
        
        let day = selectedDays
        let event = Tracker(id: UUID(), name: name, color: color, emoji: emoji, day: day.isEmpty ? nil : day)
        
        if var category = trackers.first(where: { $0.label == categoryName }) {
            category.trackers.append(event)
            if let index = trackers.firstIndex(where: { $0.label == categoryName }) {
                trackers[index] = category
            }
        } else {
            let newCategory = TrackerCategory(label: categoryName, trackers: [event])
            trackers.append(newCategory)
        }
        
        saveCategories(categories: trackers)
        
        let notification = Notification(name: Notification.Name("addEvent"))
        NotificationCenter.default.post(notification)
        
        categoryName = ""
        selectedDays = []
        shortSelectedDays = []
        print("Создание трекера завершено: \(event)")
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func changeFirstCell() {
        let cell = categoriesTable.cellForRow(at: [0,0]) as? HabitCategoryCell
        cell?.title.removeFromSuperview()
        cell?.addSubview(cell!.title)
        cell?.categoryName.text = categoryName
        cell?.categoryName.topAnchor.constraint(equalTo: cell!.title.bottomAnchor, constant: 2).isActive = true
        cell?.categoryName.leadingAnchor.constraint(equalTo: cell!.leadingAnchor, constant: 16).isActive = true
        cell?.title.leadingAnchor.constraint(equalTo: cell!.leadingAnchor, constant: 16).isActive = true
        cell?.title.topAnchor.constraint(equalTo: cell!.topAnchor, constant: 15).isActive = true
        activateButton()
    }
    
    @objc private func changeSchedule() {
        let cell = categoriesTable.cellForRow(at: [0,1]) as? HabitCategoryCell
        cell?.title.removeFromSuperview()
        cell?.addSubview(cell!.title)
        cell?.categoryName.text = shortSelectedDays.joined(separator: ", ")
        cell?.categoryName.topAnchor.constraint(equalTo: cell!.title.bottomAnchor, constant: 2).isActive = true
        cell?.categoryName.leadingAnchor.constraint(equalTo: cell!.leadingAnchor, constant: 16).isActive = true
        cell?.title.leadingAnchor.constraint(equalTo: cell!.leadingAnchor, constant: 16).isActive = true
        cell?.title.topAnchor.constraint(equalTo: cell!.topAnchor, constant: 15).isActive = true
        activateButton()
    }
    
    @objc private func categoryTapped() {
        let choiceOfCategoryViewController = CategorySelectionViewController()
        choiceOfCategoryViewController.delegate = self
        choiceOfCategoryViewController.categories = self.categories
        show(choiceOfCategoryViewController, sender: self)
    }
    
    @objc private func scheduleTapped() {
        let scheduleViewController = ScheduleSelectionViewController()
        show(scheduleViewController, sender: self)
    }
    
    @objc func dismissKeyboard() {
        enterNameTextField.resignFirstResponder()
    }
}

extension NewHabitViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.hasText {
            activateButton()
        }
        return true
    }
}

extension NewHabitViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isRegular ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath)
        guard let categoryCell = cell as? HabitCategoryCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            categoryCell.title.text = "Категория"
        case 1:
            categoryCell.title.text = "Расписание"
        default:
            break
        }
        return categoryCell
    }
}

extension NewHabitViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let choiceOfCategoryViewController = CategorySelectionViewController()
            choiceOfCategoryViewController.delegate = self
            choiceOfCategoryViewController.categories = self.categories
            show(choiceOfCategoryViewController, sender: self)
        } else if isRegular {
            let scheduleViewController = ScheduleSelectionViewController()
            show(scheduleViewController, sender: self)
        }
    }
}

extension NewHabitViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorCollection {
            return colorCollectionData.count
        } else {
            return emojiCollectionData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == colorCollection {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCell else {
                return UICollectionViewCell()
            }
            cell.color.backgroundColor = colorCollectionData[indexPath.row]
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as? EmojiCell else {
                return UICollectionViewCell()
            }
            cell.emojiLabel.text = emojiCollectionData[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == colorCollection {
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? CollectionHeaderSupplementaryView {
                header.title.text = "Цвет"
                return header
            } else {
                assertionFailure("Unable to dequeue CollectionHeaderSupplementaryView")
            }
        } else {
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? CollectionHeaderSupplementaryView {
                header.title.text = "Emoji"
                return header
            } else {
                fatalError("Unable to dequeue CollectionHeaderSupplementaryView")
            }
        }
        return UICollectionReusableView()
    }
}

extension NewHabitViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.bounds.width-56) / 6, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
}

extension NewHabitViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorCollection {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCell
            cell?.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 1)
            cell?.layer.cornerRadius = 16
            cell?.layer.masksToBounds = true
            activateButton()
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell
            cell?.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 1)
            cell?.layer.cornerRadius = 16
            cell?.layer.masksToBounds = true
            activateButton()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == colorCollection {
            let cell = collectionView.cellForItem(at: indexPath) as? ColorCell
            cell?.backgroundColor = UIColor.clear
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell
            cell?.backgroundColor = UIColor.clear
        }
    }
}
