//
//  Assets.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import SwiftUI

/// App 颜色主题
extension Color {
    // Primary Colors
    static let appPrimary = Color(hex: "FF9500")
    static let appSecondary = Color(hex: "FFCC00")

    // Status Colors
    static let appSuccess = Color(hex: "34C759")
    static let appError = Color(hex: "FF3B30")
    static let appWarning = Color(hex: "FF9500")
    static let appInfo = Color(hex: "007AFF")

    // Gray Colors
    static let appGray = Color(uiColor: .systemGray)
    static let appGray2 = Color(uiColor: .systemGray2)
    static let appGray3 = Color(uiColor: .systemGray3)
    static let appGray4 = Color(uiColor: .systemGray4)
    static let appGray5 = Color(uiColor: .systemGray5)
    static let appGray6 = Color(uiColor: .systemGray6)

    // Background Colors
    static let appBackground = Color(uiColor: .systemBackground)
    static let appSecondaryBackground = Color(uiColor: .secondarySystemBackground)
    static let appTertiaryBackground = Color(uiColor: .tertiarySystemBackground)
}

/// App 图片资源
enum AppImage {
    // System Images
    static let calendar = "calendar"
    static let calendarFill = "calendar.fill"
    static let bell = "bell"
    static let bellFill = "bell.fill"
    static let person2 = "person.2"
    static let person2Fill = "person.2.fill"
    static let gear = "gearshape"
    static let gearFill = "gearshape.fill"
    static let plus = "plus"
    static let plusCircle = "plus.circle"
    static let plusCircleFill = "plus.circle.fill"

    static let house = "house"
    static let houseFill = "house.fill"
    static let checkmark = "checkmark"
    static let xmark = "xmark"
    static let clock = "clock"
    static let location = "location"
    static let bellSlash = "bell.slash"
}

/// App 字体
extension Font {
    // Title Fonts
    static let appLargeTitle = Font.largeTitle
    static let appTitle1 = Font.title
    static let appTitle2 = Font.title2
    static let appTitle3 = Font.title3

    // Body Fonts
    static let appHeadline = Font.headline
    static let appBody = Font.body
    static let appCallout = Font.callout
    static let appSubheadline = Font.subheadline
    static let appFootnote = Font.footnote

    // Other Fonts
    static let appCaption = Font.caption
    static let appCaption2 = Font.caption2
}

/// App 间距
enum AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

/// App 圆角
enum AppCornerRadius {
    static let sm: CGFloat = 4
    static let md: CGFloat = 8
    static let lg: CGFloat = 12
    static let xl: CGFloat = 16
}

/// App 阴影
struct AppShadow {
    static let light = Shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    static let medium = Shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
    static let heavy = Shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 8)
}

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}
