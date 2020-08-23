//
//  ContentView.swift
//  iShop
//
//  Created by Chris Filiatrault on 15/8/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI

//struct ContentView: View {
//
//   static var textfieldValue: String = ""
//   static var textfieldValueBinding = Binding<String>(get: { textfieldValue }, set: { textfieldValue = $0 } )
//   var body: some View {
//
//      ZStack {
//         Color(.lightGray)
//
//         VStack {
//
//            MultilineTextField("Add item", text: ContentView.textfieldValueBinding, onCommit: {
//               print("Commit")
//            })
//         }
//         .padding()
//
//      }
//
//   }
//}


struct MultilineTextField: View {
   
   private var placeholder: String
   private var onCommit: (() -> Void)?
   @State private var viewHeight: CGFloat = 40 //start with one line
   @State private var shouldShowPlaceholder = false
   @Binding private var text: String
   var focusTextfieldCursor: Bool
   
   private var internalText: Binding<String> {
      Binding<String>(get: { self.text } ) {
         self.text = $0
         self.shouldShowPlaceholder = $0.isEmpty
      }
   }
   
   var body: some View {
      UITextViewWrapper(text: self.internalText, calculatedHeight: $viewHeight, onDone: onCommit, focusTextfieldCursor: focusTextfieldCursor)
         .frame(minHeight: viewHeight, maxHeight: viewHeight)
         .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
         .background(
            ZStack {
            RoundedRectangle(cornerRadius: 5).foregroundColor(.white)
            placeholderView
            }
         )
      }
   
   
   var placeholderView: some View {
      Group {
         if shouldShowPlaceholder {
            HStack(alignment: .center) {
               Text(placeholder)
                  .foregroundColor(.gray)
                  .padding(.leading, 8)
               
               Spacer()
            }
         }
      }
   }
   
   init (_ placeholder: String = "", text: Binding<String>, onCommit: (() -> Void)? = nil, focusTextfieldCursor: Bool) {
      self.placeholder = placeholder
      self.onCommit = onCommit
      self._text = text
      self.focusTextfieldCursor = focusTextfieldCursor
      self._shouldShowPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
   }
   
}


// UIViewRepresentable view for UITextField
struct UITextViewWrapper: UIViewRepresentable {
   typealias UIViewType = UITextView
   
   @Binding var text: String
   @Binding var calculatedHeight: CGFloat
   var onDone: (() -> Void)?
   var focusTextfieldCursor: Bool
   
   func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
      let textField = UITextView()
      textField.delegate = context.coordinator
      textField.isEditable = true
      textField.font = UIFont.preferredFont(forTextStyle: .body)
      textField.isSelectable = true
      textField.isUserInteractionEnabled = true
      textField.isScrollEnabled = false
      textField.backgroundColor = UIColor.clear
      
      if nil != onDone {
         textField.returnKeyType = .done
      }
      
      textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      return textField
   }
   
   func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
      if uiView.text != self.text {
         uiView.text = self.text
      }
      if uiView.window != nil, !uiView.isFirstResponder && focusTextfieldCursor == true {
         uiView.becomeFirstResponder()
      }
      UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
   }
   
   // Calculate height
   private static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
      let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
      if result.wrappedValue != newSize.height {
         DispatchQueue.main.async {
            result.wrappedValue = newSize.height // call in next render cycle.
         }
      }
   }
   
   
   // makeCoordinator
   func makeCoordinator() -> Coordinator {
      return Coordinator(text: $text, height: $calculatedHeight, onDone: onDone)
   }
   
   
   // Coordinator
   final class Coordinator: NSObject, UITextViewDelegate {
      var text: Binding<String>
      var calculatedHeight: Binding<CGFloat>
      var onDone: (() -> Void)?
      
      init(text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil) {
         self.text = text
         self.calculatedHeight = height
         self.onDone = onDone
      }
      
      func textViewDidChange(_ uiView: UITextView) {
         text.wrappedValue = uiView.text
         UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
      }
      
      func textViewDidBeginEditing(_ textView: UITextView) {
         print("Began editing")
      }
      
      func textViewDidEndEditing(_ textView: UITextView) {
         print("End editing")
      }
      
      func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         if let onDone = self.onDone, text == "\n" {
            textView.resignFirstResponder()
            onDone()
            return false
         }
         return true
      }
   }
   
}




//struct ContentView_Previews: PreviewProvider {
//   static var previews: some View {
//      ContentView()
//   }
//}
