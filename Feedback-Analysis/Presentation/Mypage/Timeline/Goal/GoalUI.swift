import UIKit

protocol GoalUI: UI {
    var timeline: UITableView { get set }
    func setup()
}

final class GoalUIImpl: GoalUI {
    
    var viewController: UIViewController?
    
    var timeline: UITableView = {
        let table = UITableView()
        table.backgroundColor = .appMainColor
        table.separatorColor = .appSubColor
        table.estimatedRowHeight = 400
        table.rowHeight = UITableView.automaticDimension
        table.register(TimelineCell.self, forCellReuseIdentifier: String(describing: TimelineCell.self))
        return table
    }()
}

extension GoalUIImpl {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        vc.clearNavBar()
        
        vc.view.addSubview(timeline)
        
        timeline.anchor()
            .edgesToSuperview()
            .activate()
    }
}
