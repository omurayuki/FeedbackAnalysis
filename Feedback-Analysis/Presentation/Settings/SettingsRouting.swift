import Foundation
import UIKit
import RxSwift

protocol SettingsRouting: Routing {
    func moveEmailEditPage()
    func movePassEditPage()
    func moveTopPage()
    func dismiss()
}

final class SettingsRoutingImpl: SettingsRouting {
    
    var viewController: UIViewController?
    
    func moveEmailEditPage() {
        let repository = AccountRepositoryImpl.shared
        let useCase = SettingsUseCaseImpl(repository: repository)
        let presenter = EmailEditingPresenterImpl(useCase: useCase)
        let vc = EmailEditingViewController()
        
        let ui = EmailEditingUIImpl()
        let routing = EmailEditingRoutingImpl()
        ui.viewController = vc
        routing.viewController = vc
        
        vc.inject(ui: ui,
                  routing: routing,
                  presenter: presenter,
                  disposeBag: DisposeBag())
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func movePassEditPage() {
        let repository = AccountRepositoryImpl.shared
        let useCase = SettingsUseCaseImpl(repository: repository)
        let presenter = PasswordEditingPresenterImpl(useCase: useCase)
        let vc = PasswordEditingViewController()
        
        let ui = PasswordEditingUIImpl()
        let routing = PasswordEditingRoutingImpl()
        ui.viewController = vc
        routing.viewController = vc
        
        vc.inject(ui: ui,
                  routing: routing,
                  presenter: presenter,
                  disposeBag: DisposeBag())
        
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveTopPage() {
        let vc = TopViewController()
        var routing: TopRouting = TopRoutingImpl()
        routing.viewController = vc
        var ui: TopUI = TopUIImpl()
        ui.viewController = vc
        vc.inject(ui: ui, routing: routing, disposeBag: DisposeBag())
        viewController?.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
