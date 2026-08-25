import SwiftUI

struct LoginLockBadge: View {

    var body: some View {

        ZStack {

            // Outer circle

            Circle()
                .fill(
                    Color.appSurface
                )
                .frame(
                    width: 72,
                    height: 72
                )


            // Inner circle

            Circle()
                .fill(
                    Color.appVeryLightGreen
                )
                .frame(
                    width: 54,
                    height: 54
                )


            // Lock

            Image(
                systemName: "lock.shield.fill"
            )
            .font(
                .system(
                    size: 26,
                    weight: .medium
                )
            )
            .foregroundStyle(
                Color.appDarkGreen
            )
        }
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 8,
            x: 0,
            y: 3
        )
    }
}
