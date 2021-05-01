// MARK: Order.swift

import Foundation



class Order: ObservableObject {
    
     // /////////////////
    //  MARK: PROPERTIES
    
    static let cakeTypes: [String] = [
        "Apple Cinnamon" , "Chocolate" , "Vanilla" , "Pear Gember"
    ]
    
    
    
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
            && streetAddress.isEmpty
            && zipCode.isEmpty {
            return false
            
        } else {
            return true
        }
    }
}
