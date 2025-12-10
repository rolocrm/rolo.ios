import Foundation

class MembersViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var allMembers: [Member] = []
    @Published var filteredMembers: [Member] = []
    @Published var membersLists: [MembersLists] = []

    init() {
        // Members initialization logic
        allMembers = dummyMembers
        filteredMembers = allMembers
        membersLists = dummyMembersLists
    }
    
    func loadMembers() {
        // Load members data
    }
    
    func addMember() {
        // Add new member
    }
    
    func removeMember(id: String) {
        // Remove member
    }

    func filterMembers(searchText: String) {
        let query = searchText
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()

            // Если строка пустая — показываем всех
            guard !query.isEmpty else {
                filteredMembers = allMembers
                return
            }

            filteredMembers = allMembers.filter { member in
                member.name.lowercased().contains(query) || member.surname.lowercased().contains(query)
            }

    }
}

struct MembersLists: Identifiable {
    let id = UUID()
    var name: String
}

struct Member: Identifiable {
    let id = UUID()
    var name: String
    var surname: String
    var email: String
    var role: String
    var avatar: URL?
    var monthDonation: Int = 0

    var initials: String {
        let first = name.first.map { String($0).uppercased() } ?? ""
        let second = surname.first.map { String($0).uppercased() } ?? ""
        return first + second
    }
}

let dummyMembersLists: [MembersLists] = [
    MembersLists(name: "TestList")
]

