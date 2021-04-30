//
//  View+Extension.swift
//  
//
//  Created by Joshua Walsh on 4/29/21.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension View {

    #if DEBUG
    func previewDependencies() -> some View {
        self
            .environmentObject(Theme())
    }
    #endif
}
