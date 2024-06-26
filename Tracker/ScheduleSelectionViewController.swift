import UIKit

final class ScheduleSelectionViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scheduleTable: UITableView = {
        let table = UITableView()
        table.register(ScheduleCell.self, forCellReuseIdentifier: "schedule")
        table.isScrollEnabled = true
        table.separatorStyle = .singleLine
        table.layer.cornerRadius = 16
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        scheduleTable.dataSource = self
        scheduleTable.delegate = self
        view.addSubview(titleLabel)
        view.addSubview(scheduleTable)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            scheduleTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            scheduleTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scheduleTable.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -20),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func doneButtonTapped() {
        dismiss(animated: true)
    }
}

extension ScheduleSelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schedule", for: indexPath)
        guard let scheduleCell = cell as? ScheduleCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        scheduleCell.title.text = daysOfWeek[indexPath.section].rawValue
        return scheduleCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
}

extension ScheduleSelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: 0) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
        }
    }
}
