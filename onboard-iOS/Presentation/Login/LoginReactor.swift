//
//  LoginReactor.swift
//  onboard-iOS
//
//  Created by Daye on 2023/10/08.
//

import Foundation

import ReactorKit

final class LoginReactor: Reactor {

    var initialState: State = .init()

    enum Action {
        case apple
        case google
        case kakao
    }
    
    enum Mutation { }

    struct State {
        var result: String = ""
        var stage: [OnboardingStage] = []
    }
    
    private let coordinator: LoginCoordinator
    private let appleUseCase: AppleLoginUseCase
    private let kakaoUseCase: KakaoLoginUseCase
    private let googleUseCase: GoogleLoginUseCase

    init(
        appleUseCase: AppleLoginUseCase,
        kakaoUseCase: KakaoLoginUseCase,
        googleUseCase: GoogleLoginUseCase,
        coordinator: LoginCoordinator
    ) {
        self.appleUseCase = appleUseCase
        self.kakaoUseCase = kakaoUseCase
        self.googleUseCase = googleUseCase
        self.coordinator = coordinator
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .apple:
            return self.excuteAppleLogin()

        case .google:
            return .empty()

        case .kakao:
            return self.excuteKakaoLogin()
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {

        let appleMutation = self.mutation(
            result: self.appleUseCase.result
        )
        
        let kakaoMutation = self.mutation(
            result: self.kakaoUseCase.result
        )
        
        let googleMutation = self.mutation(
            result: self.googleUseCase.result
        )

        return Observable.merge([
            mutation,
            appleMutation,
            kakaoMutation,
            googleMutation
        ])
    }
}

extension LoginReactor {

    private func mutation(result: Observable<OnboardingEntity>) -> Observable<Mutation> {
        return result.flatMap { response -> Observable<Mutation> in
            
            guard let firstStage = response.stages.first,
                  let stage = OnboardingStage(rawValue: firstStage) else {
                
                // TODO: - 온보딩 남은 스테이지 없음 -> home으로 이동
//                if response.stages.isEmpty {
//                    return self.coordinator.showHome()
//                }
                return .empty()
            }
            
            switch stage {
            case .terms, .updateTerms:
                self.coordinator.showTermsAgreementView()
                
            case .nickname:
                self.coordinator.showNicknameSetting()
                
            case .joinGroup:
                self.coordinator.showGroupSearch()
            }
            
            return .empty()
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

    private func googleLoginResult(token: String) -> Observable<Mutation> {
        return Observable.create { [weak self] observer in
            guard let self else { return Disposables.create() }
            
//            Task {
//                do {
//                    try await self.googleUseCase.signIn(token: token)
//                }
//            }
            return Disposables.create()
        }
    }
}

// MARK: - Google login delegate

extension LoginReactor: GoogleLoginDelegate {

    func success(token: String) {
        Task {
            do {
                try await self.googleUseCase.signIn(token: token)
            }
        }
    }
}
