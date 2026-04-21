import UIKit

extension UIFont {
    static func customOrSystem(name: String, size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let candidateNames: [String] = [
            name,
            name.replacingOccurrences(of: " ", with: ""),
            name.replacingOccurrences(of: " ", with: "-")
        ]

        for candidate in candidateNames {
            if let font = UIFont(name: candidate, size: size) {
                return font
            }
        }

        return .systemFont(ofSize: size, weight: weight)
    }
}
