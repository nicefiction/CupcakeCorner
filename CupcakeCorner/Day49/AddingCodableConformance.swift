// MARK: AddingCodableConformance.swift
/**
 SOURCE :
 https://www.hackingwithswift.com/books/ios-swiftui/adding-codable-conformance-for-published-properties
 
 If all the properties of a type already conform to `Codable`,
 then the type itself can conform to `Codable` with no extra work
 – Swift will synthesize the code required to archive and unarchive your type as needed . However , this doesn’t work when we use property wrappers
 such as `@Published` ,
 which means conforming to `Codable` requires some extra work on our behalf .
 To fix this , we need to implement `Codable` conformance ourself .
 This will fix the `@Published` encoding problem ,
 but is also a valuable skill to have elsewhere too
 because it lets us control exactly what data is saved and how it happens .
 */

import SwiftUI


final class User: ObservableObject ,
                  Codable {
    
    // var name: String = "Dorothy Gale"
    /**
     That will compile just fine ,
     because String conforms to Codable out of the box .
     However , if we make it `@Published`
     then the code no longer compiles :
     */
    @Published var name: String = "Dorothy Gale"

    /**
     `STEP 1 of 3` : Tell Swift which properties should be loaded and saved .
     */
    enum CodingKeys: CodingKey {
        case name
    }
    
    /**
     `STEP 2 of 3` : Create a custom initializer that will be given some sort of container ,
     and use that to read values for all our properties .
     */
    /**
     NOTE :
     Anyone who subclasses our `User` class
     must override this initializer with a custom implementation
     to make sure they add their own values.
     We mark this using the `required` keyword : `required init` .
     An alternative is to mark this `class` as `final `
     so that subclassing isn’t allowed ,
     in which case we’d write final `class User `
     and drop the `required` keyword entirely .
     */
    // required init(from decoder: Decoder)
    init(from decoder: Decoder)
    throws {
        
        /**
         This means
         “this data should have a container
         where the keys match
         whatever cases we have in our CodingKeys enum :
         */
        let container = try decoder.container(keyedBy : CodingKeys.self)
        /**
         Finally , we can read values directly from that container
         by referencing cases in our enum .
         This provides really strong safety in two ways :
         1. we are making it clear we expect to read a string ,
         so if `name` gets changed to an integer
         the code will stop compiling ;
         and 2. we are also using a `case` in our `CodingKeys enum` rather than a `String`,
         so there is no chance of typos :
         */
        name = try container.decode(String.self ,
                                    forKey : .name)
    }
    
    /**
     `STEP 3 of 3`:
     We have made an initializer
     so that Swift can decode data into this type ,
     but now we need to tell Swift how to encode this type
     – how to archive it ready to write to JSON :
     */
    func encode(to encoder: Encoder)
    throws {
        /**
         This step is pretty much the reverse of the initializer we just wrote :
         we get handed an `Encoder` instance to write to ,
         ask it to make a container using our `CodingKeys enum` for keys ,
         then write our values attached to each key :
         */
        var container = encoder.container(keyedBy : CodingKeys.self)
        try container.encode(name ,
                             forKey : .name)
    }
    
    /**
     And now our code compiles :
     Swift knows what data we want to write ,
     knows how to convert some encoded data into our object’s properties ,
     and knows how to convert our object’s properties into some encoded data .
     */
}



struct AddingCodableConformance: View {
    
    var body: some View {
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}





 // //////////////
// MARK: PREVIEWS

struct AddingCodableConformance_Previews: PreviewProvider {
    
    static var previews: some View {
        
        AddingCodableConformance().previewDevice("iPhone 12 Pro")
    }
}
