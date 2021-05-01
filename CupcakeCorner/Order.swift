// MARK: Order.swift

import Foundation



class Order: ObservableObject {
    
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
}
