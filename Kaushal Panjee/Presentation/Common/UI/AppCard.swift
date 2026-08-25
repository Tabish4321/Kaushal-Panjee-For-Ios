import SwiftUI

struct AppCard<Content: View>: View {

    // MARK: - Properties

    private let content: Content

    // MARK: - Init

    init(
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
    }

    // MARK: - Body

    var body: some View {

        content
            .padding(20)
            .background(
                Color.appCard
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 24
                )
            )
            .overlay {

                RoundedRectangle(
                    cornerRadius: 24
                )
                .stroke(
                    Color.appBorder.opacity(0.45),
                    lineWidth: 1
                )
            }
            .shadow(
                color: Color.black.opacity(0.07),
                radius: 18,
                x: 0,
                y: 8
            )
    }
}
