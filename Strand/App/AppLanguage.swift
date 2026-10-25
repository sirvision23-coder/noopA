import SwiftUI

/// Supported languages in the application
public enum AppLanguage: String, CaseIterable, Identifiable, Codable {
    case english = "en"
    case kurdishSorani = "ckb"
    
    public var id: String { rawValue }
    
    /// Autonym / Display Name in its native script
    public var autonym: String {
        switch self {
        case .english:
            return "English"
        case .kurdishSorani:
            return "کوردی (سۆرانی)"
        }
    }
    
    /// Locale identifier associated with the selection
    public var locale: Locale {
        switch self {
        case .english:
            return Locale(identifier: "en_US")
        case .kurdishSorani:
            return Locale(identifier: "ckb_IQ")
        }
    }
    
    /// Layout Direction helper
    public var layoutDirection: LayoutDirection {
        switch self {
        case .english:
            return .leftToRight
        case .kurdishSorani:
            return .rightToLeft
        }
    }
}

/// Dynamic Localization Manager managing active locale & UI semantic layout
public final class LocalizationManager: ObservableObject {
    public static let shared = LocalizationManager()
    
    @AppStorage("selected_app_language") public var currentLanguage: AppLanguage = .english {
        didSet {
            applyLanguageSettings()
        }
    }
    
    private init() {
        applyLanguageSettings()
    }
    
    public func applyLanguageSettings() {
        UserDefaults.standard.set([currentLanguage.rawValue], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        if currentLanguage == .kurdishSorani {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        } else {
            UIView.appearance().semanticContentAttribute = .unspecified
        }
    }
    
    public func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = currentLanguage.locale
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    public func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = currentLanguage.locale
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
