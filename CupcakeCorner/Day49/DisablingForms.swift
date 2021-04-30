// MARK: DisablingForms.swift
/**
 SOURCE :
 https://www.hackingwithswift.com/books/ios-swiftui/validating-and-disabling-forms
 */

import SwiftUI



struct DisablingForms: View {
    
     // ////////////////////////
    //  MARK: PROPERTY WRAPPERS
    
    @State private var username: String = ""
    @State private var email: String = ""
    
    
    
     // //////////////////////////
    //  MARK: COMPUTED PROPERTIES
    
    var isDisabled: Bool {
        
        username.count < 5 || email.count < 5
    }
    
    
    var body: some View {
        
        Form {
            Group {
                Section(header : Text("Username")) {
                    TextField("..." , text : $username)
                        .padding(.vertical)
                }
                Section(header : Text("Email")) {
                    TextField("..." , text : $email)
                        .padding(.vertical)
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
            
            Section {
                Button(action : {
                    print("Account created .")
                } , label : {
                    HStack {
                        Spacer()
                        Text("Create an Account")
                        Spacer()
                    }
                    .padding()
                })
                // .disabled(username.isEmpty || email.isEmpty)
                .disabled(isDisabled)
            }
        }
    }
}





 // ///////////////
//  MARK: PREVIEWS

struct DisablingForms_Previews: PreviewProvider {
    
    static var previews: some View {
        
        DisablingForms()
    }
}
