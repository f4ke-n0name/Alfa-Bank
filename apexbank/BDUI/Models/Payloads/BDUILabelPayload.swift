import UIKit

struct BDUILabelPayload: Decodable {
    let text: String
    let textStyle: BDUITextStyleToken?
    let textColor: BDUIColorToken?
    let textAlignment: BDUILabelAlignmentToken?
}

extension BDUILabelPayload {
    func toLabel() -> UILabel {
        let label = UILabel()
        label.text = text
        label.apply(textStyle?.toTextStyle() ?? .body)
        if let textColor {
            label.textColor = textColor.toDSColor()
        }
        label.textAlignment = textAlignment?.toNSTextAlignment() ?? .natural
        return label
    }
}
