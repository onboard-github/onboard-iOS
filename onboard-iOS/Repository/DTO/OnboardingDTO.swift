//
//  OnboardingDTO.swift
//  onboard-iOS
//
//  Created by 윤다예 on 12/2/23.
//

import Foundation

struct OnboardingDTO: Decodable {
    let onboarding: [String]
    let mainGroupId: Int?
}