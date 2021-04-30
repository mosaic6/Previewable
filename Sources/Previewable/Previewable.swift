import Foundation
import SwiftUI

#if DEBUG
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

    static func capturedPreviews(title: String) -> [(String, NSImage)] {

        var captured: [(String, NSImage)] = []

        let hostingView = NSHostingView(rootView: AnyView(create(from: defaultViewModel.viewModel)).previewLayout(.sizeThatFits).previewDependencies())
        captured.append((title + "-" + defaultViewModel.id + "-", hostingView.snapshot))

        for previewData in alternateViewModels {
            let alternateView = NSHostingView(rootView: AnyView(create(from: previewData.viewModel)).previewLayout(.sizeThatFits).previewDependencies())
            captured.append((title + "-" + previewData.id, alternateView.snapshot))
        }

        return captured
    }
}

@available(macOS 10.15, *)
extension NSHostingView {

    var snapshot: NSImage {

        let snapshotSize: NSSize = {
            guard fittingSize.width > 0 && fittingSize.height > 0 else {
                // Unable to determine a fitting size so we will generate a default size
                return NSSize(width: 1024, height: 768)
            }
            return fittingSize
        }()

        let contentRect = NSRect(x: 0, y: 0, width: snapshotSize.width, height: snapshotSize.height)
        let window = NSWindow(
            contentRect: contentRect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = self
        window.makeKeyAndOrderFront(nil)

        let newWindow = NSWindow(
            contentRect: contentRect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false)

        newWindow.contentView = self
        if let bitmapImageRepresentation = newWindow.contentView?.bitmapImageRepForCachingDisplay(in: contentRect) {
            newWindow.contentView?.cacheDisplay(in: contentRect, to: bitmapImageRepresentation)
            let renderedImage = NSImage(size: bitmapImageRepresentation.size)
            renderedImage.addRepresentation(bitmapImageRepresentation)
            return renderedImage
        } else {
            print("ERROR UNABLE TO CREATE NSIMAGE???")
            return NSImage()
        }
    }
}

#endif
