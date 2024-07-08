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
    @State private var primaryColor: Color = .red
    @State private var settingsSheetIsVisible: Bool = false
    
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
            Spacer()
        }
        .preferredColorScheme(darkMode ? .dark : .light)
        .font(.largeTitle)
        .padding()
    }
    
    // MARK: Header
    
    var header: some View {
        Text("Dice!")
            .font(.largeTitle)
            .fontWeight(.bold)
            .fontDesign(.rounded)
            .foregroundStyle(adjustColor())
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
                
                // X Button
                
                Button() {
                    settingsSheetIsVisible.toggle()
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(primaryColor)
                }.padding(10)
                
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
                .padding(.top, 20)
                
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
                }
                .foregroundStyle(adjustColor())
                .font(.title2)
                .padding(.horizontal, 40)
                .padding(.top, 20)

                Spacer()
            }
        ).padding()
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
                }
                
                Image(systemName: "plus.forwardslash.minus")
                    .frame(maxWidth: .infinity, minHeight: 1, alignment: .trailing)
                    .imageScale(.large)
                    .foregroundStyle(primaryColor)
            }
            
            Stepper("\(rollModifier)", value: $rollModifier, in: -100...100)
                .frame(maxWidth: .infinity)
                .onChange(of: rollModifier, { resetResults() })
                .padding(.horizontal)
            
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
            }
        }.sheet(
            isPresented: $resultsSheetIsVisible,
            content: {
                Button() {
                    resultsSheetIsVisible.toggle()
                } label: {
                    VStack {
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(primaryColor)
                    }
                }.padding(10)
                
                if diceAmount > 0, results.count > 0 {
                    Text("\(showInputMessage()) -> \(sum)")
                        .font(.title2)
                        .foregroundStyle(adjustColor())
                        .padding()
                    
                    Divider()
                    
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
                    
                } else {
                    Text("You haven't rolled any dice.")
                        .font(.headline)
                    
                    Spacer()
                }
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
    }
    
    // MARK: Input Label
    
    var inputLabel: some View {
        Text(results.count > 0 ? showInputMessage() : "...")
            .foregroundStyle(adjustColor())
            .font(.callout)
            .padding(10)
    }
    
    // MARK: Functions

    func diceButton(_ option: Dice) -> some View {
        Button() {
            diceType = option
            results.removeAll()
        } label: {
            Text(option.rawValue)
        }
    }
    
    func colorButton(_ option: Color) -> some View {
        Button() {
            primaryColor = option
        } label: {
            Text(option.description.capitalized)
        }
    }
    
    func flare(rotation: CGFloat, offset: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 0)
            .foregroundStyle(.black)
            .rotationEffect(.degrees(rotation))
            .offset(y: offset)
    }
    
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
