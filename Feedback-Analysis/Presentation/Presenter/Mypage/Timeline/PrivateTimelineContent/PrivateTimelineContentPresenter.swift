import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol PrivateTimelineContentPresenter {
    var view: PrivateTimelineContentPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    
    func fetch(from queryRef: FirebaseQueryRef, authorToken: String, completion: (() -> Void)?)
    func update(to documentRef: FirebaseDocumentRef, value: [String: Any])
    func get(documentRef: FirebaseDocumentRef)
    func create(documentRef: FirebaseDocumentRef, value: [String: Any])
    func delete(documentRef: FirebaseDocumentRef)
    func setSelected(index: Int)
    func getSelected(completion: @escaping (Int) -> Void)
    func getAuthorToken(completion: @escaping (String) -> Void)
}

protocol PrivateTimelineContentPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: PrivateTimelineContentUI,
                presenter: PrivateTimelineContentPresenter,
                routing: PrivateTimelineContentRouting,
                disposeBag: DisposeBag)
    func didFetchGoalData(timeline: [Timeline])
    func didSelect(indexPath: IndexPath, tableView: UITableView)
    func didCheckIfYouLiked(_ bool: Bool)
    func didCreateLikeRef()
    func didDeleteLikeRef()
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
