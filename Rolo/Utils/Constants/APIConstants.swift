import Foundation

enum APIConstants {
    private static let baseURL = "https://api.tryrolo.com"

    enum Auth {
        static let signup = "\(baseURL)/auth/signup"
        static let login = "\(baseURL)/auth/login"
        static let googleLogin = "\(baseURL)/auth/googleLogin"
        static let googleSignUp = "\(baseURL)/auth/googleSignUp"
        static let deleteAccount = "\(baseURL)/auth/deleteAccount"
    }

    enum Users {
        static let profile = "\(baseURL)/users/profile"
        static let createProfile = "\(baseURL)/users/createProfile"
    }

    enum Files {
        static let upload = "\(baseURL)/files"
        static let get = "\(baseURL)/files/get"
    }
    
    enum Communities {
        static let createCommunity = "\(baseURL)/communities/createCommunity"
        static let checkHandle = "\(baseURL)/communities/checkHandle"
        static let getRoles = "\(baseURL)/communities/getRoles"
        static let addCollaborator = "\(baseURL)/communities/addCollaborator"
        static let deleteCommunity = "\(baseURL)/communities/deleteCommunity"
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
