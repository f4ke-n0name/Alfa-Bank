import UIKit

extension DS {
    enum Typography {
        static func title1() -> UIFont { DS.config.typography.title1 }
        static func title2() -> UIFont { DS.config.typography.title2 }
        static func body() -> UIFont { DS.config.typography.body }
        static func button() -> UIFont { DS.config.typography.button }
        static func caption() -> UIFont { DS.config.typography.caption }
        static func text12() -> UIFont { DS.config.typography.text12 }
    }
}
