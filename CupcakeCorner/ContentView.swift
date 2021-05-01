// MARK: ContentView.swift

import SwiftUI



struct ContentView: View {
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    
    @ObservedObject var order: Order = Order()
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        NavigationView {
            Form {
                Section(header : Text("cake type")) {
                    Picker("Flavor :" ,
                           selection : $order.cakeTypeIndex) {
                        ForEach(0..<Order.cakeTypes.count) {
                            Text(Order.cakeTypes[$0])
                        }
                    }
                }
                Section(header : Text("order quantity")) {
                    Stepper(value : $order.quantity ,
                            in : 3...5) {
                        Text("\(order.quantity) cupcakes")
                    }
                }
                Section(header : Text("extras")) {
                    Toggle(isOn : $order.isShowingCakeToppings ,
                           label : {
                        Text("Show Cake toppings .")
                    })
                    
                    if order.isShowingCakeToppings {
                        Toggle(isOn : $order.hasExtraFrosting ,
                               label : {
                            Text("Frosting")
                        })
                        Toggle(isOn : $order.hasSprinkles ,
                               label : {
                            Text("Sprinkles")
                        })
                    }
                }
                Section(header : Text("delivery details")) {
                    NavigationLink("Address" ,
                                   destination : AddressView(order : order))
                }
            }
            .navigationBarTitle(Text("Cupcake Corner"))
        }
    }
}





 // ///////////////
//  MARK: PREVIEWS

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ContentView().previewDevice("")
    }
}
