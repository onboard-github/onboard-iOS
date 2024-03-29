//
//  SignUpReactor.swift
//  onboard-iOS
//
//  Created by Daye on 2023/09/17.
//

import UIKit
import Foundation

import ReactorKit


final class TestReactor: Reactor {
    
    var initialState: State = .init()
    
    enum Action {
        case testAPI
        case apple
        case google
        case kakao
    }
    
    enum Mutation {
        case setLoginResult(result: String)
    }
    
    struct State {
        var result: String = ""
    }
    
    private let useCase: TestUseCase
    private let appleUseCase: AppleLoginUseCase
    private let googleUseCase: GoogleLoginUseCase
    private let kakaoUseCase: KakaoLoginUseCase
    
    init(
        useCase: TestUseCase,
        appleUseCase: AppleLoginUseCase,
        googleUseCase: GoogleLoginUseCase,
        kakaoUseCase: KakaoLoginUseCase
    ) {
        self.useCase = useCase
        self.appleUseCase = appleUseCase
        self.googleUseCase = googleUseCase
        self.kakaoUseCase = kakaoUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .testAPI:
            return self.fetchTestResult()
            
        case .apple:
            return self.excuteAppleLogin()
            
        case .google:
            return self.excuteGoogleLogin()
            
        case .kakao:
            return self.excuteKakaoLogin()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .setLoginResult(token):
            state.result = token
        }
        
        return state
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        
        let loginMutation = self.mutation(
            result: self.appleUseCase.result
        )
        
        return Observable.merge(mutation, loginMutation)
    }
    
}

extension TestReactor {
    
    private func mutation(result: Observable<Bool>) -> Observable<Mutation> {
        return result.flatMap { response -> Observable<Mutation> in
            if response {
                return .just(.setLoginResult(result: "success"))
            }
            return .just(.setLoginResult(result: "fail"))
        }
    }
    
    private func excuteAppleLogin() -> Observable<Mutation> {
        return Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            
            Task {
                do {
                    await self.appleUseCase.signIn()
                }
            }
            return Disposables.create()
        }
    }
    
    private func excuteGoogleLogin() -> Observable<Mutation> {
        return Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            
            Task {
                do {
                    await self.googleUseCase.signIn()
                }
            }
            
            return Disposables.create()
        }
    }
    
    private func excuteKakaoLogin() -> Observable<Mutation> {
        return Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            Task {
                do {
                    await self.kakaoUseCase.signIn()
                }
            }
            return Disposables.create()
        }
    }
    
    private func fetchTestResult() -> Observable<Mutation> {
        return Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            
            Task {
                do {
                    let result = try await self.useCase.fetchTestAPi()
                    
                    observer.onNext(.setLoginResult(result: result.text))
                    observer.onCompleted()
                    
                } catch {
                    throw error
                }
            }
            return Disposables.create()
        }
    }
}
