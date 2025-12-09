import Foundation

struct UserProfile: Decodable {
    let id: String
    let email: String
    let name: String?
    let lastname: String?
    let phone: String?
    let image: String?
    let type: String?
    let createdAt: String?
    let communities: [Community]?
    let collaborators: [UserCollaborator]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        email = try container.decode(String.self, forKey: .email)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        lastname = try container.decodeIfPresent(String.self, forKey: .lastname)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
        image = try container.decodeIfPresent(String.self, forKey: .image)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        communities = try container.decodeIfPresent([Community].self, forKey: .communities)
        collaborators = try container.decodeIfPresent([UserCollaborator].self, forKey: .collaborators)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case lastname
        case phone
        case image
        case type
        case createdAt
        case communities
        case collaborators
    }
}

struct Community: Decodable {
    let id: String
    let adminId: String
    let logo: String?
    let handle: String
    let name: String
    let email: String
    let phone: String
    let taxId: String
    let country: String
    let address: String
    let city: String
    let stat: String
    let zipCode: String
    let timestamp: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        adminId = try container.decode(String.self, forKey: .adminId)
        logo = try container.decodeIfPresent(String.self, forKey: .logo)
        handle = try container.decode(String.self, forKey: .handle)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        taxId = try container.decode(String.self, forKey: .taxId)
        country = try container.decode(String.self, forKey: .country)
        address = try container.decode(String.self, forKey: .address)
        city = try container.decode(String.self, forKey: .city)
        stat = try container.decode(String.self, forKey: .stat)
        zipCode = try container.decode(String.self, forKey: .zipCode)
        timestamp = try container.decode(String.self, forKey: .timestamp)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case adminId = "admin_id"
        case logo
        case handle
        case name
        case email
        case phone
        case taxId = "tax_id"
        case country
        case address
        case city
        case stat
        case zipCode = "zip_code"
        case timestamp
    }
}

struct UserCollaborator: Decodable {
    let id: String
    let handle: String
    let email: String
    let name: String
    let role: String
    let createdAt: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        handle = try container.decode(String.self, forKey: .handle)
        email = try container.decode(String.self, forKey: .email)
        name = try container.decode(String.self, forKey: .name)
        role = try container.decode(String.self, forKey: .role)
        createdAt = try container.decode(String.self, forKey: .createdAt)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case handle
        case email
        case name
        case role
        case createdAt = "createdAt"
    }
}

class UserService {
    static let shared = UserService()
    private init() {}

    func getProfile(token: String) async throws -> UserProfile {
        let url = URL(string: APIConstants.Users.profile)!
        print("Get profile URL:", url)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("Get profile request headers: Bearer token present")
            print(token)
        let (data, _) = try await URLSession.shared.data(for: request)
        let profile = try JSONDecoder().decode(UserProfile.self, from: data)
        print("Get profile response:", profile)

        return profile
    }

    func createProfile(token: String, imageUrl: String?, name: String, lastName: String, phone: String) async throws -> UserProfile {
        let url = URL(string: APIConstants.Users.createProfile)!
        print("Create profile URL:", url)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        var body: [String: Any] = [
            "name": name,
            "last_name": lastName,
            "phone": phone
        ]

        if let imageUrl = imageUrl {
            body["image_url"] = imageUrl
        }

        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        print("Create profile request body:", body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let profile = try JSONDecoder().decode(UserProfile.self, from: data)
        print("Create profile response:", profile)

        return profile
    }
}
