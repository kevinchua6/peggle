// File: KeyboardResponder.swift
// Project: PushContentUp
// Created at 24.01.20 by BLCKBIRDS
// Visit www.BLCKBIRDS.com for more.
// Adapted from: https://blckbirds.com/post/prevent-the-keyboard-from-hiding-swiftui-view/

import SwiftUI

class KeyboardResponder: ObservableObject {

    @Published var currentHeight: CGFloat = 0
    @Published var isKeyboardOpen = false

    var myCenter: NotificationCenter

    init(center: NotificationCenter = .default) {
        myCenter = center
        myCenter.addObserver(
            self, selector: #selector(keyBoardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        myCenter.addObserver(
            self, selector: #selector(keyBoardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize =
            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            withAnimation {
               currentHeight = keyboardSize.height
            }
            isKeyboardOpen = true
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        withAnimation {
           currentHeight = 0
        }
        isKeyboardOpen = false
    }
}
