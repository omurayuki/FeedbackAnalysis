import Foundation
import UIKit
import RxSwift
import RxCocoa

final class TimelineViewController: UIViewController {
    
    typealias DataSource = PageViewDataSource<UIViewController>
    
    private(set) lazy var dataSource: DataSource = {
        return DataSource(controllers: self.viewControllers)
    }()
    
    var ui: TimelineUI!
    
    var routing: TimelineRouting!
    
    var viewControllers: [UIViewController]!
    
    var presenter: TimelinePresenter! {
        didSet {
            presenter.view = self
        }
    }
    
    var disposeBag: DisposeBag! {
        didSet {}
    }
    
    func inject(ui: TimelineUI,
                presenter: TimelinePresenter,
                routing: TimelineRouting,
                viewControllers: [UIViewController],
                disposeBag: DisposeBag) {
        self.ui = ui
        self.presenter = presenter
        self.routing = routing
        self.viewControllers = viewControllers
        self.disposeBag = disposeBag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
        ui.timelinePages.setViewControllers([viewControllers.first!], direction: .forward, animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let index = presenter.currentStateIndex {
            ui.timelineSegmented.setIndex(index: index)
        }
    }
}

extension TimelineViewController: TimelinePresenterView {
    
    func didSelectSegment(with index: Int) {
        if presenter.previousIndex < index {
            ui.timelinePages.setViewControllers([viewControllers[index]], direction: .forward, animated: true, completion: nil)
        } else {
            ui.timelinePages.setViewControllers([viewControllers[index]], direction: .reverse, animated: true, completion: nil)
        }
        presenter.previousIndex = index
        presenter.currentStateIndex = index
    }
    
    func willTransitionTo(_ pageViewController: UIPageViewController, pendingViewControllers: [UIViewController]) {
        presenter.pendingIndex = viewControllers.firstIndex(of: pendingViewControllers.first!)
    }
    
    func didFinishAnimating(_ pageViewController: UIPageViewController, finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        presenter.currentIndex = presenter.pendingIndex
        presenter.currentStateIndex = presenter.pendingIndex
        if let index = presenter.currentIndex {
            ui.timelineSegmented.setIndex(index: index)
        }
    }
}
