//
//  DiceModel.swift
//  DiceApp
//
//  Created by Chris Allen on 6/23/24.
//

import SwiftUI

enum Dice: String {
    case d100 = "d100"
    case d20 = "d20"
    case d12 = "d12"
    case d10 = "d10"
    case d8 = "d8"
    case d6 = "d6"
    case d4 = "d4"
}

struct Result: Identifiable {
    let id = UUID()
    let content: Int
}

public var colorOptions: [Color] {
    [
        .red,
        .pink,
        .orange,
        .yellow,
        .green,
        .blue,
        .cyan,
        .mint,
        .teal,
        .purple,
        .indigo,
        .brown
    ]
}
