//
//  GameData.swift
//  GuessTheFlag
//
//  Created by Moritz Schaub on 26.01.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

///class that stores the games properties
class GameData: ObservableObject{
    
    ///shuffled array with the names of all flags.
    @Published var countries : [String] = ["Afghanistan","Albania","Algeria","Andorra","Angola","Argentina","Armenia","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bhutan","Bolivia","Bosnia Herzegovina","Botswana","Brazil","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","CAR","Chad","Chile","China","Colombia","Comoros","DR Congo","Costa Rica","Croatia","Cuba","Cyprus","Czechia","Denmark","Djibouti","Dominica","Dominican Republic","Congo","East Timor","Ecuador","Egypt","El Salvador","Eritrea","Estonia","Ethiopia","Fiji","Finland","France","Gabon","Gambia","Georgia","Germany","Ghana","Greece","Grenada","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Honduras","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy","Ivory Coast","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Kiribati","Kuwait","Kyrgyzstan","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Mauritania","Mauritius","Mexico","Micronesia","Moldova","Monaco","Mongolia","Montenegro","Morocco","Mozambique","Myanmar","Namibia","Nauru","Netherlands","New Zealand","Nicaragua","Niger","Nigeria","North Korea","Norway","Oman","Pakistan","Palau","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Qatar","Romania","Russia","Rwanda","Saint Lucia","Samoa","San Marino","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","South Korea","South Sudan","Spain","Sri Lanka","Sudan","Suriname","Sweden","Syria","Tajikistan","Tanzania","Thailand","Togo","Tonga","Tunisia","Turkey","Turkmenistan","Tuvalu","UAE","Uganda","UK","Ukraine","Uruguay","US","Uzbekistan","Vanuatu","Vatican","Venezuela","Vietnam","Yemen","Zambia","Zimbabwe"].shuffled()
    
    ///randomly generated integer between 0 and 2 that reflects the correct flag
    @Published var correctAnswer = Int.random(in: 0...2)
    
    ///property to track the spinning animation
    @Published var rotationAmount = 0.0
    
    ///property to track wether the correct flag has a green border
    @Published var showingSolution = false
    
    ///property to track the shake animation
    @Published var shakeAmount: Int = 0
    
    ///property to track wether the score screen is shown
    @Published var showingScore = false
    
    ///the title for the score screen
    @Published var scoreTitle = ""
    
    ///the score of the current game
    @Published var score = 0
    
    ///the highscore
    @Published var highscore = UserDefaults.standard.integer(forKey: "highScore")
    
    
    ///method that handles the tap on the Flag, checks if the tapped flag is the correct flag and gives points or stops the game
    /// - Parameter number: the index of the country, that belongs to the flag, in the countries array
    ///    number must be between 0 and 2
    func flagTapped(_ number: Int) {
        //check if the tapped flag is the correct flag
        if number == correctAnswer{
            score += 1
            
            if score > highscore {
                //save highscore
                highscore = score
                UserDefaults.standard.set(highscore, forKey: "highScore")
            }
            //spinning Animation
            withAnimation(Animation.default) {
                self.rotationAmount += 360.0
                
            }
            // 0.2s delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                //reshuffling
                self.askQuestion()
            }
        } else {
            //false
            scoreTitle = "Wrong, that was the flag of \(countries[number])"
            
            //shaking and enabling green border around the right flag
            withAnimation(.default){
                shakeAmount += 1
                showingSolution = true
            }
            // 1s delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                //show score screen
                self.showingScore = true
            }
            
        }
    }
    
    ///reshuffles
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0 ... 2)
        showingSolution = false
        shakeAmount = 0
    }
}
