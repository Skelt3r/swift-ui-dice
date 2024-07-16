//
//  DiceAppScreen.swift
//  DiceAppUITests
//
//  Created by Chris Allen on 7/10/24.
//

import SwiftUI
import XCTest

class DiceAppScreen {
    
    // MARK: Structs
    
    enum Dice: String {
        case d100 = "d100"
        case d20 = "d20"
        case d12 = "d12"
        case d10 = "d10"
        case d8 = "d8"
        case d6 = "d6"
        case d4 = "d4"
    }
    
    // MARK: Elements
    
    let app = XCUIApplication()
    
    private lazy var settingsButton = app.buttons["settingsButton"]
    private lazy var darkModeToggle = app.switches["darkModeToggle"]
    private lazy var colorMenuButton = app.buttons["colorMenuButton"]
    private lazy var xButtonSettings = app.buttons["xButtonSettings"]
    
    private lazy var diceMenuLabel = app.staticTexts["diceMenuLabel"]
    
    private lazy var diceAmountResetButton = app.buttons["diceAmountResetButton"]
    private lazy var diceAmountStepper = app.steppers["diceAmountStepper"]
    private lazy var diceAmountStepperIncrement = diceAmountStepper.buttons["diceAmountStepper-Increment"]
    private lazy var diceAmountStepperDecrement = diceAmountStepper.buttons["diceAmountStepper-Decrement"]
    
    private lazy var rollModifierResetButton = app.buttons["rollModifierResetButton"]
    private lazy var rollModifierStepper = app.steppers["rollModifierStepper"]
    private lazy var rollModifierStepperIncrement = rollModifierStepper.buttons["rollModifierStepper-Increment"]
    private lazy var rollModifierStepperDecrement = rollModifierStepper.buttons["rollModifierStepper-Decrement"]
    
    private lazy var sumLabel = app.staticTexts["sumLabel"]
    
    private lazy var resultsButton = app.buttons["resultsButton"]
    private lazy var resultsListInputAndOutput = app.staticTexts["resultsListInputAndOutput"]
    private lazy var resultsList = app.collectionViews["resultsList"]
    private lazy var xButtonResults = app.buttons["xButtonResults"]
    
    private lazy var rollButton = app.buttons["rollButton"]
    private lazy var inputLabel = app.staticTexts["inputLabel"]
    
    // MARK: Actions
    
    @discardableResult
    func tapSettingsButton() -> Self {
        settingsButton.tap()
        return self
    }
    
    @discardableResult
    func toggleDarkMode() -> Self {
        darkModeToggle.coordinate(
            withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5)
        ).tap()
        return self
    }

    @discardableResult
    func selectPrimaryColor(_ option: Color) -> Self {
        colorMenuButton.tap()
        app.buttons["\(option)ColorButton"].tap()
        return self
    }
    
    @discardableResult
    func tapSettingsXButton() -> Self {
        xButtonSettings.tap()
        return self
    }
    
    @discardableResult
    func selectDiceType(_ option: Dice) -> Self {
        diceMenuLabel.tap()
        app.buttons["\(option)DiceButton"].tap()
        return self
    }
    
    @discardableResult
    func increaseDiceAmount(by number: Int) -> Self {
        for _ in 1...number {
            diceAmountStepperIncrement.tap()
        }
        return self
    }
    
    @discardableResult
    func decreaseDiceAmount(by number: Int) -> Self {
        for _ in 1...number {
            diceAmountStepperDecrement.tap()
        }
        return self
    }
    
    @discardableResult
    func resetDiceAmount() -> Self {
        diceAmountResetButton.tap()
        return self
    }
    
    @discardableResult
    func resetRollModifier() -> Self {
        rollModifierResetButton.tap()
        return self
    }
    
    @discardableResult
    func increaseRollModifier(by number: Int) -> Self {
        for _ in 1...number {
            rollModifierStepperIncrement.tap()
        }
        return self
    }
    
    @discardableResult
    func decreaseRollModifier(by number: Int) -> Self {
        for _ in 1...number {
            rollModifierStepperDecrement.tap()
        }
        return self
    }
    
    @discardableResult
    func tapRollButton() -> Self {
        rollButton.tap()
        return self
    }
    
    @discardableResult
    func tapResultsButton() -> Self {
        resultsButton.tap()
        return self
    }
    
    // MARK: Assertions
    
    @discardableResult
    func validateDiceTypeLabel(_ expectedValue: Dice) -> Self {
        XCTAssertEqual(diceMenuLabel.label, expectedValue.rawValue)
        return self
    }
    
    @discardableResult
    func validateDiceAmountLabel(_ expectedValue: Int) -> Self {
        XCTAssertEqual(diceAmountStepper.label, String(expectedValue))
        return self
    }
    
    @discardableResult
    func validateRollModifierLabel(_ expectedValue: Int) -> Self {
        XCTAssertEqual(rollModifierStepper.label, String(expectedValue))
        return self
    }
    
    @discardableResult
    func validateDefaultSumLabel() -> Self {
        XCTAssertEqual(sumLabel.label, "0")
        return self
    }
    
    @discardableResult
    func validateActiveSumLabel() -> Self {
        let diceType = Int(diceMenuLabel.label.replacingOccurrences(of: "d", with: ""))!
        let diceAmount = Int(diceAmountStepper.label)!
        let rollModifier = Int(rollModifierStepper.label)!
        let sum = Int(sumLabel.label)!
        XCTAssertGreaterThan(sum, 0)
        XCTAssertLessThanOrEqual(sum, (diceType * diceAmount) + rollModifier)
        return self
    }
    
    @discardableResult
    func validateInputLabel(_ expectedValue: String) -> Self {
        XCTAssertEqual(inputLabel.label, expectedValue)
        return self
    }
    
    @discardableResult
    func validateSettingsSheet() -> Self {
        XCTAssertTrue(darkModeToggle.isHittable)
        XCTAssertTrue(colorMenuButton.isHittable)
        XCTAssertTrue(xButtonSettings.isHittable)
        return self
    }
    
    @discardableResult
    func validateResultsList(hasLabel: any RegexComponent, hasLength: Int) -> Self {
        XCTAssertTrue(resultsListInputAndOutput.label.contains(hasLabel))
        XCTAssertTrue(resultsList.exists)
        XCTAssert(xButtonResults.isHittable)
        return self
    }
}
