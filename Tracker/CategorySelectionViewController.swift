import UIKit

protocol CategorySelectionDelegate: AnyObject {
    func categorySelected(_ category: TrackerCategory)
}

final class CategorySelectionViewController: UIViewController {
    
    var categories: [TrackerCategory] = []
    weak var delegate: CategorySelectionDelegate?
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 8.0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let categoriesTable: UITableView = {
        let table = UITableView()
        table.register(CategoryCell.self, forCellReuseIdentifier: "category")
        table.isScrollEnabled = true
        table.separatorStyle = .singleLine
        table.translatesAutoresizingMaskIntoConstraints = false
        table.layer.cornerRadius = 16
        table.allowsMultipleSelection = false
        return table
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let starImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "star"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let questionLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Привычки и события можно
        объединить по смыслу
        """
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addCategoryTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = loadCategories()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(addCategoryButton)
        view.addSubview(categoriesTable)
        
        categoriesTable.dataSource = self
        categoriesTable.delegate = self
        
        stackView.addArrangedSubview(starImage)
        stackView.addArrangedSubview(questionLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            categoriesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            categoriesTable.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -16),
            
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        if categories.isEmpty {
            stackView.isHidden = false
        } else {
            stackView.isHidden = true
        }
    }
    
    private func saveNewCategory(name: String) {
        let newCategory = TrackerCategory(label: name, trackers: [])
        categories.append(newCategory)
        saveCategories()
        categoriesTable.reloadData()
    }
    
    private func saveCategories() {
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: "categories")
            print("Категории успешно сохранены")
        } else {
            print("Ошибка при сохранении категорий")
        }
    }
    
    private func loadCategories() -> [TrackerCategory] {
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
        return []
    }
    
    @objc private func addCategoryTapped() {
        let alertController = UIAlertController(title: "Новая категория", message: "Введите название категории", preferredStyle: .alert)
        alertController.addTextField()
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let categoryName = alertController.textFields?.first?.text, !categoryName.isEmpty {
                self.saveNewCategory(name: categoryName)
            }
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension CategorySelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath)
        guard let categoryCell = cell as? CategoryCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        categoryCell.title.text = categories[indexPath.row].label
        return categoryCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            if let parentVC = self.presentingViewController as? TrackersViewController {
                parentVC.categories = self.categories
                parentVC.trackersCollection.reloadData()
            }
        }
    }
}

extension CategorySelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row]
        delegate?.categorySelected(selectedCategory)
        print("Выбрана категория: \(selectedCategory.label)")
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? CategoryCell
        cell?.checkbox.image = UIImage()
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
}