let dummyMembers: [Member] = [
    Member(name: "Alice", surname: "Johnson", email: "alice.johnson@example.com", role: "Admin", avatar: nil),
    Member(name: "Bob", surname: "Smith", email: "bob.smith@example.com", role: "Member", avatar: nil),
    Member(name: "Carol", surname: "Davis", email: "carol.davis@example.com", role: "Moderator", avatar: nil, monthDonation: 81),
    Member(name: "David", surname: "Wilson", email: "david.wilson@example.com", role: "Member", avatar: nil),
    Member(name: "Emma", surname: "Thompson", email: "emma.thompson@example.com", role: "Member", avatar: nil),
    Member(name: "Frank", surname: "Miller", email: "frank.miller@example.com", role: "Member", avatar: nil),
    Member(name: "Grace", surname: "Lee", email: "grace.lee@example.com", role: "Admin", avatar: nil),
    Member(name: "Henry", surname: "Clark", email: "henry.clark@example.com", role: "Member", avatar: nil),
    Member(name: "Ivy", surname: "Lewis", email: "ivy.lewis@example.com", role: "Member", avatar: nil),
    Member(name: "Jack", surname: "Walker", email: "jack.walker@example.com", role: "Moderator", avatar: nil),
    Member(name: "Kara", surname: "Hall", email: "kara.hall@example.com", role: "Member", avatar: nil),
    Member(name: "Liam", surname: "Young", email: "liam.young@example.com", role: "Member", avatar: nil),
    Member(name: "Mia", surname: "King", email: "mia.king@example.com", role: "Member", avatar: nil),
    Member(name: "Noah", surname: "Wright", email: "noah.wright@example.com", role: "Member", avatar: nil),
    Member(name: "Olivia", surname: "Scott", email: "olivia.scott@example.com", role: "Moderator", avatar: nil),
    Member(name: "Paul", surname: "Green", email: "paul.green@example.com", role: "Member", avatar: nil),
    Member(name: "Quinn", surname: "Adams", email: "quinn.adams@example.com", role: "Member", avatar: nil),
    Member(name: "Ruby", surname: "Baker", email: "ruby.baker@example.com", role: "Member", avatar: nil),
    Member(name: "Sam", surname: "Nelson", email: "sam.nelson@example.com", role: "Admin", avatar: nil),
    Member(name: "Tina", surname: "Carter", email: "tina.carter@example.com", role: "Member", avatar: nil),
    Member(name: "Uma", surname: "Perez", email: "uma.perez@example.com", role: "Member", avatar: nil, monthDonation: 67),
    Member(name: "Victor", surname: "Turner", email: "victor.turner@example.com", role: "Member", avatar: nil),
    Member(name: "Wendy", surname: "Phillips", email: "wendy.phillips@example.com", role: "Member", avatar: nil, monthDonation: 112),
    Member(name: "Xavier", surname: "Campbell", email: "xavier.campbell@example.com", role: "Moderator", avatar: nil),
    Member(name: "Yara", surname: "Parker", email: "yara.parker@example.com", role: "Member", avatar: nil),
    Member(name: "Zoe", surname: "Evans", email: "zoe.evans@example.com", role: "Member", avatar: nil, monthDonation: 45),
    Member(name: "Aaron", surname: "Edwards", email: "aaron.edwards@example.com", role: "Member", avatar: nil),
    Member(name: "Bella", surname: "Collins", email: "bella.collins@example.com", role: "Member", avatar: nil),
    Member(name: "Caleb", surname: "Stewart", email: "caleb.stewart@example.com", role: "Member", avatar: nil),
    Member(name: "Diana", surname: "Sanchez", email: "diana.sanchez@example.com", role: "Member", avatar: nil, monthDonation: 138),
    Member(name: "Ethan", surname: "Morris", email: "ethan.morris@example.com", role: "Moderator", avatar: nil),
    Member(name: "Fiona", surname: "Rogers", email: "fiona.rogers@example.com", role: "Member", avatar: nil),
    Member(name: "Gavin", surname: "Reed", email: "gavin.reed@example.com", role: "Member", avatar: nil),
    Member(name: "Hannah", surname: "Cook", email: "hannah.cook@example.com", role: "Member", avatar: nil),
    Member(name: "Ian", surname: "Morgan", email: "ian.morgan@example.com", role: "Member", avatar: nil),
    Member(name: "Jade", surname: "Bell", email: "jade.bell@example.com", role: "Admin", avatar: nil, monthDonation: 90),
    Member(name: "Kyle", surname: "Murphy", email: "kyle.murphy@example.com", role: "Member", avatar: nil),
    Member(name: "Lara", surname: "Rivera", email: "lara.rivera@example.com", role: "Member", avatar: nil),
    Member(name: "Mason", surname: "Cooper", email: "mason.cooper@example.com", role: "Member", avatar: nil),
    Member(name: "Nina", surname: "Richardson", email: "nina.richardson@example.com", role: "Member", avatar: nil, monthDonation: 121),
    Member(name: "Owen", surname: "Cox", email: "owen.cox@example.com", role: "Moderator", avatar: nil),
    Member(name: "Piper", surname: "Howard", email: "piper.howard@example.com", role: "Member", avatar: nil),
    Member(name: "Riley", surname: "Ward", email: "riley.ward@example.com", role: "Member", avatar: nil),
    Member(name: "Sofia", surname: "Torres", email: "sofia.torres@example.com", role: "Member", avatar: nil),
    Member(name: "Tyler", surname: "Peterson", email: "tyler.peterson@example.com", role: "Member", avatar: nil, monthDonation: 77),
    Member(name: "Ulrich", surname: "Gray", email: "ulrich.gray@example.com", role: "Member", avatar: nil),
    Member(name: "Vera", surname: "Ramirez", email: "vera.ramirez@example.com", role: "Member", avatar: nil),
    Member(name: "Will", surname: "Foster", email: "will.foster@example.com", role: "Admin", avatar: nil),
    Member(name: "Xena", surname: "Simmons", email: "xena.simmons@example.com", role: "Member", avatar: nil, monthDonation: 149),
    Member(name: "Yuri", surname: "Butler", email: "yuri.butler@example.com", role: "Member", avatar: nil),
    Member(name: "Zara", surname: "Barnes", email: "zara.barnes@example.com", role: "Member", avatar: nil)
]
