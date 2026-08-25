import SwiftUI

struct AppErrorView: View {

    let message: String

    var body: some View {

        HStack(spacing: 12) {

            Image(
                systemName: "exclamationmark.triangle.fill"
            )
            .font(
                .system(size: 20)
            )
            .foregroundStyle(.red)

            Text(message)
                .font(
                    .system(
                        size: 14,
                        weight: .medium
                    )
                )
                .foregroundStyle(
                    Color.appTextPrimary
                )
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding(16)
        .background(
            Color.appSurface
        )
        .overlay(
            RoundedRectangle(
                cornerRadius: 16
            )
            .stroke(
                Color.red.opacity(0.25),
                lineWidth: 1
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 16
            )
        )
        .shadow(
            color: .black.opacity(0.08),
            radius: 8,
            x: 0,
            y: 4
        )
    }
}
