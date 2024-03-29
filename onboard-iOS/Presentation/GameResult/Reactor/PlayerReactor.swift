//
//  PlayerReactor.swift
//  onboard-iOS
//
//  Created by 혜리 on 1/18/24.
//

import Foundation

import ReactorKit

final class PlayerReactor: Reactor {
    
    var initialState: State = .init(playerData: [])
    
    enum Action {
        case fetchResult(groupId: Int, size: String)
        case validateNickname(groupId: Int, nickname: String)
        case addPlayer(groupId: Int, nickName: String)
        case allPlayerData(groupId: Int, gameId: Int)
    }
    
    enum Mutation {
        case setPlayerData([PlayerEntity.Res])
        case setNicknameResult(GuestNickNameEntity.Res)
        case setAddPlayer(result: AddPlayerEntity.Res)
        case setAllPlayerData([GameLeaderboardEntity.Res])
    }
    
    struct State {
        var playerData: [PlayerEntity.Res] = []
        var nicknameResult: GuestNickNameEntity.Res?
        var AddPlayerData: AddPlayerEntity.Res?
        var allPlayer: [GameLeaderboardEntity.Res] = []
    }
    
    private let useCase: PlayerUseCase
    
    init(
        useCase: PlayerUseCase
    ) {
        self.useCase = useCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .fetchResult(groupId, size):
            return self.PlayerListResult(groupId: groupId, size: size)
        case let .validateNickname(groupId, nickname):
            return self.validateResult(groupId: groupId, nickname: nickname)
        case let .addPlayer(groupId, nickName):
            return self.addPlayerResult(groupId: groupId, nickName: nickName)
        case let .allPlayerData(groupId, gameId):
            return self.updatePlayerResult(groupId: groupId, gameId: gameId)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setPlayerData(let playerData):
            state.playerData = playerData
        case .setNicknameResult(let result):
            state.nicknameResult = result
        case .setAddPlayer(let result):
            state.AddPlayerData = result
        case .setAllPlayerData(let result):
            state.allPlayer = result
        }
        
        return state
    }
}

extension PlayerReactor {
    
    private func PlayerListResult(groupId: Int, size: String) -> Observable<Mutation> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            Task {
                do {
                    let result = try await self.useCase.fetchPlayerList(groupId: groupId,
                                                                        size: size)
                    observer.onNext(.setPlayerData([result]))
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    private func validateResult(groupId: Int, nickname: String) -> Observable<Mutation> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            Task {
                do {
                    let result = try await self.useCase.fetchValidateNickName(groupId: groupId,
                                                                              nickname: nickname)
                    observer.onNext(.setNicknameResult(result))
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    private func addPlayerResult(groupId: Int, nickName: String) -> Observable<Mutation> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            Task {
                do {
                    let result = try await self.useCase.fetchAddPlayer(groupId: groupId,
                                                                       nickName: nickName)
                    observer.onNext(.setAddPlayer(result: result))
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    private func updatePlayerResult(groupId: Int, gameId: Int) -> Observable<Mutation> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            Task {
                do {
                    let result = try await self.useCase.fetchAllPlayer(groupId: groupId,
                                                                    gameId: gameId)
                    observer.onNext(.setAllPlayerData([result]))
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
