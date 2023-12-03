//
//  TermsEntity.swift
//  onboard-iOS
//
//  Created by 윤다예 on 11/28/23.
//

import Foundation

struct TermsEntity {
    let terms: [Term]
    
    struct Term {
        let code: String
        let title: String
        let url: String
        let isReuired: Bool
    }
}

enum TermsAgreementEntity {
    struct Req {
        let agreeList: [String]
        let disagreeList: [String]
    }
}
