import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol PrivateCompletePresenter {
    var view: PrivateCompletePresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    
    func fetch(from queryRef: FirebaseQueryRef, completion: (() -> Void)?)
    func update(to documentRef: FirebaseDocumentRef, value: [String: Any])
    func get(documentRef: FirebaseDocumentRef)
    func create(documentRef: FirebaseDocumentRef, value: [String: Any])
    func delete(documentRef: FirebaseDocumentRef)
    func setSelected(index: Int)
    func getSelected(completion: @escaping (Int) -> Void)
}

protocol PrivateCompletePresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: TimelineContentUI,
                presenter: PrivateCompletePresenter,
                routing: PrivateCompleteRouting,
                disposeBag: DisposeBag)
    func didFetchGoalData(timeline: [Timeline])
    func didSelect(indexPath: IndexPath, tableView: UITableView)
    func didCheckIfYouLiked(_ bool: Bool)
    func didCreateLikeRef()
    func didDeleteLikeRef()
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}