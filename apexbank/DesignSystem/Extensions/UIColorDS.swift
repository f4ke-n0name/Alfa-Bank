import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        hexString = hexString.replacingOccurrences(of: "#", with: "")
        hexString = hexString.replacingOccurrences(of: "0X", with: "")

        if hexString.count == 6 {
            hexString += "FF"
        }

        guard hexString.count == 8, let value = UInt64(hexString, radix: 16) else {
            self.init(white: 0, alpha: 0)
            return
        }

        let r = CGFloat((value & 0xFF000000) >> 24) / 255.0
        let g = CGFloat((value & 0x00FF0000) >> 16) / 255.0
        let b = CGFloat((value & 0x0000FF00) >> 8) / 255.0
        let a = CGFloat(value & 0x000000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: a)
    }

    static func dynamicLight(_ light: UIColor, dark: UIColor) -> UIColor {
        UIColor { traits in
            traits.userInterfaceStyle == .dark ? dark : light
        }
    }
}
