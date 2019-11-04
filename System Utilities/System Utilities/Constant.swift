//
//  Constants.swift
//  Triip
//

import UIKit

enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}

struct ScreenSize
{
    static let Width        = UIScreen.main.bounds.size.width
    static let Height       = UIScreen.main.bounds.size.height
    static let MaxLength    = max(ScreenSize.Width, ScreenSize.Height)
    static let MinLength    = min(ScreenSize.Width, ScreenSize.Height)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.MaxLength < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.MaxLength == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.MaxLength == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.MaxLength == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.MaxLength == 1024.0
}

struct Version
{
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
    static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
}

struct Color
{
    static let GrayColor = UIColor(red:0.88, green:0.88, blue:0.89, alpha:1)
}

let SystemValue = SystemServices()
