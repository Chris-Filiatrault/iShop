//
//  CustomTextField.swift
//  iShop
//
//  Created by Chris Filiatrault on 24/8/20.
//  Copyright © 2020 Chris Filiatrault. All rights reserved.
//

import SwiftUI


struct CustomTextField: View {
   @EnvironmentObject var globalVariables: GlobalVariableClass
   private var placeholder: String
   var focusTextfieldCursor: Bool
   private var onBeginEditing: (() -> Void)?
   private var onCommit: (() -> Void)?
   @State private var viewHeight: CGFloat = 40 //start with one line
   @State private var shouldShowPlaceholder = false
   @Binding private var text: String

   private var internalText: Binding<String> {
      Binding<String>(get: { self.text } ) {
         self.text = $0
         self.shouldShowPlaceholder = $0.isEmpty
      }
   }
   
   var placeholderView: some View {
      Group {
         
         // Placeholder for ItemList textfield
         if placeholder == "Add item" && globalVariables.itemInTextfield == "" {
            HStack(alignment: .center) {
               Text(placeholder)
                  .foregroundColor(.gray)
                  .padding(.leading, 8)

               Spacer()
            }
         }
            
         // Placeholder for other textfields
         else if placeholder != "Add item" && shouldShowPlaceholder {
            HStack(alignment: .center) {
               Text(placeholder)
                  .foregroundColor(.gray)
                  .padding(.leading, 8)

               Spacer()
            }
         }
      }
   }
   
   init (_ placeholder: String = "", text: Binding<String>, focusTextfieldCursor: Bool, onCommit: (() -> Void)? = nil, onBeginEditing: (() -> Void)? = nil) {
      self.placeholder = placeholder
      self.onCommit = onCommit
      self._text = text
      self.onBeginEditing = onBeginEditing
      self.focusTextfieldCursor = focusTextfieldCursor
      self._shouldShowPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
   }

   var body: some View {
      UITextViewWrapper(text: self.internalText, calculatedHeight: $viewHeight, onCommit: onCommit, onBeginEditing: onBeginEditing, focusTextfieldCursor: focusTextfieldCursor)
         .frame(minHeight: viewHeight, maxHeight: viewHeight)
         .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray))
         .background(
            ZStack {
            RoundedRectangle(cornerRadius: 5).foregroundColor(.white)
            placeholderView
            }
         )
      }

}


// UIViewRepresentable view for UITextField
struct UITextViewWrapper: UIViewRepresentable {
   @EnvironmentObject var globalVariables: GlobalVariableClass
   typealias UIViewType = UITextView

   @Binding var text: String
   @Binding var calculatedHeight: CGFloat
   var onCommit: (() -> Void)?
   var onBeginEditing: (() -> Void)?
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

      if nil != onCommit {
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
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
         uiView.becomeFirstResponder()
         }
         
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
      return Coordinator(text: $text, height: $calculatedHeight, onCommit: onCommit, onBeginEditing: onBeginEditing)
   }


   // Coordinator
   final class Coordinator: NSObject, UITextViewDelegate {
      var text: Binding<String>
      var calculatedHeight: Binding<CGFloat>
      var onCommit: (() -> Void)?
      var onBeginEditing: (() -> Void)?
      

      init(text: Binding<String>, height: Binding<CGFloat>, onCommit: (() -> Void)? = nil, onBeginEditing: (() -> Void)? = nil) {
         self.text = text
         self.calculatedHeight = height
         self.onCommit = onCommit
         self.onBeginEditing = onBeginEditing
      }

      func textViewDidChange(_ uiView: UITextView) {
         text.wrappedValue = uiView.text
         UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
      }

      func textViewDidBeginEditing(_ textView: UITextView) {
         if let onBeginEditing = self.onBeginEditing {
            onBeginEditing()
         }
      }

      func textViewDidEndEditing(_ textView: UITextView) {
         // Can run code on finishing editing by creating a didFinishEditing variable in the same way as didBeginEditing
      }

      func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         if let onCommit = self.onCommit, text == "\n" {
            onCommit()
            return false
         }
         return true
      }
   }

}


