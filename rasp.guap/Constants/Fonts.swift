// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSFont
  internal typealias Font = NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
  internal typealias Font = UIFont
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum FontFamily {
  internal enum TTCommons {
    internal static let bold = FontConvertible(name: "TTCommons-Bold", family: "TT Commons", path: "TTCommons-Bold.ttf")
    internal static let boldItalic = FontConvertible(name: "TTCommons-BoldItalic", family: "TT Commons", path: "TTCommons-BoldItalic.ttf")
    internal static let demiBold = FontConvertible(name: "TTCommons-DemiBold", family: "TT Commons", path: "TTCommons-DemiBold.ttf")
    internal static let demiBoldItalic = FontConvertible(name: "TTCommons-DemiBoldItalic", family: "TT Commons", path: "TTCommons-DemiBoldItalic.ttf")
    internal static let italic = FontConvertible(name: "TTCommons-Italic", family: "TT Commons", path: "TTCommons-Italic.ttf")
    internal static let light = FontConvertible(name: "TTCommons-Light", family: "TT Commons", path: "TTCommons-Light.ttf")
    internal static let lightItalic = FontConvertible(name: "TTCommons-LightItalic", family: "TT Commons", path: "TTCommons-LightItalic.ttf")
    internal static let medium = FontConvertible(name: "TTCommons-Medium", family: "TT Commons", path: "TTCommons-Medium.ttf")
    internal static let mediumItalic = FontConvertible(name: "TTCommons-MediumItalic", family: "TT Commons", path: "TTCommons-MediumItalic.ttf")
    internal static let regular = FontConvertible(name: "TTCommons-Regular", family: "TT Commons", path: "TTCommons-Regular.ttf")
    internal static let all: [FontConvertible] = [bold, boldItalic, demiBold, demiBoldItalic, italic, light, lightItalic, medium, mediumItalic, regular]
  }
  internal static let allCustomFonts: [FontConvertible] = [TTCommons.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  internal func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unabble to initialize font '\(name)' (\(family))")
    }
    return font
  }

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    let bundle = BundleToken.bundle
    return bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension Font {
  convenience init?(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(OSX)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    Bundle(for: BundleToken.self)
  }()
}
// swiftlint:enable convenience_type
