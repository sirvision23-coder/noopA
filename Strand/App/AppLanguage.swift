import Foundation

/// The language NOOP uses for app-owned copy. Region-specific measurement and clock preferences remain
/// separate: this changes words, not the user's unit-system choice or time zone.
///
/// Apple chooses a bundle's localization once, when the process launches. `apply(_:)` therefore writes
/// the standard `AppleLanguages` override and Settings tells the user to reopen NOOP. Applying only a
/// SwiftUI `locale` live would be incorrect: `Text` would switch immediately while `String(localized:)`
/// messages, notifications, and strings owned by `StrandDesign.module` stayed in the old language.
enum AppLanguage: String, CaseIterable, Identifiable {
    case system
    case english = "en"
    case german = "de"
    case spanish = "es"
    case french = "fr"
    case italian = "it"
    case portuguese = "pt-PT"
    case polish = "pl"
    case chinese = "zh"
    case kurdishSorani = "ckb"

    static let storageKey = "noop.appLanguage"

    var id: String { rawValue }

    /// Language names are autonyms on purpose, so the picker remains understandable while changing from
    /// an unfamiliar language. The system choice is localized at its call site.
    var autonym: String {
        switch self {
        case .system:     return ""
        case .english:    return "English"
        case .german:     return "Deutsch"
        case .spanish:    return "Español"
        case .french:     return "Français"
        case .italian:    return "Italiano"
        case .portuguese: return "Português"
        case .polish:     return "Polski"
        case .chinese:    return "中文"
        case .kurdishSorani: return "کوردی (سۆرانی)"
        }
    }

    static func resolve(_ raw: String) -> AppLanguage {
        AppLanguage(rawValue: raw) ?? .system
    }

    /// Persist the bundle-language override. Foundation observes it on the next process launch.
    static func apply(_ raw: String, defaults: UserDefaults = .standard) {
        let language = resolve(raw)
        if language == .system {
            defaults.removeObject(forKey: "AppleLanguages")
        } else {
            defaults.set([language.rawValue], forKey: "AppleLanguages")
        }
    }

    /// Locale used by SwiftUI format styles for the language that the currently-running bundles chose.
    /// This deliberately follows `Bundle`, not the pending picker value, so changing the setting cannot
    /// produce a half-new/half-old UI before the requested reopen.
    static var activeLocale: Locale {
        // Kurdish (Sorani) build: Kurdish digits, month and weekday names everywhere, while the device's
        // region still decides the clock style and units.
        if let region = Locale.autoupdatingCurrent.region?.identifier {
            return Locale(identifier: "ckb_\(region)")
        }
        return Locale(identifier: "ckb")
    }
}
