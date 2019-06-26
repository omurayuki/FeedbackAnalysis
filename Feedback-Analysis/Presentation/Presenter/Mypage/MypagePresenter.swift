import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol MypagePresenter: Presenter {
    var view: MypagePresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    
    func fetch(to: FirebaseDocumentRef, completion: (() -> Void)?)
}

protocol MypagePresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: MypageUI,
                presenter: MypagePresenter,
                routing: MypageRouting,
                viewControllers: [UIViewController],
                disposeBag: DisposeBag)
    func didFetchUserData(user: User)
    func didSelectSegment(with index: Int)
    func willTransitionTo(_ pageViewController: UIPageViewController, pendingViewControllers: [UIViewController])
    func didFinishAnimating(_ pageViewController: UIPageViewController, finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
