import Foundation
import RxSwift
import RxCocoa
import GrowingTextView

class ReplyPresenterImpl: NSObject, ReplyPresenter {
    var view: ReplyPresenterView!
    var isLoading: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
    var keyboardNotifier: KeyboardNotifier! = KeyboardNotifier()
    
    private var useCase: DetailUseCase
    
    init(useCase: DetailUseCase) {
        self.useCase = useCase
        super.init()
        listenKeyboard(keyboardNotifier: keyboardNotifier)
    }
    
    func fetch() {
        view.updateLoading(true)
        useCase.fetch()
            .subscribe { result in
                switch result {
                case .success(let response):
                    self.view.updateLoading(false)
                    self.view.didFetchUser(data: response)
                case .error(let error):
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func post(to documentRef: FirebaseDocumentRef, reply: ReplyPost) {
        useCase.post(to: documentRef, reply: reply)
            .subscribe { [unowned self] result in
                switch result {
                case .success(_):
                    self.view.didPostSuccess()
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func get(from queryRef: FirebaseQueryRef, isLoading: Bool) {
        view.updateLoading(isLoading)
        useCase.get(replies: queryRef)
            .subscribe(onNext: { [unowned self] result in
                self.view.didFetchReplies(replies: result)
                }, onError: { error in
                    self.view.updateLoading(false)
                    self.view.showError(message: error.localizedDescription)
            }).disposed(by: view.disposeBag)
    }
    
    func set(comment id: String, completion: @escaping () -> Void) {
        useCase.set(comment: id)
            .subscribe { result in
                switch result {
                case .success(_):
                    completion()
                case .error(_):
                    break
                }
            }.disposed(by: view.disposeBag)
    }
    
    func set(otherPersonAuthorToken token: String) {
        useCase.set(otherPersonAuthorTokenFromComment: token)
            .subscribe { result in
                switch result {
                case .success(_):
                    return
                case .error(_):
                    break
                }
            }.disposed(by: view.disposeBag)
    }
    
    func getDocumentIds(completion: @escaping (_ documentId: String, _ commentId: String) -> Void) {
        useCase.getDocumentIds()
            .subscribe { result in
                switch result {
                case .success(let response):
                    completion(response.documentId, response.commentId)
                case .error(_):
                    return
                }
            }.disposed(by: view.disposeBag)
    }
    
    func getOtherPersonAuthorToken(completion: @escaping (String) -> Void) {
        useCase.getOtherPersonAuthorFromCommentToken()
            .subscribe { [unowned self] result in
                switch result {
                case .success(let response):
                    completion(response)
                case .error(let error):
                    self.view.showError(message: error.localizedDescription)
                }
            }.disposed(by: view.disposeBag)
    }
    
    func setAuthorTokens(_ values: [String]) {
        useCase.setGoalsAuthorTokens(values)
            .subscribe { result in
                switch result {
                case .success(_):
                    return
                case .error(_):
                    return
                }
            }.disposed(by: view.disposeBag)
    }
    
    func getAuthorToken(completion: @escaping (String) -> Void) {
        useCase.getAuthorToken()
            .subscribe { result in
                switch result {
                case .success(let response):
                    completion(response)
                case .error(_):
                    return
                }
            }.disposed(by: view.disposeBag)
    }
    
    func getAuthorToken(_ index: Int, completion: @escaping (String) -> Void) {
        useCase.getGoalsAuthorTokens(index)
            .subscribe { result in
                switch result {
                case .success(let response):
                    completion(response)
                case .error(_):
                    return
                }
            }.disposed(by: view.disposeBag)
    }
}

extension ReplyPresenterImpl: GrowingTextViewDelegate {
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.SpringAnimator(duration: 0.3, damping: 0.7, velocity: 0.7, options: [.curveLinear])
            .animations {
                self.view.didChangeTextHeight()
            }.animate()
    }
}
extension ReplyPresenterImpl: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.didSelect(tableView: tableView, indexPath: indexPath)
    }
}

extension ReplyPresenterImpl: KeyboardListener {
    
    func keyboardPresent(_ height: CGFloat) {
        view.keyboardPresent(height)
    }
    
    func keyboardDismiss(_ height: CGFloat) {
        view.keyboardDismiss(height)
    }
}
