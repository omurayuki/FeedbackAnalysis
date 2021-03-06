import UIKit

protocol EditUI: UI {
    var formatter: DateFormatter { get }
    var navBar: UINavigationBar { get }
    var navItem: UINavigationItem { get }
    var cancelBtn: UIBarButtonItem { get }
    var saveBtn: UIBarButtonItem { get }
    var headerImage: UIImageView { get }
    var gesture: UIGestureRecognizer { get }
    var userImage: UIImageView { get }
    var userImageEditBtn: UIButton { get }
    var name: UILabel { get }
    var nameField: PaddingTextField { get }
    var nameTextCount: UILabel { get }
    var content: UILabel { get }
    var contentField: UITextView { get }
    var contentTextCount: UILabel { get }
    var residence: UILabel { get }
    var residenceField: PaddingTextField { get }
    var residenceDoneBtn: UIBarButtonItem { get }
    var residenceToolBar: UIToolbar { get }
    var residencePickerView: UIPickerView { get }
    var birth: UILabel { get }
    var birthField: PaddingTextField { get }
    var datePicker: UIDatePicker { get }
    var viewTapGesture: UITapGestureRecognizer { get }
    
    func setup()
    func mapping(user: User)
    func setImage(image: UIImage?)
    func adjustForKeyboard(notification: Notification)
}

final class EditUIImpl: EditUI {
    
    weak var viewController: UIViewController?
    
    private(set) var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        return formatter
    }()
    
    private(set) var navBar: UINavigationBar = {
        let nav = UINavigationBar()
        nav.setBackgroundImage(UIImage(), for: .default)
        nav.shadowImage = UIImage()
        return nav
    }()
    
    private(set) var navItem: UINavigationItem = {
        let item = UINavigationItem()
        return item
    }()
    
    private(set) var cancelBtn: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "キャンセル", style: .plain, target: nil, action: nil)
        item.tintColor = .appSubColor
        return item
    }()
    
    private(set) var saveBtn: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "保存", style: .plain, target: nil, action: nil)
        item.tintColor = .appSubColor
        return item
    }()
    
    private(set) var headerImage: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.clipsToBounds = true
        image.image = #imageLiteral(resourceName: "twitter_header_photo_1")
        return image
    }()
    
    private(set) var headerImageEditView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.2)
        return view
    }()
    
    private(set) var gesture: UIGestureRecognizer = {
        let gesture = UIGestureRecognizer()
        return gesture
    }()
    
    private(set) var userImage: UIImageView = {
        let image = UIImageView.Builder()
            .cornerRadius(30)
            .borderWidth(2)
            .build()
        return image
    }()
    
    private(set) var userImageEditView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.2)
        return view
    }()
    
    private(set) var userImageEditBtn: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.backgroundColor = .clear
        button.setImage(#imageLiteral(resourceName: "add"), for: .normal)
        return button
    }()
    
    private(set) var name: UILabel = {
        let label = UILabel()
        label.apply(.h5_appSub_bold, title: "名前")
        return label
    }()
    
    private(set) var nameField: PaddingTextField = {
        let field = PaddingTextField()
        field.apply(.h5_appSub, hint: "名前を記入")
        field.textColor = .appSubColor
        field.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        field.layer.cornerRadius = 5
        return field
    }()
    
    private(set) var nameTextCount: UILabel = {
        let label = UILabel()
        label.apply(.appMain10)
        return label
    }()
    
    private(set) var content: UILabel = {
        let label = UILabel()
        label.apply(.h5_appSub_bold, title: "自己紹介")
        return label
    }()
    
    private(set) var contentField: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .appSubColor
        textView.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        textView.layer.cornerRadius = 5
        return textView
    }()
    
    private(set) var contentTextCount: UILabel = {
        let label = UILabel()
        label.apply(.appMain10)
        return label
    }()
    
    private(set) var residence: UILabel = {
        let label = UILabel()
        label.apply(.h5_appSub_bold, title: "居住")
        return label
    }()
    
    private(set) var residenceField: PaddingTextField = {
        let field = PaddingTextField()
        field.apply(.h5_appSub, hint: "居住地を記入")
        field.textColor = .appSubColor
        field.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        field.layer.cornerRadius = 5
        return field
    }()
    
    private(set) var residenceDoneBtn: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        return button
    }()
    
    private(set) var residenceToolBar: UIToolbar = {
        let toolbarFrame = CGRect(x: 0, y: 0, width: UIViewController().view.frame.width, height: 35)
        let accessoryToolbar = UIToolbar(frame: toolbarFrame)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        accessoryToolbar.items = [flexibleSpace]
        accessoryToolbar.barTintColor = .white
        return accessoryToolbar
    }()
    
    private(set) var residencePickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.backgroundColor = .white
        return pv
    }()
    
    private(set) var birth: UILabel = {
        let label = UILabel()
        label.apply(.h5_appSub_bold, title: "生年月日")
        return label
    }()
    
    private(set) var birthField: PaddingTextField = {
        let field = PaddingTextField()
        field.apply(.h5_appSub, hint: "生年月日を記入")
        field.textColor = .appSubColor
        field.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        field.layer.cornerRadius = 5
        return field
    }()
    
    private(set) var datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.timeZone = NSTimeZone.local
        dp.backgroundColor = .white
        dp.locale = .current
        return dp
    }()
    
    private(set) var viewTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        return gesture
    }()
    
    private(set) var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
}

