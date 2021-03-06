import Foundation
import RxSwift

protocol OtherPersonPageRepository {
    func fetch(to documentRef: FirebaseDocumentRef) -> Single<UserEntity>
    func getAuthorToken() -> Single<String>
    func follow(documentRef: FirebaseDocumentRef) -> Single<()>
    func unFollow(documentRef: FirebaseDocumentRef) -> Single<()>
    func checkFollowing(documentRef: FirebaseDocumentRef) -> Single<Bool>
    func setObjectToken(_ token: String) -> Single<()>
    func getBothToken() -> Single<(String, String)>
    func getConversations(queryRef: FirebaseQueryRef) -> Single<[ConversationEntity]>
    func setConversation(_ conversation: Conversation) -> Single<()>
    func getConversation() -> Single<Conversation>
}

struct OtherPersonPageRepositoryImpl: OtherPersonPageRepository {
    
    static let shared = OtherPersonPageRepositoryImpl()
    
    func fetch(to documentRef: FirebaseDocumentRef) -> Single<UserEntity> {
        let dataStore = UserDataStoreFactory.createUserRemoteDataStore()
        return dataStore.fetch(to: documentRef)
    }
    
    func getAuthorToken() -> Single<String> {
        let dataStore = UserDataStoreFactory.createUserLocalDataStore()
        return dataStore.getAuthorToken()
    }
    
    func follow(documentRef: FirebaseDocumentRef) -> Single<()> {
        let dataStore = UserDataStoreFactory.createUserRemoteDataStore()
        return dataStore.follow(documentRef: documentRef)
    }
    
    func unFollow(documentRef: FirebaseDocumentRef) -> Single<()> {
        let dataStore = UserDataStoreFactory.createUserRemoteDataStore()
        return dataStore.unFollow(documentRef: documentRef)
    }
    
    func checkFollowing(documentRef: FirebaseDocumentRef) -> Single<Bool> {
        let dataStore = UserDataStoreFactory.createUserRemoteDataStore()
        return dataStore.checkFollowing(documentRef: documentRef)
    }
    
    func setObjectToken(_ token: String) -> Single<()> {
        let dataStore = UserDataStoreFactory.createUserLocalDataStore()
        return dataStore.setObjectToken(token)
    }
    
    func getBothToken() -> Single<(String, String)> {
        let dataStore = UserDataStoreFactory.createUserLocalDataStore()
        return dataStore.getBothToken()
    }
    
    func getConversations(queryRef: FirebaseQueryRef) -> Single<[ConversationEntity]> {
        let dataStore = UserDataStoreFactory.createUserRemoteDataStore()
        return dataStore.getConversations(queryRef: queryRef)
    }
    
    func setConversation(_ conversation: Conversation) -> Single<()> {
        let dataStore = UserDataStoreFactory.createUserLocalDataStore()
        return dataStore.setConversation(conversation)
    }
    
    func getConversation() -> Single<Conversation> {
        let dataStore = UserDataStoreFactory.createUserLocalDataStore()
        return dataStore.getConversation()
    }
}
