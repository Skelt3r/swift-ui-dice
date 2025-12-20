//
//  DiceUITests.swift
//  DiceUITests
//
//  Created by Chris Allen on 7/10/24.
//

import XCTest

class DiceUITests: XCTestCase {
    
    let app = DiceScreen().app
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app.terminate()
    }
    
    func test_rollSingleDice() throws {
        DiceScreen()
            .tapRollButton()
            .validateActiveSumLabel()
            .validateInputLabel("You rolled 1d20")
    }
    
    func test_rollMultipleDice() throws {
        DiceScreen()
            .selectDiceType(.d6)
            .validateDiceTypeLabel(.d6)
            .increaseDiceAmount(by: 3)
            .validateDiceAmountLabel(4)
            .tapRollButton()
            .validateActiveSumLabel()
            .validateInputLabel("You rolled 4d6")
    }
    
    func test_addPositiveRollModifier() throws {
        DiceScreen()
            .increaseRollModifier(by: 1)
            .validateRollModifierLabel(1)
            .tapRollButton()
            .validateActiveSumLabel()
            .validateInputLabel("You rolled 1d20+1")
    }
    
    func test_addNegativeRollModifier() throws {
        DiceScreen()
            .selectDiceType(.d4)
            .increaseDiceAmount(by: 1)
            .decreaseRollModifier(by: 1)
            .tapRollButton()
            .validateActiveSumLabel()
            .validateInputLabel("You rolled 2d4-1")
    }
    
    func test_resetDiceAmount() throws {
        DiceScreen()
            .increaseDiceAmount(by: 3)
            .tapRollButton()
            .resetDiceAmount()
            .validateDiceAmountLabel(1)
            .validateDefaultSumLabel()
            .validateInputLabel("...")
    }
    
    func test_resetRollModifier() throws {
        DiceScreen()
            .increaseRollModifier(by: 3)
            .tapRollButton()
            .resetRollModifier()
            .validateRollModifierLabel(0)
            .validateDefaultSumLabel()
            .validateInputLabel("...")
    }
    
    func test_openSettingsMenu() throws {
        DiceScreen()
            .tapSettingsButton()
            .validateSettingsSheet()
    }
    
    func test_openResultsList() throws {
        DiceScreen()
            .selectDiceType(.d12)
            .increaseDiceAmount(by: 3)
            .increaseRollModifier(by: 1)
            .tapRollButton()
            .tapResultsButton()
            .validateResultsList(
                hasInput: "You rolled 4d12+1",
                hasOutput: /\(\d+\+\d+\+\d+\+\d+\)\+1 = \d+/
            )
    }
    
    func test_openHintBox() throws {
        DiceScreen()
            .tapHelpButton()
            .validateHintBox()
    }
}
