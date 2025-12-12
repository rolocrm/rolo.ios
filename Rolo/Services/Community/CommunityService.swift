import Foundation

struct CreateCommunityRequest: Codable {
    let logo: String?
    let handle: String
    let name: String
    let email: String
    let phone: String
    let tax_id: String?
    let country: String
    let address: String
    let city: String
    let stat: String
    let zip_code: String
}

struct CreateCommunityResponse: Codable {
    let id: String
    let admin_id: String
    let logo: String?
    let handle: String
    let name: String
    let email: String
    let phone: String
    let tax_id: String?
    let country: String
    let address: String
    let city: String
    let stat: String
    let zip_code: String
    let timestamp: String
}

struct CheckHandleResponse: Codable {
    let exists: Bool
    let available: Bool
}

struct GetRolesResponse: Codable {
    let roles: [String]
}

struct AddCollaboratorRequest: Codable {
    let handle: String
    let email: String
    let name: String
    let role: String
}

struct AddCollaboratorResponse: Codable {
    let id: String
    let handle: String
    let email: String
    let name: String
    let role: String
    let createdAt: String
}

class CommunityService {
    static let shared = CommunityService()
    private init() {}
    
    func createCommunity(token: String, request: CreateCommunityRequest) async throws -> CreateCommunityResponse {
        let url = URL(string: APIConstants.Communities.createCommunity)!
        print("Create community URL:", url)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let jsonData = try JSONEncoder().encode(request)
        urlRequest.httpBody = jsonData
        print("Create community request body:", String(data: jsonData, encoding: .utf8) ?? "")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Create community HTTP status:", httpResponse.statusCode)
        }
        
        print("Create community raw response:", String(data: data, encoding: .utf8) ?? "No data")
        
        do {
            let response = try JSONDecoder().decode(CreateCommunityResponse.self, from: data)
            print("Create community response:", response)
            return response
        } catch {
            print("Create community decode error:", error)
            print("Raw response data:", String(data: data, encoding: .utf8) ?? "No data")
            throw error
        }
    }
    
    func checkHandle(token: String, handle: String) async throws -> CheckHandleResponse {
        let url = URL(string: "\(APIConstants.Communities.checkHandle)/\(handle)")!
        print("Check handle URL:", url)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            let jsonString = String(data: data, encoding: .utf8) ?? "<non-utf8 data>"
            print("Check handle raw JSON:", jsonString)

            let response = try JSONDecoder().decode(CheckHandleResponse.self, from: data)
            print("Check handle response:", response)
            return response
        } catch {
            print("CommunityService | checkHandle() | error= \(error)")
            throw error
        }
    }
    
    func getRoles(token: String) async throws -> GetRolesResponse {
        let url = URL(string: APIConstants.Communities.getRoles)!
        print("Get roles URL:", url)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Get roles HTTP status:", httpResponse.statusCode)
        }
        
        print("Get roles raw response:", String(data: data, encoding: .utf8) ?? "No data")
        
        do {
            let response = try JSONDecoder().decode(GetRolesResponse.self, from: data)
            print("Get roles response:", response)
            return response
        } catch {
            print("Get roles decode error:", error)
            print("Raw response data:", String(data: data, encoding: .utf8) ?? "No data")
            throw error
        }
    }
    
    func addCollaborator(token: String, request: AddCollaboratorRequest) async throws -> AddCollaboratorResponse {
        let url = URL(string: APIConstants.Communities.addCollaborator)!
        print("Add collaborator URL:", url)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.post.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let jsonData = try JSONEncoder().encode(request)
        urlRequest.httpBody = jsonData
        print("Add collaborator request body:", String(data: jsonData, encoding: .utf8) ?? "")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Add collaborator HTTP status:", httpResponse.statusCode)
        }
        
        print("Add collaborator raw response:", String(data: data, encoding: .utf8) ?? "No data")
        
        do {
            let response = try JSONDecoder().decode(AddCollaboratorResponse.self, from: data)
            print("Add collaborator response:", response)
            return response
        } catch {
            print("Add collaborator decode error:", error)
            print("Raw response data:", String(data: data, encoding: .utf8) ?? "No data")
            throw error
        }
    }
}
