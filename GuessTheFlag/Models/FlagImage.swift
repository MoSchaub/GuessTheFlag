//
//  FlagImage.swift
//  
//
//  Created by Moritz Schaub on 26.01.20.
//

import SwiftUI

struct FlagImage: View {

    @Binding var name: String
    
    var body: some View {
        Image(name)
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: CGFloat(integerLiteral: 15)))
            .shadow(color: .black, radius: 2)
    }
}

struct FlagImage_Previews: PreviewProvider {
    static var previews: some View {
        FlagImage(name: .constant("Germany"))
    }
}