extension EditUIImpl {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .appMainColor
        vc.view.addGestureRecognizer(viewTapGesture)
        
        navItem.leftBarButtonItem = cancelBtn
        navItem.rightBarButtonItem = saveBtn
        navBar.pushItem(navItem, animated: true)
        
        birthField.text = formatter.string(from: Date())
        birthField.inputView = datePicker
        
        residenceToolBar.items = [residenceDoneBtn]
        residenceField.inputView = residencePickerView
        residenceField.inputAccessoryView = residenceToolBar
        
        let nameStack = UIStackView.setupStack(lhs: name, rhs: nameField, spacing: 20)
        let residenceStack = UIStackView.setupStack(lhs: residence, rhs: residenceField, spacing: 20)
        let birthStack = UIStackView.setupStack(lhs: birth, rhs: birthField, spacing: 20)
        
        [navBar, headerImage, userImage, borderView, nameStack, nameTextCount,
         content, contentField, contentTextCount, residenceStack, birthStack].forEach { vc.view.addSubview($0) }
        headerImage.addSubview(headerImageEditView)
        headerImage.addGestureRecognizer(gesture)
        userImage.addSubview(userImageEditView)
        userImage.addSubview(userImageEditBtn)
        
        navBar.anchor()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor)
            .width(to: vc.view.widthAnchor)
            .activate()
        
        headerImage.anchor()
            .top(to: navBar.bottomAnchor)
            .width(to: vc.view.widthAnchor)
            .height(to: vc.view.heightAnchor, multiplier: 0.15)
            .activate()
        
        headerImageEditView.anchor()
            .edgesToSuperview()
            .activate()
        
        userImage.anchor()
            .top(to: headerImage.bottomAnchor, constant: -20)
            .left(to: vc.view.leftAnchor, constant: 20)
            .width(constant: 60)
            .height(constant: 60)
            .activate()
        
        userImageEditView.anchor()
            .edgesToSuperview()
            .activate()
        
        userImageEditBtn.anchor()
            .width(constant: 30)
            .height(constant: 30)
            .centerXToSuperview()
            .centerYToSuperview()
            .activate()
        
        borderView.anchor()
            .top(to: userImage.bottomAnchor, constant: 20)
            .width(to: vc.view.widthAnchor)
            .height(constant: 0.2)
            .activate()
        
        name.anchor()
            .width(to: vc.view.widthAnchor, multiplier: 0.18)
            .activate()
        
        residence.anchor()
            .width(to: vc.view.widthAnchor, multiplier: 0.18)
            .activate()
        
        birth.anchor()
            .width(to: vc.view.widthAnchor, multiplier: 0.18)
            .activate()
        
        nameField.anchor()
            .height(constant: 35)
            .activate()
        
        residenceField.anchor()
            .height(constant: 35)
            .activate()
        
        birthField.anchor()
            .height(constant: 35)
            .activate()
        
        nameStack.anchor()
            .top(to: borderView.bottomAnchor, constant: 20)
            .left(to: vc.view.leftAnchor, constant: 20)
            .right(to: vc.view.rightAnchor, constant: -20)
            .activate()
        
        nameTextCount.anchor()
            .top(to: nameStack.bottomAnchor, constant: 5)
            .right(to: vc.view.rightAnchor, constant: -20)
            .activate()
        
        residenceStack.anchor()
            .top(to: nameTextCount.bottomAnchor, constant: 15)
            .left(to: vc.view.leftAnchor, constant: 20)
            .right(to: vc.view.rightAnchor, constant: -20)
            .activate()
        
        birthStack.anchor()
            .top(to: residenceStack.bottomAnchor, constant: 20)
            .left(to: vc.view.leftAnchor, constant: 20)
            .right(to: vc.view.rightAnchor, constant: -20)
            .activate()
        
        content.anchor()
            .top(to: birthStack.bottomAnchor, constant: 25)
            .left(to: vc.view.leftAnchor, constant: 20)
            .width(to: vc.view.widthAnchor, multiplier: 0.18)
            .activate()
        
        contentField.anchor()
            .top(to: birthStack.bottomAnchor, constant: 20)
            .left(to: content.rightAnchor, constant: 20)
            .right(to: vc.view.rightAnchor, constant: -20)
            .height(constant: 100)
            .activate()
        
        contentTextCount.anchor()
            .top(to: contentField.bottomAnchor, constant: 5)
            .right(to: vc.view.rightAnchor, constant: -20)
            .activate()
        }
    
    func mapping(user: User) {
        userImage.setImage(url: user.userImage)
        nameField.text = user.name
        nameTextCount.text = "15/\(user.name.count)"
        contentField.text = user.content
        residenceField.text = user.residence
        birthField.text = user.birth
    }
    
    func setImage(image: UIImage?) {
        userImage.image = image
    }
    
    func adjustForKeyboard(notification: Notification) {
        guard let vc = viewController else { return }
        if notification.name == UIResponder.keyboardWillHideNotification {
            vc.view.frame = CGRect(x: 0, y: 0, width: vc.view.bounds.width, height: vc.view.bounds.height)
        } else {
            vc.view.frame = CGRect(x: 0, y: -contentField.frame.height, width: vc.view.bounds.width, height: vc.view.bounds.height)
        }
        contentField.scrollIndicatorInsets = contentField.contentInset
        
        let selectedRange = contentField.selectedRange
        contentField.scrollRangeToVisible(selectedRange)
    }
}
