import Foundation
import FirebaseFirestore

struct MessageManager {
    
    func fetchMessageEntities(queryRef: FirebaseQueryRef,
                                   completion: @escaping (_ response: FirestoreResponse<[MessageEntity]>) -> Void) {
        Provider().observe(queryRef: queryRef) { response in
            switch response {
            case .success(let entities):
                completion(.success(entities.compactMap { value  -> MessageEntity in
                    return MessageEntity(document: value.data())
                }))
            case .failure(let error):
                completion(.failure(error))
            case .unknown:
                completion(.unknown)
            }
        }
    }
    
    func create(documentRef: FirebaseDocumentRef, message: Message, conversation: Conversation,
                completion: @escaping (_ response: FirestoreResponse<Conversation>) -> Void) {
        var conversation = conversation
        UploadImageManager().upload(message, reference: .messages) { response in
            switch response {
            case .success(let uploadedMessage):
                let data = ["id": uploadedMessage.id , "message": uploadedMessage.message ?? "", "content": uploadedMessage.content ?? "",
                            "contentType": uploadedMessage.contentType.rawValue, "created_at": uploadedMessage.time , "ownerID": uploadedMessage.ownerID ?? "",
                            "profilePickLink": uploadedMessage.profilePicLink ?? ""] as [String : Any]
                Provider().setData(documentRef: documentRef, fields: data, completion: { response in
                    switch response {
                    case .success(_):
                        return
                    case .failure(let error):
                        completion(.failure(error))
                    case .unknown:
                        completion(.unknown)
                    }
                })
                if let id = conversation.isRead.filter({ $0.key != AppUserDefaults.getAuthToken() }).first {
                    conversation.isRead[id.key] = false
                }
                ConversationManager().create(documentRef: .conversationRef(conversationID: conversation.id), conversation: conversation, completion: { response in
                    switch response {
                    case .success(_):
                        completion(.success(Conversation(conversation: conversation.encode())))
                    case .failure(let error):
                        completion(.failure(error))
                    case .unknown:
                        completion(.unknown)
                    }
                })
            case .failure(let error):
                completion(.failure(error))
            case .unknown:
                completion(.unknown)
            }
        }
    }
}
