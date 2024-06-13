import UIKit

final class TabBarController: UITabBarController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .white
        let trackers = TrackersViewController()
        trackers.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(systemName: "record.circle.fill"), tag: 0)
        let statistics = StatisticsViewController()
        statistics.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(systemName: "hare.fill"), tag: 1)
        viewControllers = [trackers, statistics]
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        tabBar.layer.shadowOffset = .init(width: 0, height: -0.5)
        tabBar.layer.masksToBounds = false
    }
}
