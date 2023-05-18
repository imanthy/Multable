//
//  ContentView.swift
//  Multable
//
//  Created by Anthy Chen on 5/17/23.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        randomizeLeftAndRightNumbers()
    }
    
    @State private var rounds = [5, 10, 15, 20]
    
    @State private var totalRounds = 10
    @State private var correctRounds = 0
    @State private var currentRound = 1
    
    @State private var biggestNumber = 9
    @State private var leftNumber = 2
    @State private var rightNumber = 2
    @State private var userAnswerString = ""
    var correctAnswer: Int {
        leftNumber * rightNumber
    }
    var userAnswer: Int {
        Int(userAnswerString) ?? 0
    }
    
    @State private var showResult = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Rounds: \(currentRound)/\(totalRounds)")
                Spacer()
                Text("Correct: \(correctRounds)")
            }
            
//            SettingsView(rounds: $rounds, totalRounds: $totalRounds, biggestNumber: $biggestNumber)
            Spacer()
            
            HStack {
                Text(String(leftNumber))
                Image(systemName: "multiply")
                Text(String(rightNumber))
            }
            HStack {
                Image(systemName: "equal")
                TextField("Your Answer", text: $userAnswerString)
            }
            Button("OK") {
                checkAnswer()
            }
            
            Spacer()
            
            HStack {
                Button {
                    resetGame()
                } label: {
                    Label("", systemImage: "arrow.counterclockwise")
                }
                Spacer()
                Button {
                    // bring up Settings View
                } label: {
                    Label("", systemImage: "pencil.line")
                }
            }
        }
        .alert("Congratulations", isPresented: $showResult) {
            Button("Reset", role: .destructive, action: resetGame)
            Button("Again", role: .cancel, action: resetGame)
        } message: {
            Text("You got \(correctRounds) / \(totalRounds) correct")
        }
        .padding(30.0)
    } // end of body
    
    func randomizeLeftAndRightNumbers() {
        leftNumber = Int.random(in: 2...biggestNumber)
        rightNumber = Int.random(in: 1...biggestNumber)
    }
    
    func checkAnswer() {
        if userAnswer == correctAnswer {
            correctRounds += 1
        }
        if currentRound < totalRounds {
            currentRound += 1
        } else {
            showResult = true
        }
        randomizeLeftAndRightNumbers()
        userAnswerString = ""
    }
    
    func resetGame() {
        correctRounds = 0
        currentRound = 1
        userAnswerString = ""
        randomizeLeftAndRightNumbers()
    }
    
} // end of ContentView

struct SettingsView: View {
    
    @Binding var rounds: [Int]
    @Binding var totalRounds: Int
    @Binding var biggestNumber: Int
    
    var body: some View {
        NavigationView {
            List {
                Section("Rounds") {
                    Picker("Rounds", selection: $totalRounds) {
                        ForEach(rounds, id: \.self) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section {
                    Stepper("Up to ... \(biggestNumber) x \(biggestNumber) ", value: $biggestNumber, in: 2...15)
                }
                HStack{
                    Button("Done") {}
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        SettingsView(rounds: .constant([5, 10, 15, 20]), totalRounds: .constant(10), biggestNumber: .constant(15))
    }
}
