//
//  LoginView.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import SwiftUI
import AuthenticationServices

/// 登录视图
struct LoginView: View {
    @StateObject private var authService = AuthService.shared
    @State private var isLoading = false
    @State private var showError = false

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()

                // Logo和标题
                VStack(spacing: 16) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 80))
                        .foregroundColor(.orange)

                    Text("家庭日历")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("让家庭沟通更简单")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // 功能介绍
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRow(icon: "calendar", title: "共享日历", description: "与家人共享日程安排")

                    FeatureRow(icon: "bell", title: "即时通知", description: "不错过任何重要事项")

                    FeatureRow(icon: "checkmark.circle", title: "快速响应", description: "一键确认参与或拒绝")

                    FeatureRow(icon: "person.2", title: "家庭专属", description: "安全私密的家庭空间")
                }
                .padding()

                Spacer()

                // 登录按钮
                VStack(spacing: 16) {
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        handleSignInResult(result)
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 50)
                    .cornerRadius(8)

                    Text("登录即表示同意《用户协议》和《隐私政策》")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()

            }
            .navigationTitle("登录")
            .navigationBarHidden(true)
            .disabled(isLoading)
            .overlay {
                if isLoading {
                    ProgressView("登录中...")
                }
            }
            .alert("登录失败", isPresented: $showError) {
                Button("确定", role: .cancel) { }
            } message: {
                if let error = authService.errorMessage {
                    Text(error)
                }
            }
        }
    }

    private func handleSignInResult(_ result: Result<ASAuthorization, Error>) {
        isLoading = true

        Task {
            do {
                switch result {
                case .success(let authorization):
                    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                        _ = try await authService.signInWithApple()
                        isLoading = false
                    }
                case .failure(let error):
                    authService.errorMessage = error.localizedDescription
                    isLoading = false
                    showError = true
                }
            }
        }
    }
}

/// 功能介绍行
struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.orange)
                .frame(width: 44, height: 44)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }
}

#Preview {
    LoginView()
}
