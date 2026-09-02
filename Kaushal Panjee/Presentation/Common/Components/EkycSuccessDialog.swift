import SwiftUI

struct EkycSuccessDialog: View {

    let photoBase64: String
    let name: String
    let fatherName: String
    let dob: String
    let onDone: () -> Void

    var body: some View {

        ZStack {

            // MARK: - Background

            Color.black
                .opacity(0.45)
                .ignoresSafeArea()

            // MARK: - Dialog

            VStack(spacing: 0) {

                // MARK: - Header

                VStack(spacing: 8) {

                    ZStack {

                        Circle()
                            .fill(Color.green.opacity(0.12))
                            .frame(width: 72, height: 72)

                        if let image = base64ToImage(photoBase64) {

                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .clipShape(Circle())

                        } else {

                            Image(systemName: "person.fill")
                                .font(.system(size: 28))
                                .foregroundColor(.gray)
                        }
                    }

                    Text("eKYC Successful")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)

                    Text("Aadhaar details verified successfully")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 22)

                // MARK: - Details

                VStack(spacing: 0) {

                    detailRow(
                        icon: "person.fill",
                        title: "Name",
                        value: name
                    )

                    Divider()

                    detailRow(
                        icon: "person.2.fill",
                        title: "Father's Name",
                        value: fatherName
                    )

                    Divider()

                    detailRow(
                        icon: "calendar",
                        title: "Date of Birth",
                        value: dob
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                // MARK: - Success Indicator

                HStack(spacing: 8) {

                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)

                    Text("Verification completed")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.green)

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)

                // MARK: - OK Button

                Button {
                    onDone()
                } label: {

                    Text("OK")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.green)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 12
                            )
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 20)
            }
            .frame(
                maxWidth: 360
            )
            .background(Color.white)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 22
                )
            )
            .shadow(
                color: .black.opacity(0.2),
                radius: 20,
                x: 0,
                y: 8
            )
            .padding(.horizontal, 24)
        }
    }

    // MARK: - Detail Row

    @ViewBuilder
    private func detailRow(
        icon: String,
        title: String,
        value: String
    ) -> some View {

        HStack(spacing: 12) {

            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.green)
                .frame(width: 24)

            Text(title)
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .frame(
                    width: 92,
                    alignment: .leading
                )

            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(2)

            Spacer(minLength: 0)
        }
        .padding(.vertical, 11)
    }

    // MARK: - Base64 → UIImage

    private func base64ToImage(
        _ base64: String
    ) -> UIImage? {

        guard !base64.isEmpty else {
            return nil
        }

        let cleanedBase64: String

        if let commaIndex = base64.firstIndex(of: ",") {
            cleanedBase64 = String(
                base64[base64.index(after: commaIndex)...]
            )
        } else {
            cleanedBase64 = base64
        }

        guard let data = Data(
            base64Encoded: cleanedBase64,
            options: .ignoreUnknownCharacters
        ) else {
            return nil
        }

        return UIImage(data: data)
    }
}
