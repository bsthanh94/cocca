import SwiftUI
import PhotosUI

struct AddChildView: View {
    @Binding var children: [Child]
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var birthDate = Date()
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?

    var body: some View {
        NavigationStack {
            Form {
                Section("Thông tin") {
                    TextField("Tên của con", text: $name)
                    DatePicker("Ngày sinh", selection: $birthDate, in: ...Date(), displayedComponents: .date)
                }
                Section("Ảnh đại diện") {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        HStack {
                            if let selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "photo")
                                Text("Chọn ảnh từ thư viện")
                            }
                        }
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                selectedImage = uiImage
                            }
                        }
                    }
                }
                Button("Lưu") {
                    var photoFilename: String? = nil
                    if let selectedImage {
                        photoFilename = ImageStorage.saveImage(selectedImage)
                    }
                    let newChild = Child(name: name, birthDate: birthDate, photoFilename: photoFilename)
                    children.append(newChild)
                    dismiss()
                }
                .disabled(name.isEmpty)
            }
            .navigationTitle("Thêm con")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Hủy") { dismiss() }
                }
            }
        }
    }
}
