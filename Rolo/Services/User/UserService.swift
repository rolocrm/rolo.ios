import Foundation
import SwiftUI
import SwiftData

extension Collection where Element: CustomDebugStringConvertible {
    var debugBlock: String {
        if isEmpty {
            return "[]"
        }

        let joined = self
            .map { $0.debugDescription }
            .joined(separator: ",\n")
            .split(separator: "\n")
            .map { "    " + $0 } // небольшой отступ внутрь массива
            .joined(separator: "\n")

        return "[\n\(joined)\n  ]"
    }
}

@Model
final class UserProfile: Decodable, CustomDebugStringConvertible {
    @Attribute(.unique)
    let id: String
    var email: String
    var name: String?
    var lastname: String?
    var phone: String?
    var imageStringURL: String?
    var type: String?
    var createdAt: String?
    @Relationship(inverse: \Community.userProfile)
    var communities: [Community]?
    @Relationship(inverse: \UserCollaborator.userProfile)
    var collaborators: [UserCollaborator]?

    // local data
    var imageData: Data?

    //    var uiImage: UIImage? {
    //        guard let imageData else { return nil }
    //        return UIImage(data: imageData)
    //    }

    init(
        id: String,
        email: String,
        name: String?,
        lastname: String?,
        phone: String?,
        imageStringURL: String?,
        uiImage: Data?,
        type: String?,
        createdAt: String?,
        communities: [Community]?,
        collaborators: [UserCollaborator]?
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.lastname = lastname
        self.phone = phone
        self.imageStringURL = imageStringURL
        self.imageData = nil
        self.type = type
        self.createdAt = createdAt
        self.communities = communities
        self.collaborators = collaborators
    }

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case lastname
        case phone
        case imageStringURL = "image"
        case type
        case createdAt
        case communities
        case collaborators
    }

    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let email = try container.decode(String.self, forKey: .email)
        let name = try container.decodeIfPresent(String.self, forKey: .name)
        let lastname = try container.decodeIfPresent(String.self, forKey: .lastname)
        let phone = try container.decodeIfPresent(String.self, forKey: .phone)
        let imageStringURL = try container.decodeIfPresent(String.self, forKey: .imageStringURL)
        let type = try container.decodeIfPresent(String.self, forKey: .type)
        let createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        let communities = try container.decodeIfPresent([Community].self, forKey: .communities)
        let collaborators = try container.decodeIfPresent([UserCollaborator].self, forKey: .collaborators)

        self.init(
            id: id,
            email: email,
            name: name,
            lastname: lastname,
            phone: phone,
            imageStringURL: imageStringURL,
            uiImage: nil,
            type: type,
            createdAt: createdAt,
            communities: communities,
            collaborators: collaborators
        )
    }

    var debugDescription: String {
        let communitiesBlock = communities?.debugBlock ?? "[]"
        let collaboratorsBlock = collaborators?.debugBlock ?? "[]"

        return """
            UserProfile(
              id: \(id),
              email: \(email),
              name: \(name ?? "nil"),
              lastname: \(lastname ?? "nil"),
              phone: \(phone ?? "nil"),
              imageStringURL: \(imageStringURL ?? "nil"),
              type: \(type ?? "nil"),
              createdAt: \(createdAt ?? "nil"),
              communitiesCount: \(communities?.count ?? 0),
              communities: \(communitiesBlock),
              collaboratorsCount: \(collaborators?.count ?? 0),
              collaborators: \(collaboratorsBlock),
              imageData: \(imageData?.count ?? 0) bytes
            )
            """
    }

}

@Model
final class Community: Decodable, CustomDebugStringConvertible {
    @Attribute(.unique)
    let id: String
    var adminId: String
    var logo: String?
    var handle: String
    var name: String
    var email: String
    var phone: String
    var taxId: String?
    var country: String
    var address: String
    var city: String
    var stat: String
    var zipCode: String
    var timestamp: String

    @Relationship var userProfile: UserProfile?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        adminId = try container.decode(String.self, forKey: .adminId)
        logo = try container.decodeIfPresent(String.self, forKey: .logo)
        handle = try container.decode(String.self, forKey: .handle)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        taxId = try container.decodeIfPresent(String.self, forKey: .taxId)
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

    var debugDescription: String {
        """
        Community(
          id: \(id),
          adminId: \(adminId),
          logo: \(logo ?? "nil"),
          handle: \(handle),
          name: \(name),
          email: \(email),
          phone: \(phone),
          taxId: \(taxId ?? "nil"),
          country: \(country),
          address: \(address),
          city: \(city),
          stat: \(stat),
          zipCode: \(zipCode),
          timestamp: \(timestamp)
        )
        """
    }
}

@Model
final class UserCollaborator: Decodable, CustomDebugStringConvertible {
    @Attribute(.unique)
    let id: String
    var handle: String
    var email: String
    var name: String
    var role: String
    var createdAt: String

    @Relationship var userProfile: UserProfile?

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

    var debugDescription: String {
        """
        UserCollaborator(
          id: \(id),
          handle: \(handle),
          email: \(email),
          name: \(name),
          role: \(role),
          createdAt: \(createdAt)
        )
        """
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
