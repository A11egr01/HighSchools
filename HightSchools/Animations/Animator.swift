
import UIKit

final class Animator {
	private var hasAnimatedAllCells = false
	private let animation: Animation

	init(animation: @escaping Animation) {
		self.animation = animation
	}

    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        guard !hasAnimatedAllCells else {
            return
        }

        animation(cell, indexPath, tableView)

        if let lastVisibleIndexPath = tableView.indexPathsForVisibleRows?.last, lastVisibleIndexPath == indexPath {
            hasAnimatedAllCells = true
        }    }
}
