// MARK: Order.swift

import Foundation



class Order: ObservableObject {
    
    static let cakeTypes: [String] = [
        "Apple Cinnamon" , "Chocolate" , "Vanilla" , "Pear Gember"
    ]
    
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
}
