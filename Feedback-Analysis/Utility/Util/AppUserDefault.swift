import Foundation

class AppUserDefaults {
    
    // Email
    class func getAccountEmail() -> String {
        return getStringValue(keyName: "AccountEmail")
    }
    
    class func setAccountEmail(email: String) {
        putStringValue(email, keyName: "AccountEmail")
    }
    
    // AuthToken
    class func getAuthToken() -> String {
        return getStringValue(keyName: "AuthToken")
    }
    
    class func setAuthToken(token: String) {
        putStringValue(token, keyName: "AuthToken")
    }
    
    // AuthObjectToken (他人のページに訪れた時)
    class func getObjectToken() -> String {
        return getStringValue(keyName: "AuthObjectToken")
    }
    
    class func setObjectToken(token: String) {
        putStringValue(token, keyName: "AuthObjectToken")
    }
    
    // OtherPersonAuthFromTimelineToken
    class func getOtherPersonAuthFromTimelineToken() -> String {
        return getStringValue(keyName: "OtherPersonAuthFromTimelineToken")
    }
    
    class func setOtherPersonAuthFromTimelineToken(token: String) {
        putStringValue(token, keyName: "OtherPersonAuthFromTimelineToken")
    }
    
    // OtherPersonAuthFromCommentToken
    class func getOtherPersonAuthFromCommentToken() -> String {
        return getStringValue(keyName: "OtherPersonAuthFromCommentToken")
    }
    
    class func setOtherPersonAuthFromCommentToken(token: String) {
        putStringValue(token, keyName: "OtherPersonAuthFromCommentToken")
    }
    
    // 初回起動フラグ
    class func getFirstLaunchFrag() -> Bool {
        return getBoolValue(keyName: "FirstLaunch")
    }
    
    class func setFirstLaunchFrag() {
        putBoolValue(true, keyName: "FirstLaunch")
    }
    
    // goalDocumentId
    class func getGoalDocument() -> String {
        return getStringValue(keyName: "goalDocument")
    }
    
    class func setGoalDocument(id: String) {
        putStringValue(id, keyName: "goalDocument")
    }
    
    // commentDocumentId
    class func getCommentDocument() -> String {
        return getStringValue(keyName: "commentDocument")
    }
    
    class func setCommentDocument(id: String) {
        putStringValue(id, keyName: "commentDocument")
    }
    
    // selectedIndex
    class func getSelected() -> Int {
        return getIntValue(keyName: "index")
    }
    
    class func setSelected(index: Int) {
        putIntValue(index, keyName: "index")
    }
    
    // structData
    class func getUser() -> [UserEntity] {
        return getStructValue(keyName: "user")
    }
    
    class func setUser(user: [User]) {
        putStructValue(user, keyName: "user")
    }
    
    // arrayValue(Goals: authorTokens)
    class func getGoalsAuthorTokens() -> [String] {
        return getArrayValue(keyName: "GoalsAuthorTokens")
    }
    
    class func setGoalsAuthorTokens(authorTokens: [String]) {
        setArrayValue(authorTokens, keyName: "GoalsAuthorTokens")
    }
    
    // arrayValue(Complete: authorTokens)
    class func getCompleteAuthorTokens() -> [String] {
        return getArrayValue(keyName: "CompleteAuthorTokens")
    }
    
    class func setCompleteAuthorTokens(authorTokens: [String]) {
        setArrayValue(authorTokens, keyName: "CompleteAuthorTokens")
    }
    
    // arrayValue(Follow: authorTokens)
    class func getFollowAuthorTokens() -> [String] {
        return getArrayValue(keyName: "FollowAuthorTokens")
    }
    
    class func setFollowsAuthorTokens(authorTokens: [String]) {
        setArrayValue(authorTokens, keyName: "FollowAuthorTokens")
    }
    
    // arrayValue(followeeList: authorTokens)
    class func getFolloweeListAuthorTokens() -> [String] {
        return getArrayValue(keyName: "FolloweeListAuthorToken")
    }
    
    class func setFolloweeListAuthorTokens(authorTokens: [String]) {
        setArrayValue(authorTokens, keyName: "FolloweeListAuthorToken")
    }
    
    // arrayValue(followerList: authorTokens)
    class func getFollowerListAuthorTokens() -> [String] {
        return getArrayValue(keyName: "FollowerListAuthorToken")
    }
    
    class func setFollowerListAuthorTokens(authorTokens: [String]) {
        setArrayValue(authorTokens, keyName: "FollowerListAuthorToken")
    }
    
    class func clearStringArray() {
        clearArrayValue(keyName: "authorTokens")
    }
    
    // conversationInOnotherPerson
    class func getConversationInOnotherPerson() -> [Conversation] {
        return getStructValue(keyName: "conversationInOnotherPerson")
    }
    
    class func setConversationInOnotherPerson(conversation: [Conversation]) {
        putStructValue(conversation, keyName: "conversationInOnotherPerson")
    }
}

extension AppUserDefaults {
    
    private class func getStringValue(keyName: String) -> String {
        let userDefaults: UserDefaults = UserDefaults.standard
        return userDefaults.string(forKey: keyName) ?? ""
    }
    
    private class func putStringValue(_ value: String, keyName: String) {
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.setValue(value, forKey: keyName)
    }
    
    private class func getIntValue(keyName: String) -> Int {
        let userDefaults: UserDefaults = UserDefaults.standard
        return userDefaults.integer(forKey: keyName)
    }
    
    private class func putIntValue(_ value: Int, keyName: String) {
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: keyName)
    }
    
    private class func getBoolValue(keyName: String) -> Bool {
        let userDefaults: UserDefaults = UserDefaults.standard
        return userDefaults.bool(forKey: keyName)
    }
    
    private class func putBoolValue(_ value: Bool, keyName: String) {
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: keyName)
    }
    
    private class func getStructValue<T: Codable>(keyName: String) -> [T] {
        let userDefaults: UserDefaults = UserDefaults.standard
        guard let data = userDefaults.array(forKey: keyName) as? [Data] else { return [] }
        return data.map { try! JSONDecoder().decode(T.self, from: $0) }
    }
    
    private class func putStructValue<T: Codable>(_ value: [T], keyName: String) {
        let userDefaults: UserDefaults = UserDefaults.standard
        let data = value.map { try? JSONEncoder().encode($0) }
        userDefaults.set(data, forKey: keyName)
    }
    
    private class func getArrayValue<T>(keyName: String) -> [T] {
        let userDefaults: UserDefaults = UserDefaults.standard
        guard let data = userDefaults.array(forKey: keyName) as? [T] else { return [] }
        return data
    }
    
    private class func setArrayValue<T>(_ value: [T], keyName: String) {
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.set(value, forKey: keyName)
    }
    
    private class func clearArrayValue(keyName: String) {
        let userDefaults: UserDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: keyName)
    }
}
