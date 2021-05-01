// MARK: AddressView.swift

import SwiftUI



struct AddressView: View {
    
     // /////////////////////////
    //  MARK: PROPERTY OBSERVERS
    
    @ObservedObject var order: Order
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        Form {
            Section(header : Text("address")) {
                TextField("Name :" ,
                          text: $order.name)
                TextField("Street name and house number :" ,
                          text : $order.streetAddress)
                TextField("City :" ,
                          text : $order.city)
                TextField("ZIP code :" ,
                          text : $order.zipCode)
            }
            Section {
                NavigationLink(destination : CheckoutView(order : order)) {
                    Text("Check out")
                }
            }
            .disabled(order.hasValidAddress == false)
        }
        .navigationBarTitle("Delivery Details" ,
                            displayMode : .inline)
    }
}





 // ///////////////
//  MARK: PREVIEWS

struct AddressView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        AddressView(order : Order())
    }
}
