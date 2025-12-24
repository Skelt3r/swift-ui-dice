//
//  Dice.swift
//  SimpleDice
//
//  Created by Chris Allen on 6/23/24.
//

import SwiftUI

enum Dice: String, CaseIterable {
    case d100 = "d100"
    case d20 = "d20"
    case d12 = "d12"
    case d10 = "d10"
    case d8 = "d8"
    case d6 = "d6"
    case d4 = "d4"
    
    struct Result: Identifiable {
        let id = UUID()
        let value: Int
    }
    
    /// Generates a random integer between 1 and the max value of the currently selected `Dice`.
    /// - Returns: ``Result``
    func roll() -> Result {
        let diceValue = Int(self.rawValue.replacingOccurrences(of: "d", with: "")) ?? 0
        return Result(value: Int.random(in: 1...diceValue))
    }
}
