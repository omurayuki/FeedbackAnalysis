import Foundation

enum AccountValidation {
    case ok(String, String?, String?)
    case notAccurateChar(String)
    case mailNotEnough(String)
    case passNotEnough(String)
    case mailExceeded(String)
    case passExceeded(String)
    
    static func validateAccount(email: String, pass: String? = nil, rePass: String? = nil) -> AccountValidation {
        guard email.count > 1 else { return .mailNotEnough("メールアドレスを記入してください") }
        guard email.count < 50 else { return .mailExceeded("メールアドレスが長すぎます") }
        if let pass = pass {
            guard pass.count > 5 else { return .passNotEnough("パスワードが短すぎます") }
            guard pass.count < 50 else { return .passExceeded("パスワードが長すぎます") }
        }
        if let rePass = rePass {
            guard rePass.count > 5 else { return .passNotEnough("パスワードが短すぎます") }
            guard rePass.count < 50 else { return .passExceeded("パスワードが長すぎます") }
        }
        guard NSPredicate(format: "SELF MATCHES %@", "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$")
            .evaluate(with: email) else { return .notAccurateChar("emailの形式が間違っています") }
        return .ok(email, pass, rePass)
    }
}

enum UserValidation {
    case ok(String, String, String, String)
    case empty(String)
    case nameExceeded(String)
    case contentExceeded(String)
    
    static func validateUser(name: String, content: String,
                             residence: String, birth: String) -> UserValidation {
        guard name.count > 1 || content.count > 1 || residence.count > 1 || birth.count > 1 else { return .empty("空白を埋めてください") }
        guard name.count < 15 else { return .nameExceeded("名前が長すぎます") }
        guard content.count < 140 else { return .contentExceeded("自己紹介が長すぎます") }
        return .ok(name, content, residence, birth)
    }
}

enum GoalPostValidation {
    case ok(Array<String>, String?, String?, String?, String?)
    case empty(String)
    case exceeded(String)
    
    static func validate(genre: [String], newThings: String? = nil,
                         expectedResult1: String? = nil, expectedResult2: String? = nil,
                         expectedResult3: String? = nil) -> GoalPostValidation {
        guard genre.count >= 1 else { return .empty("ジャンルを一つ以上選択してください") }
        guard genre.count <= 4 else { return .exceeded("ジャンル選択数は最大3つまでです") }
        if let newThings = newThings, let expectedResult1 = expectedResult1, let expectedResult2 = expectedResult2, let expectedResult3 = expectedResult3 {
            guard newThings.count > 1 && expectedResult1.count > 1 && expectedResult2.count > 1 && expectedResult3.count > 1 else { return .empty("空白を埋めてください") }
            guard newThings.count <= 25 else { return .exceeded("25文字以下で入力してください") }
            guard expectedResult1.count <= 25 else { return .exceeded("25文字以下で入力してください") }
            guard expectedResult2.count <= 25 else { return .exceeded("25文字以下で入力してください") }
            guard expectedResult3.count <= 25 else { return .exceeded("25文字以下で入力してください") }
        }
        return .ok(genre, newThings, expectedResult1, expectedResult2, expectedResult3)
    }
}
