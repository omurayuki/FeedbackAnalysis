import UIKit
import RxSwift
import RxCocoa

final class ReplyCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    var userPhotoTapDelegate: UserPhotoTapDelegate?
    
    var identificationId = Int()
    
    private(set) var userPhotoGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        return gesture
    }()
    
    private(set) var userPhoto: UIImageView = {
        let image = UIImageView.Builder()
            .cornerRadius(25)
            .isUserInteractionEnabled(false)
            .build()
        return image
    }()
    
    private(set) var userName: UILabel = {
        let label = UILabel()
        label.apply(.h4_Bold)
        return label
    }()
    
    private(set) var postedTime: UILabel = {
        let label = UILabel()
        label.apply(.body_CoolGrey)
        return label
    }()
    
    private(set) var reply: UILabel = {
        let label = UILabel()
        label.apply(.title)
        label.numberOfLines = 0
        return label
    }()
    
    private(set) var likeCount: UILabel = {
        let label = UILabel()
        label.apply(.title_Bold, title: "0")
        return label
    }()
    
    private(set) var likeBtn: UIButton = {
        let button = UIButton.Builder()
            .title("♡")
            .component(.body_CoolGrey13)
            .build()
        return button
    }()
    
    var content: Reply? {
        didSet {
            guard let url = content?.userImage else { return }
            self.userName.text = content?.name
            self.postedTime.text = content?.time
            self.reply.text = content?.reply
            self.userPhoto.setImage(url: url)
            hideSkelton(userPhoto, userName)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        showSkelton(userPhoto, userName)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

extension ReplyCell {
    
    private func setup() {
        bindUI()
        backgroundColor = .appMainColor
        let likeStack = UIStackView.setupStack(lhs: likeBtn, rhs: likeCount, spacing: 5)
        
        [userPhoto, userName,
         postedTime, reply, likeStack].forEach { addSubview($0) }
        
        userPhoto.addGestureRecognizer(userPhotoGesture)
        
        userPhoto.anchor()
            .top(to: topAnchor, constant: 5)
            .left(to: leftAnchor, constant: 20)
            .width(constant: 50)
            .height(constant: 50)
            .activate()
        
        userName.anchor()
            .top(to: topAnchor, constant: 10)
            .left(to: userPhoto.rightAnchor, constant: 15)
            .width(constant: frame.width / 1.8)
            .height(constant: 18)
            .activate()
        
        postedTime.anchor()
            .top(to: topAnchor, constant: 10)
            .right(to: rightAnchor, constant: -20)
            .activate()
        
        reply.anchor()
            .top(to: userName.bottomAnchor, constant: 5)
            .left(to: userPhoto.rightAnchor, constant: 10)
            .right(to: rightAnchor, constant: -10)
            .width(constant: frame.width / 1.1)
            .activate()
        
        likeStack.anchor()
            .top(to: reply.bottomAnchor, constant: 2)
            .left(to: userPhoto.rightAnchor, constant: 10)
            .bottom(to: bottomAnchor, constant: -5)
            .activate()
    }
}

extension ReplyCell {
    
    func bindUI() {
        userPhotoGesture.rx.event.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.userPhotoTapDelegate?.tappedUserPhoto(index: self.identificationId)
            }).disposed(by: disposeBag)
    }
}
