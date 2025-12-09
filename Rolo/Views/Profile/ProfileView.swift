import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    let onNavigateToHome: (String, UIImage?) -> Void
    let onNavigateBack: () -> Void

    var body: some View {
        ZStack {
            Color.primaryBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection()
                profileImageSection()
                formSection()
                Spacer()

                createProfileButton()

            }
            .padding(.horizontal, 20)
        }
        .onChange(of: viewModel.isProfileCreated) { isCreated in
            if isCreated {
                onNavigateToHome(viewModel.firstName, viewModel.selectedImage)
            }
        }
        .actionSheet(isPresented: $viewModel.showingActionSheet) {
            ActionSheet(
                title: Text("Select Profile Image"),
                buttons: [
                    .default(Text("Camera")) {
                        viewModel.selectCamera()
                    },
                    .default(Text("Photo Library")) {
                        viewModel.selectPhotoLibrary()
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(selectedImage: $viewModel.selectedImage)
        }
        .sheet(isPresented: $viewModel.showingCamera) {
            CameraPicker(selectedImage: $viewModel.selectedImage)
        }
    }
    
    private func headerSection() -> some View {
        HStack {
            Button("Back") {
                onNavigateBack()
            }
            .font(.figtreeSemiBold(size: 18))
            .foregroundColor(Color.headerColor)
            
            Spacer()
            
            Text("Profile")
                .font(.figtreeBold(size: 18))
                .foregroundColor(Color.headerColor)
            
            Spacer()
            
            Button("Back") {
                viewModel.goBack()
            }
            .font(.figtreeSemiBold(size: 18))
            .foregroundColor(.clear)
        }
        .padding(.top, 20)
        .padding(.bottom, 32)
    }
    
    private func profileImageSection() -> some View {
        VStack(spacing: 0) {
            ZStack {
                if let selectedImage = viewModel.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 180, height: 180)
                        .clipShape(Circle())
                } else {
                    Image("Default")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180, height: 180).clipShape(Circle())

                }
                
                VStack {
                    Spacer()
                    Button(action: {
                        viewModel.showImagePicker()
                    }) {
                        Image("Upload")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 48, height: 48)
                    }
                    .offset(y: 24)
                }
                .frame(width: 180, height: 180)
            }
            Rectangle()
                .fill(Color.clear)
                .frame(height: 30)
            Text("Profile image")
                .font(.figtreeSemiBold(size: 16))
                .foregroundColor(.textPrimary)
            Rectangle()
                .fill(Color.clear)
                .frame(height: 4)
            Text("Max profile photo size: 2MB")
                .font(.custom("Figtree", size: 11))
                .foregroundColor(.textSecondary)
        }
        .padding(.bottom, 24)
    }
    
    private func formSection() -> some View {
        FormContainer(hasError: false) {
            VStack(spacing: 12) {
                TextFieldWithLabel(
                    label: "First name*",
                    placeholder: "First name*",
                    text: $viewModel.firstName,
                    onTextChange: {
                        viewModel.clearError()
                    },
                    hasError: !viewModel.errorMessage.isEmpty
                )
                
                Rectangle()
                    .fill(Color.textSecondary)
                    .frame(height: 0.5)
                
                TextFieldWithLabel(
                    label: "Last name*",
                    placeholder: "Last name*",
                    text: $viewModel.lastName,
                    onTextChange: {
                        viewModel.clearError()
                    },
                    hasError: !viewModel.errorMessage.isEmpty
                )
                
                Rectangle()
                    .fill(Color.textSecondary)
                    .frame(height: 0.5)
                
                TextFieldWithLabel(
                    label: "Phone number*",
                    placeholder: "Phone number*",
                    text: $viewModel.phoneNumber,
                    onTextChange: {
                        viewModel.clearError()
                    },
                    hasError: !viewModel.errorMessage.isEmpty
                )
            }
        }
        .padding(.bottom, 32)
    }
    
    private func createProfileButton() -> some View {
        ActionButton(
            title: "Create profile",
            isLoading: viewModel.isLoading,
            isDisabled: !viewModel.isFormValid,
            action: {
                viewModel.createProfile(profileImage: viewModel.selectedImage)
            }
        )
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        
        init(_ parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

