import UIKit

enum DS {
    private(set) static var config: DSConfig = .default
    private static var isConfigured = false

    static func configure(_ config: DSConfig) {
        guard !isConfigured else { return }
        self.config = config
        isConfigured = true
    }

}
