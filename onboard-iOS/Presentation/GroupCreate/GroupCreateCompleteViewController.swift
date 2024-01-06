//
//  GroupCreateCompleteViewController.swift
//  onboard-iOS
//
//  Created by 혜리 on 12/22/23.
//

import UIKit

import ReactorKit

final class GroupCreateCompleteViewController: UIViewController, View {
    
    typealias Reactor = GroupCreateReactor
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    private let groupCreateCompleteView = GroupCreateCompleteView()
    
    // MARK: - Life Cycles
    
    override func loadView() {
        super.loadView()
        
        self.view = groupCreateCompleteView
    }
    
    // MARK: - Initialize
    
    init(reactor: GroupCreateReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Bind
    
    func bind(reactor: GroupCreateReactor) {
        self.bindAction(reactor: reactor)
        self.bindState(reactor: reactor)
    }
    
    func bindAction(reactor: GroupCreateReactor) {
        
    }
    
    func bindState(reactor: GroupCreateReactor) {
        reactor.state
            .compactMap { $0.createdGroup }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
            })
            .disposed(by: disposeBag)
    }
}
