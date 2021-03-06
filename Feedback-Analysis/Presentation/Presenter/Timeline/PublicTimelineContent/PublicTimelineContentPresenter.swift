import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol PublicTimelineContentPresenter {
    var view: PublicTimelineContentPresenterView! { get set }
    var isLoading: BehaviorRelay<Bool> { get }
    var isFirstLoading: Bool { get set }
    
    func fetch(from queryRef: FirebaseQueryRef, loading: Bool, completion: (() -> Void)?)
    func update(to documentRef: FirebaseDocumentRef, value: [String: Any])
    func get(documentRef: FirebaseDocumentRef)
    func create(documentRef: FirebaseDocumentRef, value: [String: Any])
    func delete(documentRef: FirebaseDocumentRef)
    func setSelected(index: Int)
    func getSelected(completion: @escaping (Int) -> Void)
    func getAuthorToken(completion: @escaping (String) -> Void)
    func setAuthorTokens(_ values: [String])
    func getAuthorToken(_ index: Int, completion: @escaping (String) -> Void)
}

protocol PublicTimelineContentPresenterView: class {
    var disposeBag: DisposeBag! { get }
    
    func inject(ui: PublicTimelineContentUI,
                presenter: PublicTimelineContentPresenter,
                routing: PublicTimelineContentRouting,
                disposeBag: DisposeBag)
    func didFetchGoalData(timeline: [Timeline])
    func didSelect(indexPath: IndexPath, tableView: UITableView)
    func didCheckIfYouLiked(_ bool: Bool)
    func didCreateLikeRef()
    func didDeleteLikeRef()
    func showError(message: String)
    func updateLoading(_ isLoading: Bool)
}
