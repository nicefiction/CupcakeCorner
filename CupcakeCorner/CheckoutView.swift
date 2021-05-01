// MARK: CheckoutView.swift

import SwiftUI



struct CheckoutView: View {
    
     // /////////////////////////
    //  MARK: PROPERTY OBSERVERS
    
    @ObservedObject var order: Order
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        GeometryReader { (geometryProxy: GeometryProxy) in
            ScrollView {
                Image("cupcakes")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth : geometryProxy.size.width)
                    .padding()
                Text("Your total order is $ \(order.totalCost , specifier : "%g")")
                Button("Place Order") {
                    print("Placing the order .")
                }
                .padding()
            }
            .navigationBarTitle(Text("Checkout") ,
                                displayMode : .inline)
        }
    }
}





struct CheckoutView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        CheckoutView(order : Order())
    }
}
