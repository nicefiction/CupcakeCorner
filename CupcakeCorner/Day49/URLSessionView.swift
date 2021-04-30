// MARK: URLSessionView.swift
/**
 SOURCE :
 https://www.hackingwithswift.com/books/ios-swiftui/sending-and-receiving-codable-data-with-urlsession-and-swiftui
 
 iOS gives us built-in tools for sending and receiving data from the internet ,
 and if we combine it with Codable support
 then it is possible to convert Swift objects to JSON for sending ,
 then receive back JSON to be converted back to Swift objects .
 Even better , when the request completes
 we can immediately assign its data to properties in SwiftUI views ,
 causing our user interface to update .
 ( ... )
 We are going to ask the iTunes API
 to send us a list of all the songs by Taylor Swift ,
 then use JSONDecoder
 to convert those results
 into an array of Result instances .
 */

import SwiftUI



struct Result: Codable {
    
    var trackID: Int
    var trackName: String
    var collectionName: String
}



struct Response: Codable {
    
    var results: [Result]
}



struct URLSessionView: View {
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    
    @State private var results = Array<Result>()
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var body: some View {
        
        // List(results , id : \.trackID) { result in // PAUL HUDSON
        List {
            ForEach(results , id : \.trackID) { (result: Result) in
                VStack(alignment : .leading) {
                    Text(result.trackName)
                        .font(.headline)
                    Text(result.collectionName)
                        .font(.subheadline)
                }
            }
        }
        /**
         `STEP 2`
         We want that to be run as soon as our List is shown :
         */
        .onAppear(perform : loadData)
    }
    
    
    
     // //////////////
    //  MARK: METHODS
    
    /**
     `STEP 1`
     */
    func loadData() {
        /**
         `STEP 3`
         Creating the `URL` we want to read :
         */
        guard
            let _url = URL(string : "https://itunes.apple.com/search?term=taylor+swift&entity=song")
        else {
            print("Invalid URL")
            return
        }
        /**
         `STEP 4`
         Wrapping that in a `URLRequest` ,
         which allows us to configure _how_ the `URL` should be accessed :
         */
        let request = URLRequest(url : _url)
        /**
         `NOTE` :
         This is where we would add different customizations
         to control the way the `URL` was loaded ,
         but here we don’t need anything
         so this is just a single line of code .
         */
        /**
         `STEP 5`
         Create and start a networking task from that URL request .
         `5.1` `URLSession` is the iOS class responsible for managing network requests .
         `5.2`  You can make your own session if you want to ,
         but it is very common to use the `shared` session that iOS creates for us to use .
         `5.3` `dataTask(with:)`creates a networking task from a `URLRequest`
         and a closure that should be run when the task completes .
         `5.4` `data` is whatever data was returned from the request .
         `5.5` `response`  is a description of the data ,
         which might include what type of data it is ,
         how much was sent ,
         whether there was a status code , and more .
         `5.6` `error` is the error that occurred .
         `5.7` `GOTCHA`:
         `.resume()`
         _Without_ it
         the request does nothing
         and you’ll be staring at a blank screen .
         But _with_ it
         the request starts immediately ,
         and control gets handed over to the system
         – it will automatically run in the background ,
         and won’t be destroyed even after our method ends .
         */
        URLSession.shared.dataTask(with : request) { data , response , error in
            /**
             `STEP 6`
             Handle the result of that networking task .
             */
            if let _data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self ,
                                                                   from : _data) {
                    // we have good data – go back to the main thread
                    /**
                     `DispatchQueue.main.async()` takes a closure of work to perform ,
                     and sends it off to the main thread for execution .
                     The “async” part is short for “asynchronous” ,
                     which means our own background work won’t wait for the closure to be run ;
                     we just add it to the queue and carry on working in the background .
                     */
                    DispatchQueue.main.async {
                        // update our UI
                        self.results = decodedResponse.results
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
        }.resume()
    }
}





 // ///////////////
//  MARK: PREVIEWS

struct URLSessionView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        URLSessionView().previewDevice("iPhone 12 Pro")
    }
}
