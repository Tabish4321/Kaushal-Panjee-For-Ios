import SwiftUI

enum AppSnackbarType {
    case success
    case error
}

struct AppSnackbar: View {

    let message: String
    let type: AppSnackbarType

    var body: some View {

        HStack(spacing: 12) {

            Image(
                systemName:
                    type == .success
                    ? "checkmark.circle.fill"
                    : "exclamationmark.circle.fill"
            )

            Text(message)
                .font(.system(size: 14))
                .lineLimit(3)

            Spacer()
        }
        .foregroundStyle(.white)
        .padding()
        .background(
            type == .success
            ? Color.appGreen
            : Color.red
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 14
            )
        )
        .shadow(radius: 8)
    }
}
