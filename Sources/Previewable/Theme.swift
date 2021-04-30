//
//  Theme.swift
//  
//
//  Created by Joshua Walsh on 4/29/21.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
@available(macOS 10.15, *)
class Theme: ObservableObject {

    // Colors
    @Published var primaryActionColor = Color.init(.sRGB, red: 122, green: 22, blue: 243, opacity: 1)
}
