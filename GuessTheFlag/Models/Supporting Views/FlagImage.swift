//
//  FlagImage.swift
//  
//
//  Created by Moritz Schaub on 26.01.20.
//

import SwiftUI

///roundedRectangle of a Flag whose name you hand in
struct FlagImage: View {

    ///prpoerty that stores the name of the country whose flag is displayed
    @Binding var flagName: String
    
    var body: some View {
        Image(flagName)
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: CGFloat(integerLiteral: 15)))
    }
}

struct FlagImage_Previews: PreviewProvider {
    static var previews: some View {
        FlagImage(flagName: .constant("Germany"))
    }
}
