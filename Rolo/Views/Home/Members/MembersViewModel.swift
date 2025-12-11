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
    var name: String = ""
    var surname: String = ""
    var nickname: String = ""
    var role: String = ""
    var avatar: URL?
    var monthDonation: Int = 0

    //contacts
    var phone: String = ""
    var email: String = ""

    var initials: String {
        let first = name.first.map { String($0).uppercased() } ?? ""
        let second = surname.first.map { String($0).uppercased() } ?? ""
        return first + second
    }

    static func createEmpty() -> Member {
        return Member()
    }
}

let dummyMembersLists: [MembersLists] = [
    MembersLists(name: "TestList")
]

let dummyMembers: [Member] = [
    Member(name: "Alice", surname: "Johnson", nickname: "AJ", role: "Admin", avatar: nil, email: "alice.johnson@example.com"),
    Member(name: "Bob", surname: "Smith", nickname: "Smitty", role: "Member", avatar: nil, email: "bob.smith@example.com"),
    Member(name: "Carol", surname: "Davis", nickname: "CD", role: "Moderator", avatar: nil, monthDonation: 81, email: "carol.davis@example.com"),
    Member(name: "David", surname: "Wilson", nickname: "D-Will", role: "Member", avatar: nil, email: "david.wilson@example.com"),
    Member(name: "Emma", surname: "Thompson", nickname: "Em", role: "Member", avatar: nil, email: "emma.thompson@example.com"),
    Member(name: "Frank", surname: "Miller", nickname: "Frankie", role: "Member", avatar: nil, email: "frank.miller@example.com"),
    Member(name: "Grace", surname: "Lee", nickname: "G-Lee", role: "Admin", avatar: nil, email: "grace.lee@example.com"),
    Member(name: "Henry", surname: "Clark", nickname: "Hank", role: "Member", avatar: nil, email: "henry.clark@example.com"),
    Member(name: "Ivy", surname: "Lewis", nickname: "Ives", role: "Member", avatar: nil, email: "ivy.lewis@example.com"),
    Member(name: "Jack", surname: "Walker", nickname: "Jax", role: "Moderator", avatar: nil, email: "jack.walker@example.com"),
    Member(name: "Kara", surname: "Hall", nickname: "Kay", role: "Member", avatar: nil, email: "kara.hall@example.com"),
    Member(name: "Liam", surname: "Young", nickname: "Lee", role: "Member", avatar: nil, email: "liam.young@example.com"),
    Member(name: "Mia", surname: "King", nickname: "Mimi", role: "Member", avatar: nil, email: "mia.king@example.com"),
    Member(name: "Noah", surname: "Wright", nickname: "Nono", role: "Member", avatar: nil, email: "noah.wright@example.com"),
    Member(name: "Olivia", surname: "Scott", nickname: "Liv", role: "Moderator", avatar: nil, email: "olivia.scott@example.com"),
    Member(name: "Paul", surname: "Green", nickname: "PG", role: "Member", avatar: nil, email: "paul.green@example.com"),
    Member(name: "Quinn", surname: "Adams", nickname: "Q", role: "Member", avatar: nil, email: "quinn.adams@example.com"),
    Member(name: "Ruby", surname: "Baker", nickname: "Rue", role: "Member", avatar: nil, email: "ruby.baker@example.com"),
    Member(name: "Sam", surname: "Nelson", nickname: "Sammy", role: "Admin", avatar: nil, email: "sam.nelson@example.com"),
    Member(name: "Tina", surname: "Carter", nickname: "T", role: "Member", avatar: nil, email: "tina.carter@example.com"),
    Member(name: "Uma", surname: "Perez", nickname: "Umi", role: "Member", avatar: nil, monthDonation: 67, email: "uma.perez@example.com"),
    Member(name: "Victor", surname: "Turner", nickname: "Vic", role: "Member", avatar: nil, email: "victor.turner@example.com"),
    Member(name: "Wendy", surname: "Phillips", nickname: "Wen", role: "Member", avatar: nil, monthDonation: 112, email: "wendy.phillips@example.com"),
    Member(name: "Xavier", surname: "Campbell", nickname: "Xav", role: "Moderator", avatar: nil, email: "xavier.campbell@example.com"),
    Member(name: "Yara", surname: "Parker", nickname: "Yaya", role: "Member", avatar: nil, email: "yara.parker@example.com"),
    Member(name: "Zoe", surname: "Evans", nickname: "Zo", role: "Member", avatar: nil, monthDonation: 45, email: "zoe.evans@example.com"),
    Member(name: "Aaron", surname: "Edwards", nickname: "A-Ron", role: "Member", avatar: nil, email: "aaron.edwards@example.com"),
    Member(name: "Bella", surname: "Collins", nickname: "Belle", role: "Member", avatar: nil, email: "bella.collins@example.com"),
    Member(name: "Caleb", surname: "Stewart", nickname: "Cal", role: "Member", avatar: nil, email: "caleb.stewart@example.com"),
    Member(name: "Diana", surname: "Sanchez", nickname: "Di", role: "Member", avatar: nil, monthDonation: 138, email: "diana.sanchez@example.com"),
    Member(name: "Ethan", surname: "Morris", nickname: "E", role: "Moderator", avatar: nil, email: "ethan.morris@example.com"),
    Member(name: "Fiona", surname: "Rogers", nickname: "Fi", role: "Member", avatar: nil, email: "fiona.rogers@example.com"),
    Member(name: "Gavin", surname: "Reed", nickname: "Gav", role: "Member", avatar: nil, email: "gavin.reed@example.com"),
    Member(name: "Hannah", surname: "Cook", nickname: "Han", role: "Member", avatar: nil, email: "hannah.cook@example.com"),
    Member(name: "Ian", surname: "Morgan", nickname: "IM", role: "Member", avatar: nil, email: "ian.morgan@example.com"),
    Member(name: "Jade", surname: "Bell", nickname: "JB", role: "Admin", avatar: nil, monthDonation: 90, email: "jade.bell@example.com"),
    Member(name: "Kyle", surname: "Murphy", nickname: "Ky", role: "Member", avatar: nil, email: "kyle.murphy@example.com"),
    Member(name: "Lara", surname: "Rivera", nickname: "L", role: "Member", avatar: nil, email: "lara.rivera@example.com"),
    Member(name: "Mason", surname: "Cooper", nickname: "Mace", role: "Member", avatar: nil, email: "mason.cooper@example.com"),
    Member(name: "Nina", surname: "Richardson", nickname: "Nin", role: "Member", avatar: nil, monthDonation: 121, email: "nina.richardson@example.com"),
    Member(name: "Owen", surname: "Cox", nickname: "OC", role: "Moderator", avatar: nil, email: "owen.cox@example.com"),
    Member(name: "Piper", surname: "Howard", nickname: "Pip", role: "Member", avatar: nil, email: "piper.howard@example.com"),
    Member(name: "Riley", surname: "Ward", nickname: "Ry", role: "Member", avatar: nil, email: "riley.ward@example.com"),
    Member(name: "Sofia", surname: "Torres", nickname: "Sofi", role: "Member", avatar: nil, email: "sofia.torres@example.com"),
    Member(name: "Tyler", surname: "Peterson", nickname: "Ty", role: "Member", avatar: nil, monthDonation: 77, email: "tyler.peterson@example.com"),
    Member(name: "Ulrich", surname: "Gray", nickname: "Uli", role: "Member", avatar: nil, email: "ulrich.gray@example.com"),
    Member(name: "Vera", surname: "Ramirez", nickname: "Vee", role: "Member", avatar: nil, email: "vera.ramirez@example.com"),
    Member(name: "Will", surname: "Foster", nickname: "Willie", role: "Admin", avatar: nil, email: "will.foster@example.com"),
    Member(name: "Xena", surname: "Simmons", nickname: "X", role: "Member", avatar: nil, monthDonation: 149, email: "xena.simmons@example.com"),
    Member(name: "Yuri", surname: "Butler", nickname: "YuriB", role: "Member", avatar: nil, email: "yuri.butler@example.com"),
    Member(name: "Zara", surname: "Barnes", nickname: "Z", role: "Member", avatar: nil, email: "zara.barnes@example.com")
]
