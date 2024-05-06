import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trackersVC = TrackersViewController()
//        trackersVC.tabBarItem = UITabBarItem(title: "Трекеры", image: UIImage(named: "trackersTab"), tag: 0)

        let statisticsVC = StatisticsViewController ()
//        statisticsVC.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(named: "statisticsTab"), tag: 1)
        
        self.viewControllers = [trackersVC, statisticsVC]
    }
}
