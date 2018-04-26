//
//  APIInbox.swift
//  Habitica API Client
//
//  Created by Phillip Thelen on 03.04.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models

class APIInbox: InboxProtocol, Decodable {
    @objc dynamic var optOut: Bool = false
    var numberNewMessages: Int = 0
    var messages: [InboxMessageProtocol] = []
    
    enum CodingKeys: String, CodingKey {
        case optOut
        case numberNewMessages = "newMessages"
        case messages
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        optOut = (try? values.decode(Bool.self, forKey: .optOut)) ?? false
        numberNewMessages = (try? values.decode(Int.self, forKey: .numberNewMessages)) ?? 0
        try? values.decode([String: APIInboxMessage].self, forKey: .messages).forEach({ (key, message) in
            messages.append(message)
        })
    }
}
