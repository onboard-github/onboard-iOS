//
//  MemberUseCase.swift
//  onboard-iOS
//
//  Created by 혜리 on 3/5/24.
//

import Foundation

protocol MemberUseCase {
    func fetchAssignOwner(groupId: Int, memberId: Int) async throws -> MemberEntity.Res
}

final class MemberUseCaseImpl: MemberUseCase {
    
    private let repository: MemberRepository
    
    init(repository: MemberRepository) {
        self.repository = repository
    }
    
    func fetchAssignOwner(groupId: Int, memberId: Int) async throws -> MemberEntity.Res {
        try await self.repository.requestAssignOwner(groupId: groupId, memberId: memberId)
    }
}