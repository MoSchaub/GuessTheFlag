//
//  Example.swift
//  GuessTheFlag
//
//  Created by Moritz Schaub on 15.12.19.
//  Copyright © 2019 Moritz Schaub. All rights reserved.
//

import SwiftUI

struct Example: View {
    @State private var showingAlert = false
    
    var body: some View {
        Button("Show Alert"){
            self.showingAlert.toggle()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Hello SwiftUI"), message: Text("This is some detail message"), dismissButton: .default(Text("Ok")))
        }
    }
}

struct Example_Previews: PreviewProvider {
    static var previews: some View {
        Example()
    }
}
