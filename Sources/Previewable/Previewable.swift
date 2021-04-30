import Foundation
import SwiftUI

public protocol Previewable {
    associatedtype ViewModel
    associatedtype Preview: View

    static var defaultViewModel: PreviewData<ViewModel> { get }
    static var alternateViewModels: [PreviewData<ViewModel>] { get }

    static func create(from viewModel: ViewModel) -> Preview
}

public struct PreviewData<ViewModel>: Identifiable {
    public let id: String
    let viewModel: ViewModel

    public init(id: String, viewModel: ViewModel) {
        self.id = id
        self.viewModel = viewModel
    }
}

extension Previewable {
    public static var debugPreviews: some View {
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

    public static var devicePreviews: some View {
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
