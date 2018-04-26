//
//  APIInboxMessages.swift
//  Habitica API Client
//
//  Created by Phillip Thelen on 25.04.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models

class APIInboxMessage: InboxMessageProtocol, Decodable {
    var id: String?
    var userID: String?
    var contributor: ContributorProtocol?
    var timestamp: Date?
    var likes: [ChatMessageReactionProtocol]
    var flags: [ChatMessageReactionProtocol]
    var text: String?
    var attributedText: NSAttributedString?
    var sent: Bool
    var sort: Int
    var username: String?
    var flagCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "uuid"
        case text
        case timestamp
        case username = "user"
        case flagCount
        case contributor
        case likes
        case flags
        case sent
        case sort
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        userID = try? values.decode(String.self, forKey: .userID)
        text = try? values.decode(String.self, forKey: .text)
        if let timeStampNumber = try? values.decode(Double.self, forKey: .timestamp) {
            timestamp = Date(timeIntervalSince1970: timeStampNumber/1000)
        }
        username = try? values.decode(String.self, forKey: .username)
        flagCount = (try? values.decode(Int.self, forKey: .flagCount)) ?? 0
        contributor = (try? values.decode(APIContributor.self, forKey: .contributor))
        likes = APIChatMessageReaction.fromList(try? values.decode([String: Bool].self, forKey: .likes))
        flags = APIChatMessageReaction.fromList(try? values.decode([String: Bool].self, forKey: .flags))
        sent = (try? values.decode(Bool.self, forKey: .sent)) ?? false
        sort = (try? values.decode(Int.self, forKey: .sort)) ?? 0
    }
}
