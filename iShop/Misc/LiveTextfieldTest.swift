////
////  LiveTextfieldTest.swift
////  iShop
////
////  Created by Chris Filiatrault on 27/5/20.
////  Copyright © 2020 Chris Filiatrault. All rights reserved.
////
//
//import SwiftUI
//
//struct LiveTextfieldTest: View {
//   
//   @State var textfieldValue: String = ""
//   var body: some View {
//      VStack {
//         
//            Text("The current textfield value is: \(textfieldValue)")
//         
//         
//         TextfieldView(textfieldBinding: $textfieldValue)
//         
//      }
//    }
//}
//
//
//
//
//struct TextfieldView: View {
//   
//   @Binding var textfieldBinding: String
//   
//   var body: some View {
//      VStack {
//         
//         TextField("Enter value", text: $textfieldBinding)
//         
//      }
//    }
//}
