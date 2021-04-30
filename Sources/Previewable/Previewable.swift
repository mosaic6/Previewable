import Foundation
import SwiftUI

@available(macOS 10.15, *)
protocol Previewable {
    associatedtype ViewModel
    associatedtype Preview: View

    static var defaultViewModel: PreviewData<ViewModel> { get }
    static var alternateViewModels: [PreviewData<ViewModel>] { get }

    static func create(from viewModel: ViewModel) -> Preview
}

struct PreviewData<ViewModel>: Identifiable {
    let id: String
    let viewModel: ViewModel
}

@available(macOS 10.15, *)
extension Previewable {
    static var debugPreviews: some View {
        Group {
            AnyView(create(from: defaultViewModel.viewModel))
                .environment(\.colorScheme, .light)
                .previewDisplayName("\(defaultViewModel.id) Light")
                .previewLayout(.sizeThatFits)

            ForEach(alternateViewModels, id: \.id) { previewData in
                AnyView(create(from: previewData.viewModel))
                    .previewDisplayName("\(previewData.id) Light")
                    .previewLayout(.sizeThatFits)
            }
        }
        .previewDependencies()
    }

    static var devicePreviews: some View {
        Group {
            AnyView(create(from: defaultViewModel.viewModel))
                .environment(\.colorScheme, .light)
                .previewDisplayName("\(defaultViewModel.id) Light")

            ForEach(alternateViewModels, id: \.id) { previewData in
                AnyView(create(from: previewData.viewModel))
                    .previewDisplayName("\(previewData.id) Light")
            }
        }
        .previewDependencies()
    }
}
