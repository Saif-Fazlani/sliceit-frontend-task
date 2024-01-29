//
//  Alert.swift
//  Sliceit Frontend Task
//
//  Created by Saifullah Fazlani on 26/01/2024.
//

import SwiftUI

struct AlertViewModifier<Tag: Hashable>: ViewModifier {

    @Binding var alertAppearanceState: AlertAppearanceState<Tag>?

    private let onAction: ((Tag, AlertActionType) -> Void)?

    init(alertAppearanceState: Binding<AlertAppearanceState<Tag>?>, onAction: ((Tag, AlertActionType) -> Void)?) {
        self._alertAppearanceState = alertAppearanceState
        self.onAction = onAction
    }

    @ViewBuilder
    func body(content: Content) -> some View {
        if let wrappedValue = alertAppearanceState, let secondaryAction = wrappedValue.secondaryAction {
            content.alert(isPresented: Binding(get: { (alertAppearanceState?.isShown).orFalse } , set: { alertAppearanceState?.isShown = $0 })) {
                Alert(
                    title: Text(wrappedValue.title),
                    message: wrappedValue.message.flatMap { Text($0) },
                    primaryButton: Alert.Button.default(Text(wrappedValue.primaryAction.title)) {
                        DispatchQueue.main.async {
                            onAction?(wrappedValue.tag, wrappedValue.primaryAction)
                            alertAppearanceState?.isShown = false
                            onAction?(wrappedValue.tag, wrappedValue.primaryAction)
                            alertAppearanceState = nil
                        }
                    },
                    secondaryButton: .cancel(Text(secondaryAction.title)) {
                        DispatchQueue.main.async {
                            alertAppearanceState?.isShown = false
                            onAction?(wrappedValue.tag, secondaryAction)
                            alertAppearanceState = nil
                        }
                    }
                )
            }
        } else if let wrappedValue = alertAppearanceState {
            content.alert(isPresented: Binding(get: { (alertAppearanceState?.isShown).orFalse } , set: { alertAppearanceState?.isShown = $0 })) {
                Alert(
                    title: Text(wrappedValue.title),
                    message: wrappedValue.message.flatMap { Text($0) },
                    dismissButton: .cancel(Text(wrappedValue.primaryAction.title)) {
                        DispatchQueue.main.async {
                            alertAppearanceState?.isShown = false
                            onAction?(wrappedValue.tag, wrappedValue.primaryAction)
                            alertAppearanceState = nil
                        }
                    }
                )
            }
        } else {
            content
        }
    }
}

extension View {
    @ViewBuilder
    func attachingAlert<Tag: Hashable>(state: Binding<AlertAppearanceState<Tag>?>, onAction: ((Tag, AlertActionType) -> Void)? = nil) -> some View {
        self.modifier(AlertViewModifier(alertAppearanceState: state, onAction: onAction))
    }
}

enum AlertActionType: Equatable {
    case confirm(title: String)
    case cancel(title: String)

    static func ==(lhs: AlertActionType, rhs: AlertActionType) -> Bool {
        switch (lhs, rhs) {
        case (.confirm, .confirm), (.cancel, .cancel):
            return true
        default:
            return false
        }
    }

    var title: String {
        switch self {
        case .confirm(let title), .cancel(let title):
            return title
        }
    }

    var isConfirmAction: Bool {
        if case .confirm = self {
            return true
        }
        return false
    }

    var isCancelAction: Bool {
        if case .cancel = self {
            return true
        }
        return false
    }
}

final class AlertAppearanceState<Tag: Hashable>: Identifiable {
    let id: String = UUID().uuidString

    @Published var isShown: Bool = true

    let tag: Tag
    let title: String
    let message: String?

    let primaryAction: AlertActionType
    let secondaryAction: AlertActionType?

    init(
        tag: Tag,
        title: String,
        message: String?,
        primaryAction: AlertActionType,
        secondaryAction: AlertActionType?
    ) {
        self.isShown =  true
        self.tag = tag
        self.title = title
        self.message = message
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
}
