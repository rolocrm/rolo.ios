import SwiftUI

struct MembersView: View {
    @StateObject private var viewModel = MembersViewModel()
    @State var searchText: String = ""

    @State var showAddMemberScreen: Bool = false
    @State var memberDeatilId: UUID? = nil
    @FocusState private var isSearchFiledFocused: Bool

    var body: some View {
//        NavigationStack {
            VStack(spacing: 0) {
                if !isSearchFiledFocused {
                    headerSection()
                }

                ScrollView(.vertical) {
                    LazyVStack(spacing: 0) {
//                        headerSection()
                        searchBar()
                        if !isSearchFiledFocused {
                            customLists()
                        }
                    }

                    LazyVStack(spacing: 0) {
                        if isSearchFiledFocused && viewModel.filteredMembers.isEmpty {
                            Text("No results found")
                                .font(.figtree(size: 14))
                                .foregroundColor(.neutralMediumGray)
                                .padding(.top, 32)
                        } else {
                            ForEach(viewModel.filteredMembers.enumerated(), id: \.element.id) { (index, item) in
                                MemberLineView(member: item)

                                if index < viewModel.filteredMembers.count - 1 {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundStyle(Color.neutralLightGray)
                                }
                            }
                        }
                    }
//                    .padding(.top, 32)
                }
                .padding(.top, isSearchFiledFocused ? 0 : 32)
//                .padding(.top, 32)
            }
            .animation(.easeInOut(duration: 0.25), value: isSearchFiledFocused)
            .background(Color.white)
//            .navigationDestination(isPresented: $showAddMemberScreen) {
//                AddMemberView(memberDetailID: memberDeatilId ?? UUID())
//            }
            .sheet(isPresented: $showAddMemberScreen) {
                AddMemberView(memberDetailID: memberDeatilId ?? UUID())
            }
//        }
    }

    // MARK: - customLists
    private func customLists() -> some View {
        HStack(spacing: 8) {
            Button(action: {
            }, label: {
                customMembersListsTag(listName: "All", chosed: true)
            })
            Button(action: {
            }, label: {
                customMembersListsTag(listName: "Membership", chosed: false)
            })
            Button(action: {
            }, label: {
                customMembersListsTag(listName: "Create list", chosed: false, icon: "plus")
            })

            Spacer(minLength: 0)
        }
        .padding(.top, 8)
        .padding(.horizontal, 16)
    }

    // MARK: - MembersListsTag
    private func customMembersListsTag(listName: String, chosed: Bool, icon: String? = nil) -> some View {
        HStack(spacing: 4) {
            Text(listName)
                .font(.figtree(size: 14))
                .foregroundColor(chosed ? .highlightGreen : .primaryGreen)

            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(chosed ? .highlightGreen : .primaryGreen)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(chosed ? Color.buttonBackground : Color.neutralLightGray)
        )
    }

    // MARK: - headerSection
    private func headerSection() -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Members")
                    .font(.figtreeMedium(size: 24))
                    .foregroundColor(Color.neutralBlack)

                Text((viewModel.filteredMembers.count).description)
                    .font(.figtreeMedium(size: 24))
                    .foregroundColor(.highlightGreen)
            }

            Spacer()

            HStack(spacing: 0) {
                Button(action: {
                    print("Add member")
                    memberDeatilId = UUID()
                    showAddMemberScreen = true
                }, label: {
                    ZStack {
                        Circle()
                            .fill(Color.neutralLightGray)
                            .frame(width: 48, height: 48)

                        Image(systemName: "plus")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.neutralBlack)
                    }
                })

                Button(action: {
                    print("Options tapped")
                }, label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.neutralBlack)
                        .rotationEffect(Angle(degrees: 90))
                        .frame(width: 48, height: 48)
                })
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - searchBar
    private func searchBar() -> some View {
        Group {
            HStack {
                if isSearchFiledFocused {
                    Button(action: {
                        isSearchFiledFocused = false
                        searchText = ""
                    }, label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.neutralBlack)
                    })
                } else {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.neutralDarkGray)
                }

                TextField(
                    text: $searchText,
                    prompt: Text("Search")
                        .font(.figtreeMedium(size: 14))
                        .foregroundColor(.neutralDarkGray),
                    label: { }
                )
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .font(.figtreeMedium(size: 14))
                .foregroundColor(.neutralDarkGray)
                .focused($isSearchFiledFocused)
                .onChange(of: searchText) { newValue in
                    viewModel.filterMembers(searchText: newValue)
                }

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.neutralDarkGray)
                    }
                }
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 18)
            .background(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Color.neutralLightGray)
            )
        }
        .padding(.horizontal, 16)
//        .padding(.top, isSearchFiledFocused ? 0 : 32)
    }
}

#Preview {
    MembersView()
}

