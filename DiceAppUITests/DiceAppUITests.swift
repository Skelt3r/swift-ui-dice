//
//  DiceAppUITests.swift
//  DiceAppUITests
//
//  Created by Chris Allen on 7/10/24.
//

import XCTest

class DiceAppUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app.terminate()
    }
    
    func test_rollSingleDice() throws {
        DiceAppScreen()
            .tapRollButton()
            .validateActiveSumLabel()
            .validateInputLabel("You rolled 1d20")
    }
    
    func test_rollMultipleDice() throws {
        DiceAppScreen()
            .selectDiceType(.d6)
            .validateDiceTypeLabel(.d6)
            .increaseDiceAmount(by: 3)
            .validateDiceAmountLabel(4)
            .tapRollButton()
            .validateActiveSumLabel()
            .validateInputLabel("You rolled 4d6")
    }
    
    func test_addRollModifier() throws {
        DiceAppScreen()
            .increaseRollModifier(by: 1)
            .validateRollModifierLabel(1)
            .tapRollButton()
            .validateActiveSumLabel()
            .validateInputLabel("You rolled 1d20+1")
    }
    
    func test_resetDiceAmount() throws {
        DiceAppScreen()
            .increaseDiceAmount(by: 3)
            .tapRollButton()
            .resetDiceAmount()
            .validateDiceAmountLabel(1)
            .validateDefaultSumLabel()
            .validateInputLabel("...")
    }
    
    func test_resetRollModifier() throws {
        DiceAppScreen()
            .increaseRollModifier(by: 3)
            .tapRollButton()
            .resetRollModifier()
            .validateRollModifierLabel(0)
            .validateDefaultSumLabel()
            .validateInputLabel("...")
    }
}
