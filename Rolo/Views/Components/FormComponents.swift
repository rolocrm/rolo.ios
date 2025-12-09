import SwiftUI

struct TextFieldWithLabel: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    let onTextChange: () -> Void
    let hasError: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !text.isEmpty {
                Text(label)
                    .font(.custom("Figtree", size: 15))
                    .fontWeight(.regular)
                    .foregroundColor(hasError ? .errorRed : .textSecondary)
                    .lineSpacing(5)
                    .frame(height: 20)
            }
            
            TextField(placeholder, text: $text, prompt: Text(placeholder).foregroundColor(Color.greyColor))
                .font(.custom("Figtree", size: 22))
                .fontWeight(.regular)
                .lineSpacing(6)
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(.textPrimary)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(height: text.isEmpty ? UIConstants.TextFieldHeight.empty : UIConstants.TextFieldHeight.filled)
                .onChange(of: text) { _ in
                    onTextChange()
                }
        }
    }
}

struct PasswordFieldWithLabel: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    @Binding var showPassword: Bool
    let onTextChange: () -> Void
    let hasError: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !text.isEmpty {
                Text(label)
                    .font(.custom("Figtree", size: 15))
                    .fontWeight(.regular)
                    .foregroundColor(hasError ? .errorRed : .textSecondary)
                    .lineSpacing(5)
                    .frame(height: 20)
            }
            
            HStack {
                if showPassword {
                    TextField(placeholder, text: $text, prompt: Text(placeholder).foregroundColor(Color.greyColor))
                        .font(.custom("Figtree", size: 22))
                        .fontWeight(.regular)
                        .lineSpacing(6)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.textPrimary)
                        .frame(height: text.isEmpty ? UIConstants.TextFieldHeight.empty : UIConstants.TextFieldHeight.filled)
                } else {
                    SecureField(placeholder, text: $text, prompt: Text(placeholder).foregroundColor(Color.greyColor))
                        .font(.custom("Figtree", size: 22))
                        .fontWeight(.regular)
                        .lineSpacing(6)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.textPrimary)
                        .frame(height: text.isEmpty ? UIConstants.TextFieldHeight.empty : UIConstants.TextFieldHeight.filled)
                }
                
                Button(action: {
                    showPassword.toggle()
                }) {
                    Image(systemName: !showPassword ? "eye.slash" : "eye")
                        .foregroundColor(.textSecondary)
                }
            }
            .onChange(of: text) { _ in
                onTextChange()
            }
        }
    }
}

struct FormContainer<Content: View>: View {
    let content: Content
    let hasError: Bool
    
    init(hasError: Bool, @ViewBuilder content: () -> Content) {
        self.hasError = hasError
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.secondaryGreen)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(hasError ? Color.errorRed : Color.clear, lineWidth: 1)
            )
    }
}

struct ActionButton: View {
    let title: String
    let isLoading: Bool
    let isDisabled: Bool
    let backgroundColor: Color?
    let textColor: Color?
    let borderColor: Color?
    let action: () -> Void
    
    init(
        title: String,
        isLoading: Bool,
        isDisabled: Bool,
        backgroundColor: Color? = nil,
        textColor: Color? = nil,
        borderColor: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.borderColor = borderColor
        self.action = action
    }
    
    
    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .textPrimary))
            } else {
                Text(title)
                    .font(.figtreeSemiBold(size: 18))
                    .foregroundColor(textColor ?? (isDisabled ? Color.greyColor : .textPrimary))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIConstants.ButtonHeight.standard)
        .background(backgroundColor ?? (isDisabled ? Color.disabledButtonBackground : Color.highlightGreen))
        .overlay(
            Group {
                if let borderColor = borderColor {
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(borderColor, lineWidth: 1)
                }
            }
        )
        .cornerRadius(100)
//        .disabled(isDisabled || isLoading)
    }
}

struct GoogleButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .textPrimary))
            } else {
                HStack(spacing: 12) {
                    Image(UIConstants.ImageNames.googleLogo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIConstants.IconSizes.medium, height: UIConstants.IconSizes.medium)

                    Text(title)
                        .font(.figtreeSemiBold(size: 18))
                        .foregroundColor(.textPrimary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIConstants.ButtonHeight.standard)
        .background(Color.googleButtonBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 100)
                .stroke(Color.highlightGreen, lineWidth: 1)
        )
        .cornerRadius(100)
    }
}

struct StripeButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(title)
                    .font(.figtreeSemiBold(size: 18))
                    .foregroundColor(.textPrimary)

                Image(UIConstants.ImageNames.stripe)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 20)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: UIConstants.ButtonHeight.standard)
        .background(Color.googleButtonBackground)
        .overlay(
            RoundedRectangle(cornerRadius: 100)
                .stroke(Color.secondaryGreen, lineWidth: 1)
        )
        .cornerRadius(100)
    }
}

struct ErrorMessage: View {
    let message: String

    var body: some View {
        Group {
            if !message.isEmpty {
                Text(message)
                    .foregroundColor(.errorRed)
                    .font(.custom("Figtree", size: 16))
                    .fontWeight(.regular)
                    .padding(.bottom, 16)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct DropdownFieldWithLabel: View {
    let label: String
    let placeholder: String
    @Binding var selectedValue: String
    let options: [String]
    let onValueChange: () -> Void
    let hasError: Bool
    @State private var showOptions = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !selectedValue.isEmpty {
                Text(label)
                    .font(.custom("Figtree", size: 15))
                    .fontWeight(.regular)
                    .foregroundColor(hasError ? .errorRed : .textSecondary)
                    .lineSpacing(5)
                    .frame(height: 20)
            }

            Button(action: {
                showOptions = true
            }) {
                HStack {
                    Text(selectedValue.isEmpty ? placeholder : selectedValue)
                        .font(.custom("Figtree", size: 22))
                        .fontWeight(.regular)
                        .lineSpacing(6)
                        .foregroundColor(selectedValue.isEmpty ? Color.greyColor : .textPrimary)
                    Spacer()
                }
                .frame(height: selectedValue.isEmpty ? UIConstants.TextFieldHeight.empty : UIConstants.TextFieldHeight.filled)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .confirmationDialog("Select \(label)", isPresented: $showOptions, titleVisibility: .hidden) {
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        selectedValue = option
                        onValueChange()
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}
