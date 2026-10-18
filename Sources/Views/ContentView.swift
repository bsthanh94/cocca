import SwiftUI

struct ContentView: View {
    @State private var children: [Child] = []
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(children) { child in
                    NavigationLink(destination: ChildDetailView(child: child)) {
                        HStack {
                            if let filename = child.photoFilename,
                               let uiImage = ImageStorage.loadImage(filename: filename) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                            VStack(alignment: .leading) {
                                Text(child.name).font(.headline)
                                let age = AgeCalculator.calculateAge(from: child.birthDate)
                                Text("\(age.years) , \(age.months) tháng, \(age.days) ngày")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteChild)
            }
            .navigationTitle("Theo dõi tuổi")
            .toolbar {
                Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddChildView(children: $children)
            }
            .onAppear(perform: loadChildren)
            .onChange(of: children) { _ in saveChildren() }
        }
    }

    private func loadChildren() {
        if let data = UserDefaults.standard.data(forKey: "children"),
           let decoded = try? JSONDecoder().decode([Child].self, from: data) {
            children = decoded
        }
    }

    private func saveChildren() {
        if let encoded = try? JSONEncoder().encode(children) {
            UserDefaults.standard.set(encoded, forKey: "children")
        }
    }

    private func deleteChild(at offsets: IndexSet) {
        children.remove(atOffsets: offsets)
    }
}
