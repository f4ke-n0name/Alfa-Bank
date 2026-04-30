import UIKit

struct BDUITextFieldPayload: Decodable {
    let placeholder: String
    let keyboardType: BDUIKeyboardTypeToken?
    let isSecure: Bool?
    let onChange: BDUIAction?
    let onReturn: BDUIAction?
}

extension BDUITextFieldPayload {
    func toTextField() -> DSTextField {
        let textField = DSTextField(placeholder: placeholder)
        textField.keyboardType = keyboardType?.toUIKeyboardType() ?? .default
        textField.isSecureTextEntry = isSecure ?? false
        return textField
    }
}
