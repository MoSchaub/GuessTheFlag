//
//  GameData.swift
//  GuessTheFlag
//
//  Created by Moritz Schaub on 26.01.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI

class GameData: ObservableObject{
    @Published var countries : [String] = ["Afghanistan","Albania","Algeria","Andorra","Angola","Argentina","Armenia","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bhutan","Bolivia","Bosnia Herzegovina","Botswana","Brazil","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","CAR","Chad","Chile","China","Colombia","Comoros","DR Congo","Costa Rica","Croatia","Cuba","Cyprus","Czechia","Denmark","Djibouti","Dominica","Dominican Republic","Congo","East Timor","Ecuador","Egypt","El Salvador","Eritrea","Estonia","Ethiopia","Fiji","Finland","France","Gabon","Gambia","Georgia","Germany","Ghana","Greece","Grenada","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Honduras","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy","Ivory Coast","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Kiribati","Kuwait","Kyrgyzstan","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Mauritania","Mauritius","Mexico","Micronesia","Moldova","Monaco","Mongolia","Montenegro","Morocco","Mozambique","Myanmar","Namibia","Nauru","Netherlands","New Zealand","Nicaragua","Niger","Nigeria","North Korea","Norway","Oman","Pakistan","Palau","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Qatar","Romania","Russia","Rwanda","Saint Lucia","Samoa","San Marino","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","South Korea","South Sudan","Spain","Sri Lanka","Sudan","Suriname","Sweden","Syria","Tajikistan","Tanzania","Thailand","Togo","Tonga","Tunisia","Turkey","Turkmenistan","Tuvalu","UAE","Uganda","UK","Ukraine","Uruguay","US","Uzbekistan","Vanuatu","Vatican","Venezuela","Vietnam","Yemen","Zambia","Zimbabwe"].shuffled()
    @Published var correctAnswer = Int.random(in: 0...2)
    
    @Published var rotationAmount = 0.0
    @Published var showingSolution = false
    @Published var attempts: Int = 0
    
    @Published var showingScore = false
    @Published var scoreTitle = ""
    @Published var score = 0
    @Published var highscore = UserDefaults.standard.integer(forKey: "highScore")
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer{
            score += 1
            if score > highscore {
                highscore = score
                UserDefaults.standard.set(highscore, forKey: "highScore")
            }
            withAnimation(Animation.default) {
                self.rotationAmount += 360.0
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.askQuestion()
            }
        } else {
            scoreTitle = "Wrong, that was the flag of \(countries[number])"
            
            withAnimation(.default){
                attempts += 1
                showingSolution = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showingScore = true
            }
            
        }
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0 ... 2)
        showingSolution = false
        attempts = 0
    }
}
