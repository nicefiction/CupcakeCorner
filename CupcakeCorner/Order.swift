// MARK: Order.swift
/**
 SOURCE :
 https://www.hackingwithswift.com/books/ios-swiftui/encoding-an-observableobject-class
 ⭐️ 
 That makes our code fully Codable compliant :
 we’ve effectively bypassed the `@Published` property wrapper ,
 reading and writing the values directly .
 */

import Foundation


/**
 ⭐️
 Encoding an observableobject ,
 STEP 4 of 5 :
 Make the class `final`in order to avoid the `required`keyword .
 */
// class Order: ObservableObject
final class Order: ObservableObject ,
                   Codable {
    
     // ///////////////////
    //  MARK: NESTED TYPES
    /**
     ⭐️
     Encoding an observableobject ,
     STEP 1 of 5 :
     */
    enum CodingKeys: CodingKey {
        
        case cakeTypeIndex
        case quantity
        case isShowingCakeToppings
        case hasExtraFrosting
        case hasSprinkles
        case name
        case streetAddress
        case city
        case zipCode
    }
    
    
    
     // /////////////////
    //  MARK: PROPERTIES
    
    static let cakeTypes: [String] = [
        "Apple Cinnamon" , "Chocolate" , "Vanilla" , "Pear Gember"
    ]
    
    var basePrice: Double = 2.00
    
    
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    
    @Published var cakeTypeIndex: Int = 0
    @Published var quantity: Int = 3
    
    
    @Published var isShowingCakeToppings: Bool = false {
        
        didSet {
            
            if isShowingCakeToppings == false {
                
                self.hasExtraFrosting = false
                self.hasSprinkles = false
            }
        }
    }
    
    @Published var hasExtraFrosting: Bool = false
    @Published var hasSprinkles: Bool = false
    @Published var name: String = ""
    @Published var streetAddress: String = ""
    @Published var city: String = ""
    @Published var zipCode: String = ""
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var hasValidAddress: Bool {
        
        if name.isEmpty
            || streetAddress.isEmpty
            || zipCode.isEmpty {
            return false
            
        } else {
            return true
        }
    }
    
    
    var totalCost: Double {

        var calculatedCost = Double(self.quantity) * basePrice
        // special cakes cost more :
        calculatedCost += (Double(cakeTypeIndex) / 2)
        // + $ 1 per cake for extra frosting :
        calculatedCost += (hasExtraFrosting ? Double(quantity) : 0)
        // + $ 0.50 per cake for sprinkles :
        calculatedCost += (hasSprinkles ? (Double(quantity) / 2) : 0)
        
        return calculatedCost
    }
    
    
    
     // //////////////////////////
    //  MARK: INITIALIZER METHODS
    /**
     ⭐️
     Encoding an observableobject ,
     STEP 3 of 5 :
     */
    // required init(from decoder: Decoder)
    init(from decoder: Decoder)
    throws {
        /**
         Because that method is marked with `throws` ,
         we don’t need to worry about catching any of the errors that are thrown inside
         – we can just use `try` without adding `catch` ,
         knowing that any problems will automatically propagate upwards
         and be handled elsewhere .
         */

        let container = try decoder.container(keyedBy: CodingKeys.self)

        cakeTypeIndex         = try container.decode(Int.self    , forKey : CodingKeys.cakeTypeIndex)
        quantity              = try container.decode(Int.self    , forKey : CodingKeys.quantity)
        isShowingCakeToppings = try container.decode(Bool.self   , forKey : CodingKeys.isShowingCakeToppings)
        hasExtraFrosting      = try container.decode(Bool.self   , forKey : CodingKeys.hasExtraFrosting)
        hasSprinkles          = try container.decode(Bool.self   , forKey : CodingKeys.hasSprinkles)
        name                  = try container.decode(String.self , forKey : CodingKeys.name)
        streetAddress         = try container.decode(String.self , forKey : CodingKeys.streetAddress)
        city                  = try container.decode(String.self , forKey : CodingKeys.city)
        zipCode               = try container.decode(String.self , forKey : CodingKeys.zipCode)
    }
    /**
     We just created a custom initializer for our Order class , `init(from:)` ,
     and Swift wants us to use it everywhere
     – even in places where we just want to create a new empty order
     because the app just started .
     Fortunately ,
     Swift lets us add multiple initializers to a class ,
     so that we can create it in any number of different ways .
     In this situation , that means
     we need to write a new initializer
     that can create an order
     without any data whatsoever
     – it will rely entirely on
     the default property values we assigned :
     */
    /**
     ⭐️
     Encoding an observableobject ,
     STEP 5 of 5 :
     */
    init() {}

    
    
     // //////////////
    //  MARK: METHODS
    /**
     ⭐️
     Encoding an observableobject ,
     STEP 2 of 5 :
     */
    func encode(to encoder: Encoder)
    throws {
        
        var container = encoder.container(keyedBy : CodingKeys.self)
        
        try container.encode(cakeTypeIndex ,         forKey : CodingKeys.cakeTypeIndex)
        try container.encode(quantity ,              forKey : CodingKeys.quantity)
        try container.encode(isShowingCakeToppings , forKey : CodingKeys.isShowingCakeToppings)
        try container.encode(hasExtraFrosting ,      forKey : CodingKeys.hasExtraFrosting)
        try container.encode(hasSprinkles ,          forKey : CodingKeys.hasSprinkles)
        try container.encode(name ,                  forKey : CodingKeys.name)
        try container.encode(streetAddress ,         forKey : CodingKeys.streetAddress)
        try container.encode(city ,                  forKey : CodingKeys.city)
        try container.encode(zipCode ,               forKey : CodingKeys.zipCode)
        /**
         `NOTE` :
         It is worth adding here
         that you can encode your data in any order you want
         – you don’t need to match the order in which properties are declared in your object .
         */
    }
}
