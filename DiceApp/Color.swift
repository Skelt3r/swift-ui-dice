//
//  Color.swift
//  DiceApp
//
//  Created by Chris Allen on 7/14/24.
//

import SwiftUI

extension Color: RawRepresentable {
    public init?(rawValue: String) {
        guard
            let data = Data(base64Encoded: rawValue)
        else {
            self = .black
            return
        }
        
        do {
            self = Color(
                try NSKeyedUnarchiver
                    .unarchivedObject(
                        ofClass: UIColor.self,
                        from: data
                    )
                ?? .black
            )
        } catch {
            self = .black
        }
    }
    
    public var rawValue: String {
        do {
            let data = try NSKeyedArchiver
                .archivedData(
                    withRootObject: UIColor(self),
                    requiringSecureCoding: false
                ) as Data
            
            return data.base64EncodedString()
            
        } catch {
            return ""
        }
    }
}
