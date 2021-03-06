import UIKit
import GrowingTextView

protocol DetailUI: UI {
    var textViewBottomConstraint: NSLayoutConstraint { get set }
    var detailUserPhotoGestureView: UIView { get }
    var detail: TimelineView { get }
    var refControl: UIRefreshControl { get }
    var commentTable: UITableView { get }
    var editBtn: UIBarButtonItem { get }
    var inputToolBar: UIView { get }
    var commentField: GrowingTextView { get }
    var commentFieldTextCount: UILabel { get }
    var submitBtn: UIButton { get }
    var viewTapGesture: UITapGestureRecognizer { get }
    
    func setup()
    func determineHeight(height: CGFloat)
    func isHiddenSubmitBtn(_ bool: Bool)
    func isHiddenTextCount(_ bool: Bool)
    func clearCommentField()
    func changeViewWithKeyboardY(_ bool: Bool, height: CGFloat)
}

final class DetailUIImpl: DetailUI {
    
    weak var viewController: UIViewController?
    
    var textViewBottomConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint()
        return constraint
    }()
    
    private(set) var detailUserPhotoGestureView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private(set) var editBtn: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.title = "編集"
        item.style = .plain
        return item
    }()
    
    private(set) var detail: TimelineView = {
        return TimelineView()
    }()
    
    var refControl: UIRefreshControl = {
        let refControl = UIRefreshControl()
        return refControl
    }()
    
    private(set) var commentTable: UITableView = {
        let table = UITableView.Builder()
            .backgroundImage(#imageLiteral(resourceName: "logo"))
            .backGroundViewContentMode(.scaleAspectFit)
            .backgroundAlpha(0.1)
            .build()
        table.register(CommentCell.self, forCellReuseIdentifier: String(describing: CommentCell.self))
        return table
    }()
    
    private(set) var inputToolBar: UIView = {
        let view = UIView()
        view.backgroundColor = .tabbarColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) var commentField: GrowingTextView = {
        let textView = GrowingTextView.Builder()
            .placeHolder("コメントを記入")
            .build()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private(set) var commentFieldTextCount: UILabel = {
        let label = UILabel()
        label.apply(.appMain10)
        label.isHidden = true
        return label
    }()
    
    private(set) var submitBtn: UIButton = {
        let button = UIButton.Builder()
            .title("   返信   ")
            .border(width: 1, color: UIColor.appMainColor.cgColor)
            .cornerRadius(15)
            .backgroundColor(.appSubColor)
            .component(.appSub)
            .build()
        button.isHidden = true
        return button
    }()
    
    private(set) var viewTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        return gesture
    }()
}

extension DetailUIImpl {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.navigationItem.title = "コメント"
        vc.navigationItem.rightBarButtonItem = editBtn
        vc.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        vc.navigationController?.navigationBar.shadowImage = nil
        vc.view.backgroundColor = .appMainColor
        [commentField, submitBtn].forEach { inputToolBar.addSubview($0) }
        [detailUserPhotoGestureView, commentTable, inputToolBar, commentFieldTextCount].forEach { vc.view.addSubview($0) }
        commentTable.addSubview(refControl)
        commentTable.tableHeaderView = detail
        
        commentTable.anchor()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor)
            .width(to: vc.view.widthAnchor)
            .bottom(to: inputToolBar.topAnchor)
            .activate()
        
        detail.anchor()
            .width(to: commentTable.widthAnchor)
            .activate()
        
        let topConstraint = commentField.topAnchor.constraint(equalTo: inputToolBar.topAnchor, constant: 8)
        topConstraint.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            inputToolBar.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            inputToolBar.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            inputToolBar.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            topConstraint
        ])
        
        if #available(iOS 11, *) {
            textViewBottomConstraint = commentField.bottomAnchor.constraint(equalTo: inputToolBar.safeAreaLayoutGuide.bottomAnchor, constant: -8)
            NSLayoutConstraint.activate([
                commentField.leadingAnchor.constraint(equalTo: inputToolBar.safeAreaLayoutGuide.leadingAnchor, constant: 8),
                commentField.trailingAnchor.constraint(equalTo: inputToolBar.safeAreaLayoutGuide.trailingAnchor, constant: -8),
                textViewBottomConstraint
            ])
        } else {
            let textViewBottomConstraint = commentField.bottomAnchor.constraint(equalTo: inputToolBar.bottomAnchor, constant: -8)
            NSLayoutConstraint.activate([
                commentField.leadingAnchor.constraint(equalTo: inputToolBar.leadingAnchor, constant: 8),
                commentField.trailingAnchor.constraint(equalTo: inputToolBar.trailingAnchor, constant: -8),
                textViewBottomConstraint
            ])
        }
        
        commentFieldTextCount.anchor()
            .top(to: commentField.bottomAnchor, constant: 10)
            .left(to: commentField.leftAnchor, constant: 2)
            .activate()
        
        submitBtn.anchor()
            .top(to: commentField.bottomAnchor, constant: 10)
            .right(to: commentField.rightAnchor, constant: -2)
            .activate()
    }
    
    func determineHeight(height: CGFloat) {
        detail.anchor()
            .height(constant: height)
            .activate()
    }
    
    func isHiddenSubmitBtn(_ bool: Bool) {
        UIView.Animator(duration: 1.0)
            .animations {
                self.submitBtn.isHidden = bool
            }.animate()
    }
    
    func isHiddenTextCount(_ bool: Bool) {
        UIView.Animator(duration: 1.0)
            .animations {
                self.commentFieldTextCount.isHidden = bool
            }.animate()
    }
    
    func clearCommentField() {
        viewController?.view.endEditing(true)
        UIView.Animator(duration: 2.0)
            .animations {
                self.commentField.text = ""
            }.animate()
    }
    
    func changeViewWithKeyboardY(_ bool: Bool, height: CGFloat) {
        guard let vc = viewController else { return }
        vc.view.addGestureRecognizer(viewTapGesture)
        isHiddenSubmitBtn(bool)
        isHiddenTextCount(bool)
        textViewBottomConstraint.constant = -(height) - 8
        vc.view.layoutIfNeeded()
    }
}
