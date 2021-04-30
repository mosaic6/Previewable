//
//  View+Extension.swift
//  
//
//  Created by Joshua Walsh on 4/29/21.
//

import Foundation
import SwiftUI

extension View {

    #if DEBUG
    func previewDependencies() -> some View {
        self
            .environmentObject(Theme())
    }
    #endif
}
