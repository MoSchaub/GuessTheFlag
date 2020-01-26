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
    
    @State private var countries : [String] = ["Afghanistan","Albania","Algeria","Andorra","Angola","Argentina","Armenia","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bhutan","Bolivia","Bosnia Herzegovina","Botswana","Brazil","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","CAR","Chad","Chile","China","Colombia","Comoros","DR Congo","Costa Rica","Croatia","Cuba","Cyprus","Czechia","Denmark","Djibouti","Dominica","Dominican Republic","Congo","East Timor","Ecuador","Egypt","El Salvador","Eritrea","Estonia","Ethiopia","Fiji","Finland","France","Gabon","Gambia","Georgia","Germany","Ghana","Greece","Grenada","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Honduras","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy","Ivory Coast","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Kiribati","Kuwait","Kyrgyzstan","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Mauritania","Mauritius","Mexico","Micronesia","Moldova","Monaco","Mongolia","Montenegro","Morocco","Mozambique","Myanmar","Namibia","Nauru","Netherlands","New Zealand","Nicaragua","Niger","Nigeria","North Korea","Norway","Oman","Pakistan","Palau","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Qatar","Romania","Russia","Rwanda","Saint Lucia","Samoa","San Marino","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","South Korea","South Sudan","Spain","Sri Lanka","Sudan","Suriname","Sweden","Syria","Tajikistan","Tanzania","Thailand","Togo","Tonga","Tunisia","Turkey","Turkmenistan","Tuvalu","UAE","Uganda","UK","Ukraine","Uruguay","US","Uzbekistan","Vanuatu","Vatican","Venezuela","Vietnam","Yemen","Zambia","Zimbabwe"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var rotationAmount = 0.0
    @State private var dimWrongFlags = false
    @State private var attempts: Int = 0
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var highscore = UserDefaults.standard.integer(forKey: "highScore")
    
    var body: some View {
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [.blue,.black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            if !showingScore {
                VStack(spacing: 30){
                    VStack {
                        Text("Tap the flag of").foregroundColor(.white).padding(.top)
                        Text(countries[correctAnswer]).foregroundColor(.white)
                            //.font(.largeTitle)
                            .font(.headline)
                            .fontWeight(.black)
                            .lineLimit(nil)
                    }
                
                    ForEach(0 ..< 3){ number in
                        Button(action: {
                            self.flagTapped(number)

                        }) {
                            Image(self.countries[number])
                                .renderingMode(.original)
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.black, lineWidth: 1))
                                .shadow(color: .black, radius: 2)
                        }
                        
                        .modifier(Shake(animatableData: CGFloat(self.attempts)))
                        .rotation3DEffect(.degrees(number == self.correctAnswer ? self.rotationAmount : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity(self.dimWrongFlags && number != self.correctAnswer ? 0.25 : 1.0)
                    }
                    
                    Text("Score: \(score)")
                        .foregroundColor(.white)
                    //Spacer()
                    GADBannerViewController().frame(width: 320, height: 60, alignment: .center).padding(.bottom)
                    
                }
            } else {
                VStack(spacing: 20) {
                    Text("Game Over!").font(.largeTitle).foregroundColor(.white)
                    Text(self.scoreTitle).foregroundColor(.white)
                    Spacer()
                    Text("Highscore: \(self.highscore)").font(.largeTitle).foregroundColor(.white)
                    
                    Button("Restart"){
                        self.score = 0
                        self.showingScore.toggle()
                        self.askQuestion()
                    }
                    GADBannerViewController().frame(width: 320, height: 60, alignment: .center)
                   
                    
                }
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer{
            scoreTitle = "Correct"
            score += 1
            if score > highscore {
                highscore = score
                UserDefaults.standard.set(highscore, forKey: "highScore")
            }
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
