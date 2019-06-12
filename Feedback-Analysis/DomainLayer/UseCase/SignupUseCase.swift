import Foundation
import RxSwift

protocol SignupUseCase {
    func signup(email: String, pass: String) -> Single<Account>}

struct SignupUseCaseImpl: SignupUseCase {
    
    private(set) var repository: AccountRepository
    
    init(repository: AccountRepository) {
        self.repository = repository
    }
    
    func signup(email: String, pass: String) -> Single<Account> {
        return repository
                .signup(email: email, pass: pass)
                .map { AccountTranslator().translate($0) }
    }
}
