//
//  DiceView.swift
//  SimpleDice
//
//  Created by Chris Allen on 6/18/24.
//

import SwiftUI

struct DiceView: View {
    
    // MARK: States
    
    @State internal var diceType: Dice = .d20
    @State internal var diceAmount: Int = 1
    @State internal var rollModifier: Int = 0
    @State internal var sum: Int = 0
    @State internal var results: [Result] = []
    @State internal var resultsSheetIsVisible: Bool = false
    @State internal var settingsSheetIsVisible: Bool = false
    @State internal var hintsAreVisible: Bool = false
    @State internal var shake: Bool = false
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @AppStorage("darkMode") private var darkMode: Bool = false
    @AppStorage("primaryColor") private var primaryColor: Color = .red
    
    // MARK: Views
    
    var body: some View {
        ScrollView {
            VStack {
                settingsSheet()
                diceMenu()
                diceAmountInput()
                rollModifierInput()
                sumLabel()
                resultsSheet()
                rollButton()
                inputLabel()
                helpButton()
                Spacer()
            }
            .preferredColorScheme(darkMode ? .dark : .light)
            .minimumScaleFactor(0.5)
            .font(.largeTitle)
            .padding()
        }
    }
    
    // MARK: Settings Sheet
    
    func settingsSheet() -> some View {
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
                
                // MARK: Dark Mode Toggle
                ScrollView {
                    Spacer()
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
                    
                    // MARK: Color Menu
                    
                    Menu {
                        ForEach(0..<Color.options.count, id: \.self) { index in
                            colorButton(Color.options[index])
                        }
                    } label: {
                        Image(systemName: "rainbow")
                        Text("Primary Color")
                        Spacer()
                        Circle()
                            .frame(width: 48, height: 32)
                            .foregroundStyle(primaryColor)
                            .accessibilityIdentifier("colorMenuButton")
                    }
                    .foregroundStyle(adjustColor())
                    .font(.title2)
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                    
                    Spacer()
                }
                
                // MARK: X Button
                
                xButton(
                    binding: $settingsSheetIsVisible,
                    accessibilityId: "xButtonSettings"
                )
                .presentationDetents([.medium, .large])
            }
        )
        .padding()
        .accessibilityIdentifier("settingsButton")
    }
    
    // MARK: Dice Menu
    
    func diceMenu() -> some View {
        HStack {
            Menu {
                ForEach(Dice.allCases, id: \.rawValue) { item in
                    diceButton(item)
                }
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
                
            }.buttonStyle(.plain)
        }.padding(.top)
    }
    
    // MARK: Dice Amount
    
    func diceAmountInput() -> some View {
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
            
            Stepper("\(diceAmount)", value: $diceAmount, in: 1...999)
                .frame(maxWidth: .infinity)
                .lineLimit(1)
                .onChange(of: diceAmount, { resetResults() })
                .padding(.horizontal)
                .accessibilityIdentifier("diceAmountStepper")
            
        }.padding(.top, 30)
    }
    
    // MARK: Roll Modifier
    
    func rollModifierInput() -> some View {
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
            
            Stepper("\(rollModifier)", value: $rollModifier, in: -999...999)
                .frame(maxWidth: .infinity)
                .lineLimit(1)
                .onChange(of: rollModifier, { resetResults() })
                .padding(.horizontal)
                .accessibilityIdentifier("rollModifierStepper")
            
        }.padding(.top, 30)
    }
    
    // MARK: Sum Label
    
    func sumLabel() -> some View {
        HStack {
            Image(systemName: "sum")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .imageScale(.large)
                .foregroundStyle(primaryColor)
            
            Text(sum.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(x: shake ? 3 : 0)
                .padding(.horizontal)
                .accessibilityIdentifier("sumLabel")
            
        }.padding(.top, 30)
    }
    
    // MARK: Results Sheet
    
    func resultsSheet() -> some View {
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
                    .accessibilityIdentifier("resultsButton")
            }
        }.sheet(
            isPresented: $resultsSheetIsVisible,
            content: {
                VStack {
                    if diceAmount > 0, results.count > 0 {
                        // MARK: Input Label
                        
                        Text(showInputMessage())
                            .padding(.top, 50)
                            .accessibilityIdentifier("resultsListInput")
                        
                        ScrollView {
                            Text("(\(results.map { String($0.content) }.joined(separator: "+")))+\(rollModifier) = \(sum)")
                                .padding(25)
                                .accessibilityIdentifier("resultsListOutput")
                        }
                    } else {
                        // MARK: Placeholder
                        
                        Text("You haven't rolled any dice.")
                            .padding(.top, 50)
                    }
                    
                    Spacer()
                    
                    // MARK: X Button
                    
                    xButton(
                        binding: $resultsSheetIsVisible,
                        accessibilityId: "xButtonResults"
                    )
                    .font(.largeTitle)
                }
                .font(.title2)
                .foregroundStyle(adjustColor())
                .presentationDetents([.medium, .large])
            }
        ).padding(.top)
    }
    
    // MARK: Roll Button
    
    func rollButton() -> some View {
        Button {
            guard diceAmount > 0 else { return }
            shake = true
            resetResults()
            
            for _ in 1...diceAmount {
                let result = Result(content: generateRandomInt())
                results.append(result)
                sum += result.content
            }
            
            sum += rollModifier
            
        } label: {
            Text("Roll dice")
                .foregroundStyle(.black)
                .fontDesign(.monospaced)
        }
        .onChange(of: shake) {
            withAnimation(.spring(
                response: 0.2,
                dampingFraction: 0.2,
                blendDuration: 0.2
            )) { shake = false }
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle)
        .tint(primaryColor)
        .padding(.top, 40)
        .accessibilityIdentifier("rollButton")
    }
    
    // MARK: Input Label
    
    func inputLabel() -> some View {
        Text(results.count > 0 ? showInputMessage() : "...")
            .foregroundStyle(adjustColor())
            .font(.callout)
            .padding(10)
            .accessibilityIdentifier("inputLabel")
    }
    
    // MARK: Help Button
    
    func helpButton() -> some View {
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
            arrowEdge: .bottom,
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
        .buttonStyle(.plain)
        .padding()
    }
    
    // MARK: Dice Button

    /// Generates a menu option button with the given dice value as the label.
    /// - Parameter option: ``Dice``
    /// - Returns: ``View``
    func diceButton(_ option: Dice) -> some View {
        Button() {
            diceType = option
            results.removeAll()
        } label: {
            Text(option.rawValue)
                .accessibilityIdentifier("\(option)DiceButton")
        }
    }
    
    // MARK: Color Button
    
    /// Generates a menu option button with the given color as the label.
    /// - Parameter option: ``Color``
    /// - Returns: ``View``
    func colorButton(_ option: Color) -> some View {
        Button() {
            primaryColor = option
        } label: {
            Text(option.description.capitalized)
        }
        .accessibilityIdentifier("\(option)ColorButton")
    }
    
    // MARK: X Button
    
    /// Generates an X button which dismisses a Sheet view.
    /// - Parameters:
    ///   - binding: The binding to be toggled when the button is clicked. ``Binding<Bool>``
    ///   - accessibilityId: The identifier for the button. ``String``
    /// - Returns: ``View``
    func xButton(binding: Binding<Bool>, accessibilityId: String) -> some View {
        Button() {
            binding.wrappedValue.toggle()
        } label: {
            Image(systemName: "x.circle.fill")
                .imageScale(.large)
                .foregroundStyle(primaryColor)
        }
        .padding(10)
        .accessibilityIdentifier(accessibilityId)
    }
    
    // MARK: Hint
    
    /// Generates the given system image and text in an ``HStack``.
    /// Used to populate the hint box.
    /// - Parameters:
    ///   - imageName: System name ``String``
    ///   - text: Hint text ``String``
    /// - Returns: ``View``
    func hint(imageName: String, text: String) -> some View {
        HStack {
            Image(systemName: imageName)
                .accessibilityIdentifier("hintImage")
            Text(text)
                .presentationCompactAdaptation(.popover)
                .accessibilityIdentifier("hintText")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
    
    // MARK: Utility Functions
    
    /// Generates a random integer between 1 and the max value of the currently selected `diceType`.
    /// - Returns: ``Int``
    func generateRandomInt() -> Int {
        let diceValue = Int(diceType.rawValue.replacingOccurrences(of: "d", with: ""))
        return Int.random(in: 1...diceValue!)
    }
    
    /// Clears the `results` array and sets the `sum` of results to zero.
    func resetResults() {
        results.removeAll()
        sum = 0
    }
    
    /// Displays a message containing the most recent roll parameters.
    /// - Returns: ``String``
    func showInputMessage() -> String {
        "You rolled " +
        String(diceAmount) +
        diceType.rawValue +
        (rollModifier != 0 ? (rollModifier > 0 ? "+" : "") + String(rollModifier) : "")
    }
    
    /// Toggles between black and white based on the current `colorScheme`.
    /// - Returns: ``Color``
    func adjustColor() -> Color {
        colorScheme == .dark ? Color.white : Color.black
    }

}

#Preview {
    DiceView()
}
