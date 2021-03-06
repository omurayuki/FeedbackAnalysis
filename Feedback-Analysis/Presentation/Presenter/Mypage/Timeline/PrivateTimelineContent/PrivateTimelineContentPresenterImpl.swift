import Foundation
import RxSwift
import RxCocoa

class PrivateTimelineContentPresenterImpl: NSObject, PrivateTimelineContentPresenter {
    
    var view: PrivateTimelineContentPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private var useCase: GoalPostUseCase
    
    init(useCase: GoalPostUseCase) {
        self.useCase = useCase
    }
    
    func fetch(from queryRef: FirebaseQueryRef, authorToken: String, completion: (() -> Void)?) {
        useCase.fetch(from: queryRef, authorToken: authorToken)
            .subscribe(onNext: { [unowned self] result in
                self.view.didFetchGoalData(timeline: result)
            }, onError: { [unowned self] error in
                    self.view.showError(message: error.localizedDescription)
            }).disposed(by: view.disposeBag)
    }
    
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) {
        useCase.update(to: documentRef, value: value)
            .subscribe { [unowned self] result in
                switch result {
                case .success(_):
                    break
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func get(documentRef: FirebaseDocumentRef) {
        useCase.get(documentRef: documentRef)
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    self.view.didCheckIfYouLiked(response)
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) {
        useCase.create(documentRef: documentRef, value: value)
            .subscribe { [unowned self] result in
                switch result {
                case .success(_):
                    self.view.didCreateLikeRef()
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func delete(documentRef: FirebaseDocumentRef) {
        useCase.delete(documentRef: documentRef)
            .subscribe { [unowned self] result in
                switch result {
                case .success(_):
                    self.view.didDeleteLikeRef()
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setSelected(index: Int) {
        useCase.setSelected(index: index)
            .subscribe { result in
                switch result {
                case .success(_):
                    return
                case .error(_):
                    return
                }
            }.disposed(by: view.disposeBag)
    }
    
    func getSelected(completion: @escaping (Int) -> Void) {
        useCase.getSelected()
            .subscribe { result in
                switch result {
                case .success(let response):
                    completion(response)
                case .error(_):
                    return
                }
            }.disposed(by: view.disposeBag)
    }
    
    func getAuthorToken(completion: @escaping (String) -> Void) {
        useCase.getAuthorToken()
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    completion(response)
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
}

extension PrivateTimelineContentPresenterImpl: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.didSelect(indexPath: indexPath, tableView: tableView)
    }
}
