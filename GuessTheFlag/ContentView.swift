//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Jeff Norton on 5/14/22.
//

import SwiftUI

struct ContentView: View {
    let totalRounds = 8
    @State private var currentRound = 1
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var countries = allCountries.shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var currentScore = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var showResults = false
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(currentScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(currentScore)")
        }
        .alert("Results", isPresented: $showResults) {
            Button("Play Again", action: resetGame)
        } message: {
            Text("Your final score is \(currentScore).  Would you like to play again?")
        }
    }
    
    func askQuestion() {
        if currentRound <= totalRounds {
            countries.remove(at: correctAnswer)
            _ = countries.shuffled()
            correctAnswer = Int.random(in: 0...2)
        } else {
            showResults = true
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            currentScore += 1
        } else {
            let countriesThatNeedPrefixOfThe = ["UK", "US"]
            let theirAnswer = countries[number]
            if countriesThatNeedPrefixOfThe.contains(theirAnswer) {
                scoreTitle = "Wrong! That’s the flag of the \(theirAnswer)"
            } else {
                scoreTitle = "Wrong! That’s the flag of \(theirAnswer)"
            }
        }
        
        showingScore = true
        
        currentRound += 1
    }
    
    func resetGame() {
        currentRound = 1
        currentScore = 0
        
        countries = Self.allCountries.shuffled()
        correctAnswer = Int.random(in: 0...2)
        
        showingScore = false
        scoreTitle = ""
        showResults = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
