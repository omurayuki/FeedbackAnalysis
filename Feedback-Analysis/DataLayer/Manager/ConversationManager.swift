import Foundation
import FirebaseFirestore

struct ConversationManager {
    
    func fetchConversationEntities(queryRef: FirebaseQueryRef,
                                   completion: @escaping (_ response: FirestoreResponse<[ConversationEntity]>) -> Void) {
        Provider().gets(queryRef: queryRef) { response in
            switch response {
            case .success(let entities):
                completion(.success(entities.compactMap { ConversationEntity(document: $0.data()) }))
            case .failure(let error):
                completion(.failure(error))
            case .unknown:
                completion(.unknown)
            }
        }
    }
    
    func create(documentRef: FirebaseDocumentRef, conversation: Conversation,
                completion: ((_ response: FirestoreResponse<()>) -> Void)? = nil) {
        Provider().setData(documentRef: documentRef, fields: ["id": conversation.id, "isRead": conversation.isRead, "lastMessage": conversation.lastMessage ?? "", "timestamp": conversation.timestamp, "userIDs": conversation.userIDs]) { response in
            guard let completion = completion else { return }
            switch response {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            case .unknown:
                completion(.unknown)
            }
        }
    }
}
