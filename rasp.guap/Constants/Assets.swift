// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ColorAsset.Color", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetColorTypeAlias = ColorAsset.Color
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal enum AppImages {
    internal enum FAQImages {
      internal static let hat = ImageAsset(name: "hat")
      internal static let inst = ImageAsset(name: "inst")
      internal static let med = ImageAsset(name: "med")
      internal static let medal = ImageAsset(name: "medal")
      internal static let nav = ImageAsset(name: "nav")
      internal static let otd = ImageAsset(name: "otd")
      internal static let stu = ImageAsset(name: "stu")
    }
    internal static let launchScreen = ImageAsset(name: "LaunchScreen")
    internal enum TabBarImages {
      internal static let deadlines = ImageAsset(name: "deadlines")
      internal static let feed = ImageAsset(name: "feed")
      internal static let info = ImageAsset(name: "info")
      internal static let profile = ImageAsset(name: "profile")
      internal static let schedule = ImageAsset(name: "schedule")
    }
    internal static let tutorialEipse = ImageAsset(name: "TutorialEipse")
    internal enum DeadlineModal {
      internal static let delete = ImageAsset(name: "delete")
      internal static let edit = ImageAsset(name: "edit")
    }
    internal enum DeadlineStateImages {
      internal static let article = ImageAsset(name: "article")
      internal static let calendar = ImageAsset(name: "calendar")
      internal static let done = ImageAsset(name: "done")
      internal static let recent = ImageAsset(name: "recent")
    }
    internal static let photoPlaceholder = ImageAsset(name: "photoPlaceholder")
    internal static let pocketpocketLogo = ImageAsset(name: "pocketpocket_logo")
    internal static let rocket = ImageAsset(name: "rocket")
    internal enum WeatherImages {
      internal static let clouds = ImageAsset(name: "clouds")
      internal static let cloudy = ImageAsset(name: "cloudy")
      internal static let drizzle = ImageAsset(name: "drizzle")
      internal static let mist = ImageAsset(name: "mist")
      internal static let snow = ImageAsset(name: "snow")
      internal static let sunny = ImageAsset(name: "sunny")
    }
  }
  internal enum PocketColors {
    internal static let accent = ColorAsset(name: "accent")
    internal static let activityIndicatorTint = ColorAsset(name: "activity_indicator_tint")
    internal static let backgroundPage = ColorAsset(name: "background_page")
    internal static let backgroundSuggestions = ColorAsset(name: "background_suggestions")
    internal static let buttonOutlineBorder = ColorAsset(name: "button_outline_border")
    internal static let fieldTextPlaceholder = ColorAsset(name: "field_text_placeholder")
    internal static let headerBackground = ColorAsset(name: "header_background")
    internal static let iconSecondary = ColorAsset(name: "icon_secondary")
    internal static let placeholderIconForegroundPrimary = ColorAsset(name: "placeholder_icon_foreground_primary")
    internal static let pocketAqua = ColorAsset(name: "pocket_aqua")
    internal static let pocketBlack = ColorAsset(name: "pocket_black")
    internal static let pocketBlue = ColorAsset(name: "pocket_blue")
    internal static let pocketDarkBlue = ColorAsset(name: "pocket_dark_blue")
    internal static let pocketDarkestBlue = ColorAsset(name: "pocket_darkest_blue")
    internal static let pocketDeadlineGreen = ColorAsset(name: "pocket_deadline_green")
    internal static let pocketDeadlineRed = ColorAsset(name: "pocket_deadline_red")
    internal static let pocketDivBorder = ColorAsset(name: "pocket_div_border")
    internal static let pocketError = ColorAsset(name: "pocket_error")
    internal static let pocketGray = ColorAsset(name: "pocket_gray")
    internal static let pocketGreen = ColorAsset(name: "pocket_green")
    internal static let pocketGreenButtonText = ColorAsset(name: "pocket_green_button_text")
    internal static let pocketLightGray = ColorAsset(name: "pocket_light_gray")
    internal static let pocketLightShadow = ColorAsset(name: "pocket_light_shadow")
    internal static let pocketLink = ColorAsset(name: "pocket_link")
    internal static let pocketModalBackground = ColorAsset(name: "pocket_modal_background")
    internal static let pocketOrange = ColorAsset(name: "pocket_orange")
    internal static let pocketPurple = ColorAsset(name: "pocket_purple")
    internal static let pocketRedButtonText = ColorAsset(name: "pocket_red_button_text")
    internal static let pocketShadow = ColorAsset(name: "pocket_shadow")
    internal static let pocketSnackbarBackground = ColorAsset(name: "pocket_snackbar_background")
    internal static let pocketTagBorder = ColorAsset(name: "pocket_tag_border")
    internal static let pocketWhite = ColorAsset(name: "pocket_white")
    internal static let pocketYellow = ColorAsset(name: "pocket_yellow")
    internal static let searchBarBackground = ColorAsset(name: "search_bar_background")
    internal static let searchBarFieldBackground = ColorAsset(name: "search_bar_field_background")
    internal static let searchBarFieldTint = ColorAsset(name: "search_bar_field_tint")
    internal static let separatorCommon = ColorAsset(name: "separator_common")
  }
  internal enum SystemIcons {
    internal static let likes = ImageAsset(name: "Likes")
    internal static let modalViewExitCross = ImageAsset(name: "ModalViewExitCross")
    internal static let scheduleFilter = ImageAsset(name: "ScheduleFilter")
    internal static let add = ImageAsset(name: "add")
    internal static let searchDropdown = ImageAsset(name: "searchDropdown")
  }
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal final class ColorAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  internal private(set) lazy var color: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  fileprivate init(name: String) {
    self.name = name
  }
}

internal extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let image = bundle.image(forResource: NSImage.Name(name))
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    Bundle(for: BundleToken.self)
  }()
}
// swiftlint:enable convenience_type
