import SwiftUI

struct AppImage: View {

    let name: String

    var width: CGFloat?
    var height: CGFloat?

    var contentMode: ContentMode = .fit

    var body: some View {

        Image(name)
            .resizable()
            .aspectRatio(
                contentMode: contentMode
            )
            .frame(
                width: width,
                height: height
            )
    }
}
