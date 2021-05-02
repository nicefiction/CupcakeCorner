// MARK: CheckoutView.swift
/**
 SOURCE :
 https://www.hackingwithswift.com/books/ios-swiftui/sending-and-receiving-orders-over-the-internet
 ⭐️
 iOS comes with some fantastic functionality for handling networking ,
 and in particular the `URLSession` class makes it surprisingly easy
 to send
 and receive
 data .
 If we combine that with `Codable`
 to convert Swift objects to and from JSON ,
 and `URLRequest` ,
 which lets us configure exactly how data should be sent ,
 we can accomplish great things in about 20 lines of code .
 */

import SwiftUI



struct CheckoutView: View {
    
     // /////////////////////////
    //  MARK: PROPERTY OBSERVERS
    
    @ObservedObject var order: Order
    @State private var alertMessage: String = ""
    @State private var isShowingAlert: Bool = false
    
    
    
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
                    /**
                     ⭐️
                     Handling networking ,
                     STEP 2 of 5
                     */
                    placeOrder()
                }
                .padding()
            }
            .navigationBarTitle(Text("Checkout") ,
                                displayMode : .inline)
            .alert(isPresented : $isShowingAlert) {
                Alert(title : Text("Thank you !") ,
                      message : Text(alertMessage) ,
                      dismissButton : Alert.Button.default(Text("OK")))
            }
        }
    }
    
    
    
     // //////////////
    //  MARK: METHODS
    
    /**
     ⭐️
     Handling networking ,
     STEP 1 of 5
     */
    func placeOrder() {
        /**
         ⭐️ 
         Handling networking ,
         STEP 3 of 5 :
         Convert our current `order` object into
         some JSON data that can be sent .
         */
        guard
            let _encodedOrder = try? JSONEncoder().encode(order)
        else {
            print("Failed to encode the order .")
            return
        }
        
        
        /**
         ⭐️
         Handling networking ,
         STEP 4 of 5 :
         Prepare a `URLRequest` to send our encoded data as JSON .
         So , the next code for `placeOrder()` will be
         (`A`) to create a URLRequest ,
         (`B`) configure it to send JSON data using a HTTP POST ,
         and (`C`) attach our data .
         We need to attach the data in a very specific way
         so that the server can process it correctly ,
         which means
         we need to provide two extra pieces of data
         beyond just our order :
         */
        let urlCupcakes = URL(string: "https://reqres.in/api/cupcakes")! // A
        /**
         `NOTE` :
         Of course, the real question is where to send our request, and I don’t think you really want to set up your own web server in order to follow this tutorial. So, instead we’re going to use a really helpful website called https://reqres.in – it lets us send any data we want, and will automatically send it back. This is a great way of prototyping network code, because you’ll get real data back from whatever you send.
         
         `NOTE`:
         Notice how I added a force unwrap for the `URL(string:)` initializer .
         Creating URLs from strings might fail because you inserted some gibberish ,
         but here I hand-typed the URL
         so I can see it’s always going to be correct
         – there are no string interpolations in there that might cause problems .
         */
        var urlRequest = URLRequest(url : urlCupcakes) // A
        
        /**
         `B.1` The _content type_ of a request
         determines what kind of data is being sent ,
         which affects the way the server treats our data .
         This is specified in what is called a MIME type ,
         which was originally made for sending attachments in emails ,
         and it has several thousand highly specific options :
         */
        urlRequest.setValue("application/json" , forHTTPHeaderField : "Content-Type") // B
        /**
         `B.2` The `HTTP` method of a request
         determines how data should be sent .
         There are several HTTP methods .
         We want to write data here , so we’ll be using `POST`:
         */
        urlRequest.httpMethod = "POST" // B
        
        urlRequest.httpBody = _encodedOrder // C
        
        
        /**
         ⭐️
         Handling networking ,
         STEP 5 of 5 :
         At this point
         we are all set to make our network request ,
         which we’ll do using `URLSession.shared.dataTask()`
         and the URL request we just made .
         */
        URLSession.shared.dataTask(with : urlRequest) { (data: Data? ,
                                                         urlResponse: URLResponse? ,
                                                         error: Error?) in
            // Handle the result here :
            /**
             If something went wrong
             – perhaps because there was no internet connection –
             we’ll just print a message and return :
             */
            guard
                let _data = data
            else {
                print("No data in response : \(error?.localizedDescription ?? "Unknown Error") .")
                return
            }
            /**
             We’ll decode the data that came back ,
             use it to set our confirmation message property ,
             then set `isShowingAlert` to `true`
             so the alert appears .
             If the decoding fails
             – if the server sent back something that wasn’t an order for some reason –
             we’ll just print an error message :
             */
            if
                let _decodedOrder = try? JSONDecoder().decode(Order.self ,
                                                              from : _data) {
                alertMessage = "Your order for \(_decodedOrder.quantity) \(Order.cakeTypes[_decodedOrder.cakeTypeIndex]) cupcakes is on its way ."
                isShowingAlert = true
                
            } else {
                print("Invalid response from the server .")
            }
        }
        .resume()
        /**
         `GOTCHA`: Remember ,
         if you don’t call `resume()` on your data task
         it won’t ever start ,
         which is why I nearly always write the task
         and call resume
         before actually filling in the body .
         */
    }
}

/*
 Convert our current order object into some JSON data that can be sent.
 Prepare a URLRequest to send our encoded data as JSON.
 Run that request and process the response.
 */



struct CheckoutView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        CheckoutView(order : Order())
    }
}
