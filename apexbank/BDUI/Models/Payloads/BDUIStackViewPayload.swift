import UIKit

struct BDUIStackViewPayload: Decodable {
    let axis: BDUIStackAxisToken?
    let spacing: BDUISpacingToken?
    let alignment: BDUIStackAlignmentToken?
    let distribution: BDUIStackDistributionToken?
}

extension BDUIStackViewPayload {
    func toStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis?.toUIAxis() ?? .vertical
        stackView.spacing = spacing?.toCGFloat() ?? DS.Spacing.m
        stackView.alignment = alignment?.toUIStackViewAlignment() ?? .fill
        stackView.distribution = distribution?.toUIStackViewDistribution() ?? .fill
        return stackView
    }
}
