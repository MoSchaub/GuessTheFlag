//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Moritz Schaub on 26.01.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    /// property tht stores the GameData
    @ObservedObject private var gameData = GameData()
    
    /// spacing between the flags and the text
    /// - Note: The spcing varies for different screen sizes
    @State var spacing : CGFloat = UIScreen.main.bounds.size.height == 568 ? 15 : 35

    var body: some View {
        
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [.blue,.black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all) //Background
            
            if !gameData.showingScore {
                VStack(spacing: spacing){
                    VStack {
                        //text on top
                        Text("Tap the flag of").foregroundColor(.white)
                        Text(gameData.countries[gameData.correctAnswer])
                            .foregroundColor(.white)
                            .font(.headline)
                            .fontWeight(.black)
                            .lineLimit(nil)
                    }
                    
                    //flags
                    ForEach(0 ..< 3){ number in
                        Button(action: {
                            self.gameData.flagTapped(number)
                            
                        }) {
                            FlagImage(flagName: self.$gameData.countries[number])
                                .overlay(self.gameData.showingSolution && number == self.gameData.correctAnswer ? RoundedRectangle(cornerRadius: 15).stroke(Color.green, lineWidth: 2) : RoundedRectangle(cornerRadius: 15).stroke(Color.black, lineWidth: 1))
                                .shadow(color: self.gameData.showingSolution && number == self.gameData.correctAnswer ? .green : .black, radius: 2)
                        }
                        .modifier(Shake(animatableData: CGFloat(self.gameData.shakeAmount)))
                        .rotation3DEffect(.degrees(number == self.gameData.correctAnswer ? self.gameData.rotationAmount : 0), axis: (x: 0, y: 1, z: 0))
                    }
                    
                    //text on bottom
                    Text("Score: \(gameData.score)")
                        .foregroundColor(.white)
                    Spacer()
                    //ad banner
                    GADBannerViewController().frame(width: 320, height: 60, alignment: .center)
                }
            } else {
                VStack(spacing: 20) {
                    //toptext
                    Text("Game Over!").font(.largeTitle).foregroundColor(.white)
                    Text(gameData.scoreTitle).foregroundColor(.white) //Thats the flag of tapped country
                    Text("Your score was \(gameData.score)").font(.largeTitle).foregroundColor(.white)
                    
                    Spacer()
                    //highscore text
                    Text("Highscore: \(gameData.highscore)").font(.largeTitle).foregroundColor(.white)
                    
                    //restart Button
                    Button("Restart"){
                        self.gameData.score = 0
                        self.gameData.showingScore.toggle()
                        self.gameData.askQuestion()
                    }
                    //ad banner
                    GADBannerViewController().frame(width: 320, height: 60, alignment: .center)
                }
            }
        }
        
        
    }
}


struct SmallerDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
