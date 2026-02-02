//
//  AuthService.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import Foundation
import AuthenticationServices
import CryptoKit

/// 认证服务
class AuthService: NSObject, ObservableObject {
    static let shared = AuthService()

    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var currentNonce: String?

    private override init() {
        super.init()
        checkAuthenticationStatus()
    }

    // MARK: - Authentication Check

    private func checkAuthenticationStatus() {
        if let user = User.loadCurrent() {
            currentUser = user
            isAuthenticated = true
        }
    }

    // MARK: - Sign in with Apple

    /// 执行Apple ID登录
    func signInWithApple() async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            let nonce = randomNonceString()
            currentNonce = nonce

            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self

            authorizationController.performRequests { result in
                switch result {
                case .success(let authorization):
                    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                        let user = self.createUserFrom(appleIDCredential: appleIDCredential)
                        Task {
                            do {
                                // 保存到CloudKit
                                try await CloudKitManager.shared.saveUser(user)
                                User.saveCurrent(user)

                                await MainActor.run {
                                    self.currentUser = user
                                    self.isAuthenticated = true
                                }

                        continuation.resume(returning: user)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
                } else {
                    continuation.resume(throwing: AuthError.unknownError)
                }

                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func createUserFrom(appleIDCredential: ASAuthorizationAppleIDCredential) -> User {
        let userID = appleIDCredential.user
        let email = appleIDCredential.email
        let fullName = appleIDCredential.fullName

        let nickname = [fullName?.givenName, fullName?.familyName]
            .compactMap { $0 }
            .joined(separator: "")

        return User(
            id: userID,
            phoneNumber: nil,
            appleID: userID,
            nickname: nickname.isEmpty ? "用户" : nickname,
            avatarURL: nil,
            createdAt: Date(),
            lastLoginAt: Date()
        )
    }

    // MARK: - Sign Out

    /// 退出登录
    func signOut() {
        currentUser = nil
        isAuthenticated = false
        User.clearCurrent()
        UserDefaults.standard.removeObject(forKey: "currentFamilyID")
    }

    // MARK: - Nonce Generation

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                _ = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                return random
            }

            for random in randoms {
                if remainingLength == 0 {
                    break
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}

// MARK: - ASAuthorizationControllerDelegate

extension AuthService: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // 处理在continuation中
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        errorMessage = error.localizedDescription
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding

extension AuthService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return UIWindow()
        }
        return window
    }
}

// MARK: - AuthError

enum AuthError: LocalizedError {
    case unknownError
    case notAuthenticated
    case cancelled

    var errorDescription: String? {
        switch self {
        case .unknownError:
            return "发生未知错误"
        case .notAuthenticated:
            return "未登录"
        case .cancelled:
            return "用户取消"
        }
    }
}
