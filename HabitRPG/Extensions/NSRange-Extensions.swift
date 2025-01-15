//
//  NSRange-Extensions.swift
//  Habitica
//
//  Created by Phillip Thelen on 15.01.25.
//  Copyright © 2025 HabitRPG Inc. All rights reserved.
//

import Foundation

extension NSRange {
    func isSafe(for str: NSString) -> Bool {
        return location != NSNotFound && location + length <= str.length
    }
    
    func isSafe(for str: NSAttributedString) -> Bool {
        return location != NSNotFound && location + length <= str.length
    }
}
