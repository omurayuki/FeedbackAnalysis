import Foundation
import RxSwift

protocol GoalPostUseCase {
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
    func update(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()>
    func fetch(from queryRef: FirebaseQueryRef, authorToken: String) -> Observable<[Timeline]>
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()>
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool>
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()>
    func delete(documentRef: FirebaseDocumentRef) -> Single<()>
    func setSelected(index: Int) -> Single<()>
    func getSelected() -> Single<Int>
    func getAuthorToken() -> Single<String>
    func getGoalDocumentId() -> Single<String>
    func setGoalDocumentId(_ value: String) -> Single<()>
}

struct GoalPostUseCaseImpl: GoalPostUseCase {
    
    private(set) var repository: GoalRepository
    
    init(repository: GoalRepository) {
        self.repository = repository
    }
    
    func post(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        return repository.post(to: documentRef, fields: fields)
    }
    
    func update(to documentRef: FirebaseDocumentRef, fields: GoalPost) -> Single<()> {
        return repository.update(to: documentRef, fields: fields)
    }
    
    func fetch(from queryRef: FirebaseQueryRef, authorToken: String) -> Observable<[Timeline]> {
        return repository.fetch(from: queryRef, authorToken: authorToken).map { GoalsTranslator().translate($0) }
    }
    
    func update(to documentRef: FirebaseDocumentRef, value: [String : Any]) -> Single<()> {
        return repository.update(to: documentRef, value: value)
    }
    
    func get(documentRef: FirebaseDocumentRef) -> Single<Bool> {
        return repository.get(documentRef: documentRef)
    }
    
    func create(documentRef: FirebaseDocumentRef, value: [String: Any]) -> Single<()> {
        return repository.create(documentRef: documentRef, value: value)
    }
    
    func delete(documentRef: FirebaseDocumentRef) -> Single<()> {
        return repository.delete(documentRef: documentRef)
    }
    
    func setSelected(index: Int) -> Single<()> {
        return repository.setSelected(index: index)
    }
    
    func getSelected() -> Single<Int> {
        return repository.getSelected()
    }
    
    func getAuthorToken() -> Single<String> {
        return repository.getAuthorToken()
    }
    
    func getGoalDocumentId() -> Single<String> {
        return repository.getGoalDocumentId()
    }
    
    func setGoalDocumentId(_ value: String) -> Single<()> {
        return repository.setGoalDocumentId(value)
    }
}
