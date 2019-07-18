import Foundation
import RxSwift

protocol GoalLocalDataStore {
    func setSelected(index: Int) -> Single<()>
    func getSelected() -> Single<Int>
    func getAuthorToken() -> Single<String>
    func setAuthorTokens(_ values: [String]) -> Single<()>
    func getAuthorToken() -> Single<[String]>
}

struct GoalLocalDataStoreImpl: GoalLocalDataStore {
    
    func setSelected(index: Int) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            AppUserDefaults.setSelected(index: index)
            single(.success(()))
            return Disposables.create()
        })
    }
    
    func getSelected() -> Single<Int> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getSelected()))
            return Disposables.create()
        })
    }
    
    func getAuthorToken() -> Single<String> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getAuthToken()))
            return Disposables.create()
        })
    }
    
    func setAuthorTokens(_ values: [String]) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.setStringArray(authorTokens: values)))
            return Disposables.create()
        })
    }
    
    func getAuthorToken() -> Single<[String]> {
        return Single.create(subscribe: { single -> Disposable in
            single(.success(AppUserDefaults.getStringArray()))
            return Disposables.create()
        })
    }
}
