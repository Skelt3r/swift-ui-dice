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
    
    func test_addPositiveRollModifier() throws {
        DiceAppScreen()
            .increaseRollModifier(by: 1)
            .validateRollModifierLabel(1)
            .tapRollButton()
            .validateActiveSumLabel()
            .validateInputLabel("You rolled 1d20+1")
    }
    
    func test_addNegativeRollModifier() throws {
        DiceAppScreen()
            .selectDiceType(.d4)
            .increaseDiceAmount(by: 1)
            .decreaseRollModifier(by: 1)
            .tapRollButton()
            .validateActiveSumLabel()
            .validateInputLabel("You rolled 2d4-1")
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
    
    func test_openSettingsMenu() throws {
        DiceAppScreen()
            .tapSettingsButton()
            .validateSettingsSheet()
    }
    
    func test_openResultsList() throws {
        DiceAppScreen()
            .selectDiceType(.d12)
            .increaseDiceAmount(by: 3)
            .increaseRollModifier(by: 1)
            .tapRollButton()
            .tapResultsButton()
            .validateResultsList(
                hasLabel: /You rolled 4d12\+1 -> (\d+)/,
                hasLength: 4
            )
    }
    
    func test_openHintBox() throws {
        DiceAppScreen()
            .tapHelpButton()
            .validateHintBox()
    }
}
