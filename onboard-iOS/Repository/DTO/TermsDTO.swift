//
//  TermsAgreementDTO.swift
//  onboard-iOS
//
//  Created by 윤다예 on 11/28/23.
//

import Foundation

struct TermsDTO: Decodable {
    let contents: [Term]
    
    struct Term: Decodable {
        let code: String
        let title: String
        let url: String
        let isRequired: Bool
    }
}

enum TermsAgreementRequest {
    struct Body: Encodable {
        let agree: [String]
        let disagree: [String]
    }
}

struct TermsAgreementDTO: Decodable {
    let result: Bool?
}