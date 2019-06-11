// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Balance {
    /// Wrong credentials
    internal static let credentialsError = L10n.tr("Localizable", "balance.credentialsError")
    /// CZK
    internal static let currency = L10n.tr("Localizable", "balance.currency")
    /// Loading...
    internal static let loading = L10n.tr("Localizable", "balance.loading")
    /// Your balance is
    internal static let title = L10n.tr("Localizable", "balance.title")
  }

  internal enum Login {
    /// Login
    internal static let login = L10n.tr("Localizable", "login.login")
    /// Password
    internal static let password = L10n.tr("Localizable", "login.password")
    /// Restart app to show changes. (API is 💩)
    internal static let reload = L10n.tr("Localizable", "login.reload")
    /// User
    internal static let title = L10n.tr("Localizable", "login.title")
    /// Username
    internal static let username = L10n.tr("Localizable", "login.username")
  }

  internal enum Validate {
    /// Validation error!
    internal static let error = L10n.tr("Localizable", "validate.error")
    /// You must fill out all fields.
    internal static let errorMessage = L10n.tr("Localizable", "validate.errorMessage")
    /// Ok
    internal static let ok = L10n.tr("Localizable", "validate.ok")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
