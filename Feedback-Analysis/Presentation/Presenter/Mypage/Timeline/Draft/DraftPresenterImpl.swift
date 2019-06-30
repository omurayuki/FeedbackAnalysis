import Foundation
import RxSwift
import RxCocoa

class DraftPresenterImpl: NSObject, DraftPresenter {
    var view: DraftPresenterView!
    
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    
    private var useCase: GoalPostUseCase
    
    init(useCase: GoalPostUseCase) {
        self.useCase = useCase
    }
    
    func fetch(from queryRef: FirebaseQueryRef, completion: (() -> Void)?) {
        view.updateLoading(true)
        useCase.fetch(from: queryRef)
            .subscribe(onNext: { result in
                self.view.updateLoading(false)
                self.view.didFetchGoalData(timeline: result)
            }, onError: { error in
                self.view.updateLoading(false)
                self.view.showError(message: error.localizedDescription)
            }).disposed(by: view.disposeBag)
    }
}

extension DraftPresenterImpl: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.didSelect(indexPath: indexPath, tableView: tableView)
    }
}
