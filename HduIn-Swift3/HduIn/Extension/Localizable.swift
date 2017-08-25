//
//  Localizable.swift
//  HduIn
//
//  Created by Lucas Woo on 3/3/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation

/// Internal current language key
let LCLCurrentLanguageKey = "LCLCurrentLanguageKey"

/// Default language. English. If English is unavailable defaults to base localization.
let LCLDefaultLanguage = "ch"

/// Base bundle as fallback.
let LCLBaseBundle = "Base"

/// Name for language change notification
let LCLLanguageChangeNotification = "LCLLanguageChangeNotification"

let LCLocalizableTables = [
    "Localizable",
    "NewsLocalizable",
    "MineLocalizable",
    "MoreLocalizable"
]

// MARK: Localization Syntax

extension String {
    /**
     Localization syntax, replaces NSLocalizedString
     - Returns: The localized string.
     */
    func localized() -> String {
        if let path = Bundle.main.path(
            forResource: Localize.currentLanguage(),
            ofType: "lproj"
        ),  let bundle = Bundle(path: path) {
            return bundle.localizedStringForKey(self, value: nil)
        } else if let path = Bundle.main.path(forResource: LCLBaseBundle,ofType: "lproj"),  let bundle = Bundle(path: path) {
            return bundle.localizedStringForKey(self, value: nil)
        }
        return self
    }

    /**
     Localization syntax with format arguments

     - parameter arguments: Arguments to localize

     - Returns: The formatted localized string with arguments.
     */
    func localizedFormat(_ arguments: CVarArg...) -> String {
        return String(format: localized(), arguments: arguments)
    }

    /**
     Plural localization syntax with a format argument

     - parameter argument: Argument to determine pluralisation

     - returns: Pluralized localized string.
     */
    func localizedPlural(_ argument: CVarArg) -> String {
        return NSString.localizedStringWithFormat(localized() as NSString, argument) as String
    }
}

extension Bundle {
    /**
     Returns a localized version of the string designated by the specified key
     and residing in the predefined table.

     - parameter key:   The key for a string in the table identified by *tableName*.
     - parameter value: The value to return if *key* is `nil` or if a localized string
        for *key* can’t be found in the table.

     - returns: A localized version of the string designated by *key* in table *tableName*.
        This method returns the following when key is `nil` or not found in table:
        - If *key* is not found and *value* is `nil` or an empty string, returns *key*.
        - If *key* is not found and *value* is non-`nil` and not empty, return *value*.
     */
    func localizedStringForKey(_ key: String, value: String?) -> String {
        let localizeds = LCLocalizableTables.map { (table) -> String in
            return self.localizedString(forKey: key, value: value, table: table)
        }.filter { $0 != key }

        return localizeds.first ?? value ?? key
    }
}

// MARK: Language Setting Functions

class Localize: NSObject {

    /**
     List available languages
     - Returns: Array of available languages.
     */
    class func availableLanguages() -> [String] {
        return Bundle.main.localizations
    }

    /**
     Current language
     
     - Returns: The current language. String.
     */
    class func currentLanguage() -> String {
        if let currentLanguage = UserDefaults.standard
            .object(forKey: LCLCurrentLanguageKey) as? String {
                return currentLanguage
        }
        return defaultLanguage()
    }

    /**
     Change the current language
     - Parameter language: Desired language.
     */
    class func setCurrentLanguage(_ language: String) {
        let selectedLanguage = availableLanguages().contains(language) ?
            language :
            defaultLanguage()
        if selectedLanguage != currentLanguage() {
            UserDefaults.standard.set(selectedLanguage,forKey: LCLCurrentLanguageKey)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: LCLLanguageChangeNotification),
                object: nil
            )
        }
    }

    /**
     Default language
     - Returns: The app's default language. String.
     */
    class func defaultLanguage() -> String {
        var defaultLanguage: String = String()
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return LCLDefaultLanguage
        }
        let availableLanguages: [String] = self.availableLanguages()
        if availableLanguages.contains(preferredLanguage) {
            defaultLanguage = preferredLanguage
        } else {
            defaultLanguage = LCLDefaultLanguage
        }
        return defaultLanguage
    }

    /**
     Resets the current language to the default
     */
    class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }

    /**
     Get the current language's display name for a language.
     - Parameter language: Desired language.
     - Returns: The localized string.
     */
    class func displayNameForLanguage(language: String) -> String {
        let locale = NSLocale(localeIdentifier: currentLanguage())
        if let displayName = locale.displayName(forKey: NSLocale.Key.languageCode, value: language) {
            return displayName
        }
        return String()
    }
}
