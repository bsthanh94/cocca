import SwiftUI

struct ChildDetailView: View {
    let child: Child
    @State private var now = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 20) {
            if let filename = child.photoFilename,
               let uiImage = ImageStorage.loadImage(filename: filename) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .padding(.top)
            }

            Text(child.name).font(.largeTitle).bold()

            let age = AgeCalculator.calculateAge(from: child.birthDate, to: now)
            VStack(spacing: 8) {
                Text("\(age.years) năm").font(.title)
                Text("\(age.months) tháng, \(age.days) ngày").font(.title2).foregroundColor(.secondary)
            }
            Spacer()
        }
        .onReceive(timer) { input in
            now = input
        }
    }
}
