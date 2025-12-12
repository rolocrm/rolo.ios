import SwiftUI

struct CreateCommunityView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = CreateCommunityViewModel()
    @State private var showEmailAnnotation = false
    @Bindable var user: UserProfile
    let onNavigateBack: () -> Void
    let onCommunityCreated: () -> Void
    
    var body: some View {
        ZStack {
            Color.primaryBackground
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    headerSection()
                    logoSection()
                    handleSection()
                    mainFormSection()
                    addCollaboratorSection()
                    collaboratorsListSection()
                    createButtonSection()
                }
                .padding(.horizontal, 20)
            }
        }
        .onChange(of: viewModel.isCommunityCreated) { isCreated in
            if let newUserProfile = viewModel.newUserProfile, isCreated {
                modelContext.insert(newUserProfile)
                do {
                    try modelContext.save()
                } catch {
                    print("SwiftData save error:", error)
                }
                onCommunityCreated()
            }
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

            Text("Create community")
                .font(.figtreeBold(size: 18))
                .foregroundColor(Color.headerColor)

            Spacer()
        }
        .padding(.top, 20)
        .padding(.bottom, 32)
    }

    private func logoSection() -> some View {
        HStack {
            Button(action: {
                viewModel.showImagePicker = true
            }) {
                ZStack {
                    Circle()
                        .fill(Color.secondaryGreen)
                        .frame(width: UIConstants.LogoSize.width, height: UIConstants.LogoSize.height)

                    if let logo = viewModel.selectedLogo {
                        Image(uiImage: logo)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIConstants.LogoSize.width, height: UIConstants.LogoSize.height)
                            .clipShape(Circle())
                    } else {
                        Image(UIConstants.ImageNames.handleUpload)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIConstants.IconSizes.large, height: UIConstants.IconSizes.large)
                            .foregroundColor(.textPrimary)
                    }
                }
            }
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(selectedImage: $viewModel.selectedLogo)
            }
            .onChange(of: viewModel.selectedLogo) { logo in
                if logo != nil {
                    viewModel.uploadLogo()
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Logo")
                    .font(.figtree(size: 16))
                    .foregroundColor(.textSecondary)
            }

            Spacer()
        }
        .padding(.bottom, 24)
    }
    
    private func handleSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            FormContainer(hasError: !viewModel.handleValidationMessage.isEmpty && !viewModel.handleValidationMessage.contains("available")) {
                TextFieldWithLabel(
                    label: "Handle*",
                    placeholder: "Enter handle",
                    text: $viewModel.handle,
                    onTextChange: {
                        viewModel.clearError()
                        viewModel.validateHandle()
                    },
                    hasError: !viewModel.handleValidationMessage.isEmpty && !viewModel.handleValidationMessage.contains("available")
                )
                .overlay(alignment: .trailing) {
                    Button(action: {
                        viewModel.generateNewHandle()
                    }) {
                        Image(UIConstants.ImageNames.refresh)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIConstants.IconSizes.large, height: UIConstants.IconSizes.large)
                            .foregroundColor(.textSecondary)
                    }
                }
            }
            
            if !viewModel.handleValidationMessage.isEmpty && !viewModel.handleValidationMessage.contains("available") {
                Text(viewModel.handleValidationMessage)
                    .font(.custom("Figtree", size: 11))
                    .fontWeight(.regular)
                    .foregroundColor(.errorRed)
                    .lineSpacing(2)
                    .kerning(0.06)
                    .padding(.top, 4)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Your community's unique handle. Others will use it to join or request access.")
                    .font(.figtree(size: 11))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 12)
                
                if viewModel.isHandleValidating {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Checking availability...")
                            .font(.figtree(size: 12))
                            .foregroundColor(.textSecondary)
                    }
                }
            }
        }
        .padding(.bottom, 24)
    }
    
    private func mainFormSection() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if !viewModel.errorMessage.isEmpty && !viewModel.isMainFormValid {
                ErrorMessage(message: viewModel.errorMessage)
            }

            FormContainer(hasError: false) {
                VStack(spacing: 12) {
                TextFieldWithLabel(
                    label: "Community name*",
                    placeholder: "Community name*",
                    text: $viewModel.communityName,
                    onTextChange: {
                        viewModel.clearError()
                    },
                    hasError: false
                )
                
                Rectangle()
                    .fill(Color.textSecondary)
                    .frame(height: 1)
                
                VStack(alignment: .leading, spacing: 8) {
                    TextFieldWithLabel(
                        label: "Email*",
                        placeholder: "Email*",
                        text: $viewModel.email,
                        onTextChange: {
                            viewModel.clearError()
                        },
                        hasError: false
                    )
                    .overlay(alignment: .trailing) {
                        Button(action: {
                            withAnimation {
                                showEmailAnnotation.toggle()
                            }
                        }) {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(.textSecondary)
                                .font(.system(size: 16))
                                .popover(isPresented: $showEmailAnnotation, attachmentAnchor: .rect(.bounds), arrowEdge: .top)
                            {
                                TooltipView()
                                    .presentationCompactAdaptation(.popover)
                                    .presentationBackground(Color.black)
                                    .presentationBackgroundInteraction(.enabled)
                                    .scrollDisabled(true)
                            }
                                                            
                        }
                        
                    }
                    
                   
                }
                
                Rectangle()
                    .fill(Color.textSecondary)
                    .frame(height: 1)
                
                TextFieldWithLabel(
                    label: "Phone number*",
                    placeholder: "Phone number*",
                    text: $viewModel.phoneNumber,
                    onTextChange: {
                        viewModel.clearError()
                    },
                    hasError: false
                )
                
                Rectangle()
                    .fill(Color.textSecondary)
                    .frame(height: 1)
                
                TextFieldWithLabel(
                    label: "Tax ID",
                    placeholder: "Tax ID",
                    text: $viewModel.taxId,
                    onTextChange: {
                        viewModel.clearError()
                    },
                    hasError: false
                )
                
                Rectangle()
                    .fill(Color.textSecondary)
                    .frame(height: 1)
                
                DropdownFieldWithLabel(
                    label: "Country*",
                    placeholder: "Country*",
                    selectedValue: $viewModel.country,
                    options: viewModel.countryOptions,
                    onValueChange: {
                        viewModel.clearError()
                    },
                    hasError: false && !viewModel.isMainFormValid
                )
                .overlay(alignment: .trailing) {
                    Image(systemName: "chevron.down")
                        .foregroundColor(.textSecondary)
                        .font(.system(size: 14))
                }
                
                Rectangle()
                    .fill(Color.textSecondary)
                    .frame(height: 1)
                
                TextFieldWithLabel(
                    label: "Address*",
                    placeholder: "Address*",
                    text: $viewModel.address,
                    onTextChange: {
                        viewModel.clearError()
                    },
                    hasError: false
                )
                
                Rectangle()
                    .fill(Color.textSecondary)
                    .frame(height: 1)
                
                HStack(spacing: 12) {
                    TextFieldWithLabel(
                        label: "City*",
                        placeholder: "City*",
                        text: $viewModel.city,
                        onTextChange: {
                            viewModel.clearError()
                        },
                        hasError: false
                    )
                    
                    TextFieldWithLabel(
                        label: "State*",
                        placeholder: "State*",
                        text: $viewModel.state,
                        onTextChange: {
                            viewModel.clearError()
                        },
                        hasError: false
                    )
                    
                    TextFieldWithLabel(
                        label: "Zip code*",
                        placeholder: "Zip code*",
                        text: $viewModel.zipCode,
                        onTextChange: {
                            viewModel.clearError()
                        },
                        hasError: false
                    )
                }
            }
        }
        .padding(.bottom, 24)
    }
    }
    
    private func addCollaboratorSection() -> some View {
        ActionButton(
            title: "+ Add a collaborator",
            isLoading: false,
            isDisabled: false,
            backgroundColor: Color.secondaryGreen,
            textColor: .textPrimary,
            borderColor: nil
        ) {
            viewModel.addCollaborator()
        }
        .padding(.bottom, 16)
    }
    
    private func collaboratorsListSection() -> some View {
        ForEach(Array(viewModel.collaborators.enumerated()), id: \.element.id) { index, collaborator in
            collaboratorCard(at: index, collaborator: collaborator)
        }
    }

    private func collaboratorCard(at index: Int, collaborator: Collaborator) -> some View {
        let hasError = false

        return VStack(alignment: .leading, spacing: 0) {
            if hasError {
                ErrorMessage(message: "Please fill in all collaborator fields or remove this collaborator")
            }

            FormContainer(hasError: hasError) {
                VStack(spacing: 12) {
                HStack {
                    Spacer()
                    Button("Remove x") {
                        viewModel.removeCollaborator(at: index)
                    }
                    .font(.figtree(size: 14))
                    .foregroundColor(.textSecondary)
                }

                TextFieldWithLabel(
                    label: "Name*",
                    placeholder: "Name*",
                    text: Binding(
                        get: { viewModel.collaborators[index].name },
                        set: { viewModel.updateCollaboratorName(at: index, name: $0) }
                    ),
                    onTextChange: {},
                    hasError: false
                )

                Rectangle()
                    .fill(Color.textSecondary)
                    .frame(height: 1)

                TextFieldWithLabel(
                    label: "Email*",
                    placeholder: "Email*",
                    text: Binding(
                        get: { viewModel.collaborators[index].email },
                        set: { viewModel.updateCollaboratorEmail(at: index, email: $0) }
                    ),
                    onTextChange: {},
                    hasError: false
                )

                Rectangle()
                    .fill(Color.textSecondary)
                    .frame(height: 1)

                DropdownFieldWithLabel(
                    label: "Role*",
                    placeholder: "Role*",
                    selectedValue: Binding(
                        get: { viewModel.collaborators[index].role },
                        set: { viewModel.updateCollaboratorRole(at: index, role: $0) }
                    ),
                    options: viewModel.availableRoles,
                    onValueChange: {},
                    hasError: false
                )
                .overlay(alignment: .trailing) {
                    Image(systemName: "chevron.down")
                        .foregroundColor(.textSecondary)
                        .font(.system(size: 14))
                        .padding(.trailing, 12)
                }
            }
        }
        .padding(.bottom, 24)
        }
    }

    private func createButtonSection() -> some View {
        ActionButton(
            title: "Create community",
            isLoading: viewModel.isLoading,
            isDisabled: !viewModel.isFormValid,
            action: {
                viewModel.createCommunity()
            }
        )
        .padding(.bottom, 32)
    }
}

//#Preview {
//    CreateCommunityView(onNavigateBack: {}, onCommunityCreated: {})
//}

struct TooltipView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "questionmark.circle")
                .foregroundColor(.white)
                .font(.system(size: 18))

            VStack(alignment: .leading, spacing: 4) {
                Text("This email will be for the community")
                    .font(.system(size: 14))
                    .foregroundColor(.white)

                Text("E.g marketing emails, invoice email and newsletters")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(12)
//        .frame(maxWidth: 300)
        .background(Color.black)
        .cornerRadius(8)
    }
}


struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        }
    }
}
