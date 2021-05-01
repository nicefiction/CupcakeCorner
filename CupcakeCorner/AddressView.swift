// MARK: AddressView.swift

import SwiftUI



struct AddressView: View {
    
     // /////////////////////////
    //  MARK: PROPERTY OBSERVERS
    
    @ObservedObject var order: Order
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        Text("Hello, World!")
    }
}





 // ///////////////
//  MARK: PREVIEWS

struct AddressView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        AddressView(order : Order())
    }
}
