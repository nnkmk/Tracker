import UIKit

protocol TrackersViewControllerProtocol {
    func saveDoneEvent(id: UUID, index: IndexPath)
    var localTrackers: [TrackerCategory] {get set }
}
