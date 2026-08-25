import SwiftUI

struct AppText: View {

    let text: LocalizedStringKey
    let size: CGFloat
    let weight: Font.Weight
    let color: Color

    init(
        _ text: LocalizedStringKey,
        size: CGFloat = 14,
        weight: Font.Weight = .regular,
        color: Color = .primary
    ) {
        self.text = text
        self.size = size
        self.weight = weight
        self.color = color
    }

    var body: some View {

        Text(text)
            .font(
                .system(
                    size: size,
                    weight: weight
                )
            )
            .foregroundStyle(color)
    }
}
