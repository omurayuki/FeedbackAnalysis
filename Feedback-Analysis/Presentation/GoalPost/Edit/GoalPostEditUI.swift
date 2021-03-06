import UIKit

protocol GoalPostEditUI: UI {
    var slides: [UIView] { get set }
    var goalPostSegmented: CustomSegmentedControl { get }
    var viewTapGesture: UITapGestureRecognizer { get }
    var saveBtn: UIBarButtonItem { get }
    var cancelBtn: UIBarButtonItem { get }
    var registerNavItem: UINavigationItem { get }
    var registerBar: UINavigationBar { get }
    var scrollView: UIScrollView { get }
    var pageControl: UIPageControl { get }
    var mappingContent: Timeline? { get set }
    
    func setup()
    func setupSlideScrollView(slides: [UIView])
}

final class GoalPostEditUIImpl: GoalPostEditUI {
    
    weak var viewController: UIViewController?
    
    var slides: [UIView] = []
    
    private(set) var goalPostSegmented: CustomSegmentedControl = {
        let segment = CustomSegmentedControl(frame: CGRect(), buttonTitle: ["ステップ1", "ステップ2", "ステップ3"])
        segment.backgroundColor = .clear
        return segment
    }()
    
    private(set) var viewTapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        return gesture
    }()
    
    private(set) var saveBtn: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.title = "保存"
        item.style = .plain
        return item
    }()
    
    private(set) var cancelBtn: UIBarButtonItem = {
        let item = UIBarButtonItem()
        item.title = "キャンセル"
        item.style = .plain
        return item
    }()
    
    private(set) var registerNavItem: UINavigationItem = {
        let navItem = UINavigationItem()
        return navItem
    }()
    
    private(set) var registerBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        return navBar
    }()
    
    private(set) var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        scroll.bounces = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        scroll.isPagingEnabled = true
        return scroll
    }()
    
    private(set) var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = .appMainColor
        control.currentPageIndicatorTintColor = .appSubColor
        control.currentPage = 0
        return control
    }()
    
    var mappingContent: Timeline? {
        didSet {
            guard let genreView = slides[0] as? GenreView else { return }
            guard let newThingsView = slides[1] as? NewThingsView else { return }
            guard let expectedResultView = slides[2] as? ExpectedResultView else { return }
            
            genreView.array.forEach {
                $0.description == mappingContent?.genre1 ||
                $0.description == mappingContent?.genre2 ?
                    ($0.currentState = .selected) : ($0.currentState = .normal)
            }
            newThingsView.newThingsField.text = mappingContent?.newThings
            newThingsView.newThingsTextCount.text = "25/\(String(describing: mappingContent?.newThings.count ?? 0))"
            expectedResultView.expectedResultField1.text = mappingContent?.goal1
            expectedResultView.expectedResult1TextCount.text = "25/\(String(describing: mappingContent?.goal1?.count ?? 0))"
            expectedResultView.expectedResultField2.text = mappingContent?.goal2
            expectedResultView.expectedResult2TextCount.text = "25/\(String(describing: mappingContent?.goal2?.count ?? 0))"
            expectedResultView.expectedResultField3.text = mappingContent?.goal3
            expectedResultView.expectedResult3TextCount.text = "25/\(String(describing: mappingContent?.goal3?.count ?? 0))"
            expectedResultView.deadline.text = mappingContent?.deadLine
        }
    }
}

extension GoalPostEditUI {
    func setup() {
        registerNavItem.leftBarButtonItem = cancelBtn
        registerNavItem.rightBarButtonItem = saveBtn
        registerBar.pushItem(registerNavItem, animated: true)
        
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .appMainColor
        
        vc.view.addGestureRecognizer(viewTapGesture)
        [goalPostSegmented, registerBar,
         scrollView, pageControl].forEach { vc.view.addSubview($0) }
        
        registerBar.anchor()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor)
            .left(to: vc.view.leftAnchor)
            .right(to: vc.view.rightAnchor)
            .activate()
        
        goalPostSegmented.anchor()
            .centerXToSuperview()
            .top(to: registerBar.bottomAnchor, constant: 5)
            .width(to: vc.view.widthAnchor, multiplier: 0.95)
            .height(constant: 35)
            .activate()
        
        scrollView.anchor()
            .top(to: goalPostSegmented.bottomAnchor, constant: 2)
            .left(to: vc.view.leftAnchor)
            .right(to: vc.view.rightAnchor)
            .height(constant: vc.view.frame.size.height)
            .activate()
        
        pageControl.anchor()
            .centerXToSuperview()
            .bottom(to: vc.view.bottomAnchor, constant: -50)
            .width(constant: vc.view.frame.size.width / 1.5)
            .activate()
    }
    
    func setupSlideScrollView(slides: [UIView]) {
        guard let vc = viewController else { return }
        pageControl.numberOfPages = slides.count
        scrollView.frame = CGRect(x: 0, y: 0, width: vc.view.frame.width, height: vc.view.frame.height)
        scrollView.contentSize = CGSize(width: vc.view.frame.width * CGFloat(slides.count), height: vc.view.frame.height)
        slides.enumerated().forEach { index, slide in
            slide.frame = CGRect(x: vc.view.frame.width * CGFloat(index), y: 0, width: vc.view.frame.width, height: vc.view.frame.height)
            scrollView.addSubview(slide)
        }
    }
}
