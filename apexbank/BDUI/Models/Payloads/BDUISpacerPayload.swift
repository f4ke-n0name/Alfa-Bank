import UIKit

struct BDUISpacerPayload: Decodable {
    let height: BDUISpacingToken?
    let width: BDUISpacingToken?
}

extension BDUISpacerPayload {
    func toSpacer() -> UIView {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.backgroundColor = .clear
        return spacer
    }
}