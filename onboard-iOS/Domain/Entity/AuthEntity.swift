//
//  AuthEntity.swift
//  onboard-iOS
//
//  Created by Daye on 2023/09/18.
//

import Foundation

enum AuthEntity {
    struct Res {
        let accessToken: String
        let refreshToken: String
    }

    struct Req {
        let type: AuthType
        let token: String

        enum AuthType: String {
            case kakao = "KAKAO_ACCESS_TOKEN"
            case google = "GOOGLE_ID_TOKEN"
            case apple = "APPLE_ID_TOKEN"
            case refresh = "REFRESH"
        }
    }
}
