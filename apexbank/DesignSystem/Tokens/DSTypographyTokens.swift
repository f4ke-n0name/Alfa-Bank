import UIKit



enum DSTypography {
    static func title1() -> UIFont {
        UIFont.customOrSystem(name: "Audiowide-Regular", size: 32, weight: .regular)
    }

    static func title2() -> UIFont {
        UIFont.customOrSystem(name: "Gloock-Regular", size: 14, weight: .regular)
    }

    static func body() -> UIFont {
        UIFont.customOrSystem(name: "HostGrotesk-Medium", size: 16, weight: .medium)
    }

    static func button() -> UIFont {
        UIFont.customOrSystem(name: "HostGrotesk-Bold", size: 16, weight: .bold)
    }

    static func caption() -> UIFont {
        UIFont.customOrSystem(name: "HostGrotesk-Bold", size: 12, weight: .bold)
    }

    static func text12() -> UIFont {
        UIFont.customOrSystem(name: "HostGrotesk-Regular", size: 12, weight: .medium)
    }
}
