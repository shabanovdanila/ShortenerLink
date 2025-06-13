//
//  AppDependencies.swift
//  ShortenerLink
//
//  Created by Данила Шабанов on 10.06.2025.
//

import Foundation
import SwiftUICore

struct AppDependencies {
    let cleanUriClient: LinkClient
    let goTinyClient: LinkClient
}

extension AppDependencies: EnvironmentKey {
    static var defaultValue: AppDependencies {
        AppDependencies(
            cleanUriClient: CleanUriClient(),
            goTinyClient: GoTinyClient()
        )
    }
}

extension EnvironmentValues {
    var dependencies: AppDependencies {
        get { self[AppDependencies.self] }
        set { self[AppDependencies.self] = newValue }
    }
}
