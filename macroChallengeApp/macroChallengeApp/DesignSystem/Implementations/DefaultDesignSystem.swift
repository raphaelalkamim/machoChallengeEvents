//
//  DefaultDesignSystem.swift
//  macroChallengeApp
//
//  Created by Beatriz Duque on 08/09/22.
//

import UIKit

struct DefaultDesignSystem: DesignSystem {
    let text = DesignText()
    let palette: DesignPalette = DefaultDesignPalette()
    let spacing: DesignSpacing = DefaultDesignSpacing()
    static var shared: DesignSystem = DefaultDesignSystem()
}
