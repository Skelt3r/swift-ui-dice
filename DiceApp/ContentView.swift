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
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    // MARK: Body
    
    var body: some View {
        VStack {
            diceMenu
            diceAmountInput
            rollModifierInput
            sumLabel
            resultsSheet
            rollButton
            inputLabel
        }
        .font(.largeTitle)
        .padding()
    }
    
    // MARK: Flare
    
    var flare: some View {
        RoundedRectangle(cornerRadius: 0)
            .foregroundStyle(.red)
            .rotationEffect(.degrees(80))
            .offset(y: -470)
    }
    
    // MARK: Header
    
    var header: some View {
        Text("Dice!")
            .font(.largeTitle)
            .fontWeight(.bold)
            .fontDesign(.rounded)
            .foregroundStyle(adjustColor())
    }
    
    // MARK: Dice Menu
    
    var diceMenu: some View {
        HStack {
            Menu {
                menuButton(option: .d20)
                menuButton(option: .d12)
                menuButton(option: .d10)
                menuButton(option: .d8)
                menuButton(option: .d6)
                menuButton(option: .d4)
                menuButton(option: .d100)
            } label: {
                Image(systemName: "dice.fill")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .imageScale(.large)
                    .foregroundColor(.red)
                
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
                    .foregroundStyle(.red)
            }
            
            Stepper("\(diceAmount)", value: $diceAmount, in: 1...100)
                .frame(maxWidth: .infinity)
                .onChange(of: diceAmount, { resetResults() })
                .padding(.horizontal)
            
        }.padding(.top, 20)
    }
    
    // MARK: Roll Modifier Input
    
    var rollModifierInput: some View {
        HStack {
            HStack {
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
                    .foregroundStyle(.red)
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
                .foregroundStyle(.red)
            
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
                    .foregroundStyle(.red)
                
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
                            .foregroundStyle(.red)
                    }
                }.padding(10)
                
                if diceAmount > 0, results.count > 0 {
                    Text(showInputMessage())
                        .font(.headline)
                        .foregroundStyle(adjustColor())
                    
                    Text("Sum: \(sum)")
                        .font(.headline)
                        .padding()
                    
                    Text("Results")
                        .font(.headline)
                        .underline()
                    
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
        } label: {
            Text("Roll dice")
                .foregroundStyle(.black)
                .fontDesign(.monospaced)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle)
        .tint(.red)
        .padding(.top, 40)
    }
    
    // MARK: Input Label
    
    var inputLabel: some View {
        Text(results.count > 0 ? showInputMessage() : " ")
            .foregroundStyle(adjustColor())
            .font(.callout)
            .padding(10)
    }
    
    // MARK: Functions

    func menuButton(option: Dice) -> some View {
        Button() {
            diceType = option
            results.removeAll()
        } label: {
            Text(option.rawValue)
        }
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
