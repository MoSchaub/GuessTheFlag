//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Moritz Schaub on 14.12.19.
//  Copyright © 2019 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US", "Mazambique", "Hawaii", "Bermuda", "Dominica", "Kyrgyztan"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var rotationAmount = 0.0
    @State private var dimWrongFlags = false
    @State private var attempts: Int = 0
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    var body: some View {
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [.blue,.black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30){
                VStack {
                    Text("Tap the flag of").foregroundColor(.white)
                    Text(countries[correctAnswer]).foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
            
                ForEach(0 ..< 3){ number in
                    Button(action: {
                        self.flagTapped(number)

                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                    }
                    
                    .modifier(Shake(animatableData: CGFloat(self.attempts)))
                    .rotation3DEffect(.degrees(number == self.correctAnswer ? self.rotationAmount : 0), axis: (x: 0, y: 1, z: 0))
                    .opacity(self.dimWrongFlags && number != self.correctAnswer ? 0.25 : 1.0)
                }
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore){
            Alert(title: Text(scoreTitle), message: Text("Your score was  \(self.score)"), dismissButton: .default(Text("OK")){
                self.score = 0
                self.askQuestion()
                })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer{
            scoreTitle = "Correct"
            score += 1
            withAnimation(Animation.default) {
                self.rotationAmount += 360.0
                dimWrongFlags = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.askQuestion()
            }
        } else {
            scoreTitle = "Wrong, thats the flag of \(countries[number])"
            
            withAnimation(.default){
                attempts += 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showingScore = true

                self.askQuestion()
            }
            
        }
        
        
       
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0 ... 2)
        dimWrongFlags = false
        attempts = 0
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FlagImage: View {

    @State var name: String
    
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}
