import SwiftUI

struct AppIcon: View {

    let name: String
    let size: CGFloat
    let color: Color

    init(
        _ name: String,
        size: CGFloat = 20,
        color: Color = .appDarkGreen
    ) {
        self.name = name
        self.size = size
        self.color = color
    }

    var body: some View {

        Image(
            systemName: name
        )
        .font(
            .system(
                size: size,
                weight: .medium
            )
        )
        .foregroundStyle(color)
    }
}
