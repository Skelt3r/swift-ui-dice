//
//  ContentView.swift
//  DiceApp
//
//  Created by Chris Allen on 6/18/24.
//

import SwiftUI

struct ContentView: View {
    @State private var diceType: Dice = .d20
    @State private var diceAmount: Int = 1
    @State private var rollModifier: Int = 0
    @State private var results: [Result] = []
    @State private var sum: Int = 0
    @State private var sheetIsVisible: Bool = false
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    var body: some View {
        VStack {
            diceMenu
            diceAmountInput
            rollModifierInput
            sumLabel
            resultSheet
            rollButton
            inputLabel
        }
        .font(.largeTitle)
    }
    
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
                    .foregroundStyle(adjustFontColor())
                    .onChange(of: diceType, { resetResults() })
                    .padding(.horizontal)
            }
        }
    }
    
    var diceAmountInput: some View {
        HStack {
            Image(systemName: "number")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .imageScale(.large)
                .foregroundStyle(.red)
            
            Stepper("\(diceAmount)", value: $diceAmount, in: 1...100)
                .frame(maxWidth: .infinity)
                .onChange(of: diceAmount, { resetResults() })
                .padding(.horizontal)
        }
        .padding(.top, 20)
    }
    
    var rollModifierInput: some View {
        HStack {
            Image(systemName: "plus.forwardslash.minus")
                .frame(maxWidth: .infinity, minHeight: 1, alignment: .trailing)
                .imageScale(.large)
                .foregroundStyle(.red)
            
            Stepper("\(rollModifier)", value: $rollModifier, in: -100...100)
                .frame(maxWidth: .infinity)
                .onChange(of: rollModifier, { resetResults() })
                .padding(.horizontal)
        }
        .padding(.top, 30)
    }
    
    var sumLabel: some View {
        HStack {
            Image(systemName: "sum")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .imageScale(.large)
                .foregroundStyle(.red)
            
            Text(sum.description)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
        .padding(.top, 30)
    }
    
    var resultSheet: some View {
        Button {
            sheetIsVisible.toggle()
        } label: {
            HStack {
                Image(systemName: "list.number")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .imageScale(.large)
                    .foregroundStyle(.red)
                
                Text("...")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(adjustFontColor())
                    .padding(.horizontal)
            }
        }
        .sheet(isPresented: $sheetIsVisible, content: {
            Button() {
                sheetIsVisible.toggle()
            } label: {
                VStack {
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(.red)
                }
            }
            .padding(10)
            
            if diceAmount > 0, results.count > 0 {
                Text(showInputMessage())
                    .font(.headline)
                
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
        })
        .padding(.top)
    }
    
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
        .padding(.top, 20)
    }
    
    var inputLabel: some View {
        Text(results.count > 0 ? showInputMessage() : " ")
            .foregroundStyle(.black)
            .font(.callout)
            .padding(10)
    }
    
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
    
    func adjustFontColor() -> Color {
        colorScheme == .dark ? Color.white : Color.black
    }
}

#Preview {
    ContentView()
}
