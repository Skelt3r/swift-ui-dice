//
//  ContentView.swift
//  DiceApp
//
//  Created by Chris Allen on 6/18/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Variables
    
    @State private var diceType: Dice = .d20
    @State private var diceAmount: Int = 1
    @State private var rollModifier: Int = 0
    @State private var sum: Int = 0
    @State private var results: [Result] = []
    @State private var resultsSheetIsVisible: Bool = false
    @State private var darkMode: Bool = false
    @State private var settingsSheetIsVisible: Bool = false
    @State private var hintsAreVisible: Bool = false
    @State private var primaryColor: Color = .red
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    // MARK: Body
    
    var body: some View {
        VStack {
            settingsSheet
            diceMenu
            diceAmountInput
            rollModifierInput
            sumLabel
            resultsSheet
            rollButton
            inputLabel
            helpButton
            Spacer()
        }
        .preferredColorScheme(darkMode ? .dark : .light)
        .font(.largeTitle)
        .padding()
    }
    
    // MARK: Settings Sheet
    
    var settingsSheet: some View {
        Button() {
            settingsSheetIsVisible.toggle()
        } label: {
            Image(systemName: "gearshape.fill")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundStyle(primaryColor)
                .imageScale(.large)
        }.sheet(
            isPresented: $settingsSheetIsVisible,
            content: {
                
                // Dark Mode Toggle
                
                Toggle(
                    isOn: $darkMode,
                    label: {
                        HStack {
                            Image(systemName: "moon.circle")
                            Text("Dark Mode")
                                .font(.title2)
                        }
                    }
                )
                .tint(primaryColor)
                .preferredColorScheme(darkMode ? .dark : .light)
                .padding(.horizontal, 40)
                .padding(.top, 50)
                .accessibilityIdentifier("darkModeToggle")
                
                // Primary Color Menu
                
                Menu {
                    colorButton(.red)
                    colorButton(.pink)
                    colorButton(.orange)
                    colorButton(.yellow)
                    colorButton(.green)
                    colorButton(.blue)
                    colorButton(.cyan)
                    colorButton(.mint)
                    colorButton(.teal)
                    colorButton(.purple)
                    colorButton(.indigo)
                    colorButton(.brown)
                } label: {
                    Image(systemName: "rainbow")
                    Text("Primary Color")
                    Spacer()
                    Text(primaryColor.description.capitalized)
                        .foregroundStyle(primaryColor)
                        .accessibilityIdentifier("colorMenuLabel")
                }
                .foregroundStyle(adjustColor())
                .font(.title2)
                .padding(.horizontal, 40)
                .padding(.top, 20)

                Spacer()
                
                // X Button
                
                Button() {
                    settingsSheetIsVisible.toggle()
                } label: {
                    Image(systemName: "x.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(primaryColor)
                }
                .padding(10)
                .accessibilityIdentifier("xButtonSettings")
            }
        )
        .padding()
        .accessibilityIdentifier("settingsButton")
    }
    
    // MARK: Dice Menu
    
    var diceMenu: some View {
        HStack {
            Menu {
                diceButton(.d20)
                diceButton(.d12)
                diceButton(.d10)
                diceButton(.d8)
                diceButton(.d6)
                diceButton(.d4)
                diceButton(.d100)
            } label: {
                Image(systemName: "dice.fill")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .imageScale(.large)
                    .foregroundColor(primaryColor)
                
                Text(diceType.rawValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .gridCellAnchor(.leading)
                    .foregroundStyle(adjustColor())
                    .onChange(of: diceType, { resetResults() })
                    .padding(.horizontal)
                    .accessibilityIdentifier("diceMenuLabel")
            }
        }.padding(.top)
    }
    
    // MARK: Dice Amount Input
    
    var diceAmountInput: some View {
        HStack {
            HStack {
                Spacer()
                Button() {
                    diceAmount = 1
                } label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundStyle(.gray)
                        .accessibilityIdentifier("diceAmountResetButton")
                }
                
                Image(systemName: "number")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .imageScale(.large)
                    .foregroundStyle(primaryColor)
            }
            
            Stepper("\(diceAmount)", value: $diceAmount, in: 1...100)
                .frame(maxWidth: .infinity)
                .onChange(of: diceAmount, { resetResults() })
                .padding(.horizontal)
                .accessibilityIdentifier("diceAmountStepper")
            
        }.padding(.top, 30)
    }
    
    // MARK: Roll Modifier Input
    
    var rollModifierInput: some View {
        HStack {
            HStack {
                Spacer()
                Button() {
                    rollModifier = 0
                } label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundStyle(.gray)
                }.accessibilityIdentifier("rollModifierResetButton")
                
                Image(systemName: "plus.forwardslash.minus")
                    .frame(maxWidth: .infinity, minHeight: 1, alignment: .trailing)
                    .imageScale(.large)
                    .foregroundStyle(primaryColor)
            }
            
            Stepper("\(rollModifier)", value: $rollModifier, in: -100...100)
                .frame(maxWidth: .infinity)
                .onChange(of: rollModifier, { resetResults() })
                .padding(.horizontal)
                .accessibilityIdentifier("rollModifierStepper")
            
        }.padding(.top, 30)
    }
    
    // MARK: Sum Label
    
    var sumLabel: some View {
        HStack {
            Image(systemName: "sum")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .imageScale(.large)
                .foregroundStyle(primaryColor)
            
            Text(sum.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .accessibilityIdentifier("sumLabel")
            
        }.padding(.top, 30)
    }
    
    // MARK: Results Sheet
    
    var resultsSheet: some View {
        Button {
            resultsSheetIsVisible.toggle()
        } label: {
            HStack {
                Image(systemName: "list.number")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .imageScale(.large)
                    .foregroundStyle(primaryColor)
                
                Image(systemName: "rectangle.expand.vertical")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .imageScale(.small)
                    .foregroundStyle(adjustColor())
                    .padding(.horizontal, 10)
                    .accessibilityIdentifier("resultsListButton")
            }
        }.sheet(
            isPresented: $resultsSheetIsVisible,
            content: {
                if diceAmount > 0, results.count > 0 {
                    
                    // Input + Sum Label
                    
                    Text("\(showInputMessage()) -> \(sum)")
                        .font(.title2)
                        .foregroundStyle(adjustColor())
                        .padding(50)
                        .accessibilityIdentifier("resultsListInputAndSum")
                    
                    Divider()
                    
                    // Individual Results List
                    
                    List(results, id: \.id) { result in
                        GeometryReader { geometry in
                            VStack(alignment: .center) {
                                Text(result.content.description)
                            }
                            .frame(width: geometry.size.width)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .font(.title)
                    .accessibilityIdentifier("resultsList")
                    
                } else {
                    
                    // Placeholder Message
                    
                    Text("You haven't rolled any dice.")
                        .font(.headline)
                        .padding(.top, 50)
                    
                    Spacer()
                }
                
                // X Button
                
                Button() {
                    resultsSheetIsVisible.toggle()
                } label: {
                    Image(systemName: "x.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(primaryColor)
                }
                .padding(10)
                .accessibilityIdentifier("xButtonResultsSheet")
            }
        ).padding(.top)
    }
    
    // MARK: Roll Button
    
    var rollButton: some View {
        Button {
            guard diceAmount > 0 else { return }
            resetResults()
            for _ in 1...diceAmount {
                results.append(Result(content: generateRandomInt()))
            }
            for result in results {
                sum += result.content
            }
            sum += rollModifier
        } label: {
            Text("Roll dice")
                .foregroundStyle(.black)
                .fontDesign(.monospaced)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle)
        .tint(primaryColor)
        .padding(.top, 40)
        .accessibilityIdentifier("rollButton")
    }
    
    // MARK: Input Label
    
    var inputLabel: some View {
        Text(results.count > 0 ? showInputMessage() : "...")
            .foregroundStyle(adjustColor())
            .font(.callout)
            .padding(10)
            .accessibilityIdentifier("inputLabel")
    }
    
    // MARK: Help Button
    
    var helpButton: some View {
        Button() {
            hintsAreVisible.toggle()
        } label: {
            Image(systemName: "questionmark.circle")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundStyle(primaryColor)
                .imageScale(.large)
                .accessibilityIdentifier("helpButton")
        }
        .popover(
            isPresented: $hintsAreVisible,
            attachmentAnchor: .point(.center),
            content: {
                VStack {
                    hint(imageName: "dice", text: "Dice Type")
                    hint(imageName: "number", text: "Dice Amount")
                    hint(imageName: "plus.forwardslash.minus", text: "Roll Modifier")
                    hint(imageName: "sum", text: " Sum")
                    hint(imageName: "list.number", text: "Results List")
                }
                .font(.headline)
                .padding()
            }
        )
        .padding()
    }
    
    // MARK: View Functions

    func diceButton(_ option: Dice) -> some View {
        Button() {
            diceType = option
            results.removeAll()
        } label: {
            Text(option.rawValue)
                .accessibilityIdentifier("\(option)DiceButton")
        }
    }
    
    func colorButton(_ option: Color) -> some View {
        Button() {
            primaryColor = option
        } label: {
            Text(option.description.capitalized)
        }.accessibilityIdentifier("\(option)ColorButton")
    }
    
    func hint(imageName: String, text: String) -> some View {
        HStack {
            Image(systemName: imageName)
            Text(text).presentationCompactAdaptation(.popover)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    // MARK: Utility Functions
    
    func generateRandomInt() -> Int {
        let diceValue = Int(diceType.rawValue.replacingOccurrences(of: "d", with: ""))
        return Int.random(in: 1...diceValue!)
    }
    
    func resetResults() {
        results.removeAll()
        sum = 0
    }
    
    func showInputMessage() -> String {
        "You rolled \(diceAmount)\(diceType.rawValue)\(rollModifier != 0 ? (rollModifier > 0 ? "+" : "") + String(rollModifier) : "")"
    }
    
    func adjustColor() -> Color {
        colorScheme == .dark ? Color.white : Color.black
    }
}

#Preview {
    ContentView()
}
