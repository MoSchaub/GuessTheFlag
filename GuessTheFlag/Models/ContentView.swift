//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Moritz Schaub on 26.01.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var gameData = GameData()
    @State var spacing : CGFloat = UIScreen.main.bounds.size.height == 568 ? 15 : 35

    var body: some View {
        
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [.blue,.black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            if !gameData.showingScore {
                VStack(spacing: spacing){
                    VStack {
                        Text("Tap the flag of").foregroundColor(.white)//.padding(.top)
                        Text(gameData.countries[gameData.correctAnswer])
                            .foregroundColor(.white)
                            .font(.headline)
                            .fontWeight(.black)
                            .lineLimit(nil)
                    }
                    
                    ForEach(0 ..< 3){ number in
                        Button(action: {
                            self.gameData.flagTapped(number)
                            
                        }) {
                            FlagImage(name: self.$gameData.countries[number])
                                .overlay(self.gameData.showingSolution && number == self.gameData.correctAnswer ? RoundedRectangle(cornerRadius: 15).stroke(Color.green, lineWidth: 1) : RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 1))
                        }
                        .modifier(Shake(animatableData: CGFloat(self.gameData.attempts)))
                        .rotation3DEffect(.degrees(number == self.gameData.correctAnswer ? self.gameData.rotationAmount : 0), axis: (x: 0, y: 1, z: 0))
                    }
                    
                    Text("Score: \(gameData.score)")
                        .foregroundColor(.white)
                    Spacer()
                    GADBannerViewController().frame(width: 320, height: 60, alignment: .center)
                }
            } else {
                VStack(spacing: 20) {
                    Text("Game Over!").font(.largeTitle).foregroundColor(.white)
                    Text(gameData.scoreTitle).foregroundColor(.white)
                    Text("Your score was \(gameData.score)").font(.largeTitle).foregroundColor(.white)
                    Spacer()
                    Text("Highscore: \(gameData.highscore)").font(.largeTitle).foregroundColor(.white)
                    
                    Button("Restart"){
                        self.gameData.score = 0
                        self.gameData.showingScore.toggle()
                        self.gameData.askQuestion()
                    }
                    GADBannerViewController().frame(width: 320, height: 60, alignment: .center)
                }
            }
        }
        
        
    }
}


struct SmallerDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(spacing: UIScreen.main.bounds.size.height == 568 ? 15 : 35)
    }
}
