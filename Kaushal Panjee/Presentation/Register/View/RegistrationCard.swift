import SwiftUI

struct RegistrationCard<Content: View>: View {

    let content: Content

    init(
        @ViewBuilder content: () -> Content
    ) {

        self.content = content()
    }

    var body: some View {

        VStack(
            spacing: 0
        ) {

            content
        }
        .frame(
            maxWidth: .infinity
        )
        .background(
            Color.appCard
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 28
            )
        )
        .overlay {

            RoundedRectangle(
                cornerRadius: 28
            )
            .stroke(
                Color.appBorder.opacity(0.5),
                lineWidth: 1
            )
        }
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 14,
            x: 0,
            y: 6
        )
    }
}
