//
//  FamilyView.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import SwiftUI

/// 家庭视图
struct FamilyView: View {
    @StateObject private var viewModel = FamilyViewModel()
    @State private var showingCreateFamily = false
    @State private var showingJoinFamily = false
    @State private var showingInviteSheet = false

    var body: some View {
        NavigationView {
            List {
                if let family = viewModel.currentFamily {
                    currentFamilySection(family)

                    membersSection

                    if viewModel.isAdmin() {
                        adminSection
                    }
                } else {
                    emptyStateSection
                }
            }
            .navigationTitle("家庭")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.currentFamily == nil {
                        Menu {
                            Button("创建家庭") {
                                showingCreateFamily = true
                            }
                            Button("加入家庭") {
                                showingJoinFamily = true
                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCreateFamily) {
                CreateFamilySheet { name in
                    Task {
                        _ = await viewModel.createFamily(name: name)
                    }
                }
            }
            .sheet(isPresented: $showingJoinFamily) {
                JoinFamilySheet { code in
                    Task {
                        _ = await viewModel.joinFamily(inviteCode: code)
                    }
                }
            }
            .sheet(isPresented: $showingInviteSheet) {
                InviteCodeSheet(code: viewModel.inviteCode)
            }
        }
    }

    private func currentFamilySection(_ family: Family) -> some View {
        Section {
            HStack(spacing: 12) {
                Image(systemName: "house.fill")
                    .font(.title)
                    .foregroundColor(.orange)
                    .frame(width: 44, height: 44)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)

                VStack(alignment: .leading, spacing: 4) {
                    Text(family.name)
                        .font(.headline)

                    Text("\(family.memberCount) 位成员")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if viewModel.isAdmin() {
                    Text("管理员")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.1))
                        .foregroundColor(.orange)
                        .cornerRadius(8)
                }
            }
        }
    }

    private var membersSection: some View {
        Section(header: Text("家庭成员")) {
            ForEach(viewModel.members) { member in
                MemberRow(member: member)
            }
        }
    }

    private var adminSection: some View {
        Section {
            Button(action: {
                viewModel.getInviteCode()
            }) {
                HStack {
                    Image(systemName: "qrcode")
                        .foregroundColor(.orange)
                    Text("邀请家人")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    private var emptyStateSection: some View {
        Section {
            VStack(spacing: 16) {
                Image(systemName: "house")
                    .font(.system(size: 50))
                    .foregroundColor(.secondary)

                Text("还没有家庭")
                    .font(.headline)

                Text("创建一个家庭或加入现有家庭，\n开始与家人共享日程")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                Button("创建家庭") {
                    showingCreateFamily = true
                }
                .buttonStyle(.borderedProminent)

                Button("加入家庭") {
                    showingJoinFamily = true
                }
                .buttonStyle(.bordered)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
        }
    }
}

/// 成员行
struct MemberRow: View {
    let member: FamilyMember

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.orange.opacity(0.2))
                .frame(width: 44, height: 44)
                .overlay(
                    Text(String(member.nickname.prefix(1)))
                        .foregroundColor(.orange)
                        .font(.headline)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(member.nickname)
                    .font(.body)

                Text(member.role.displayName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if member.notificationEnabled {
                Image(systemName: "bell.fill")
                    .foregroundColor(.orange)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
}

/// 创建家庭表单
struct CreateFamilySheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var familyName = ""
    let onCreate: (String) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("创建家庭")) {
                    TextField("家庭名称", text: $familyName)
                        .textInputAutocapitalization(.sentences)
                }
            }
            .navigationTitle("创建家庭")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("创建") {
                        onCreate(familyName)
                        dismiss()
                    }
                    .disabled(familyName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

/// 加入家庭表单
struct JoinFamilySheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var inviteCode = ""
    let onJoin: (String) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("加入家庭"), footer: Text("请输入家庭邀请码（6位字母数字组合）")) {
                    TextField("邀请码", text: $inviteCode)
                        .textInputAutocapitalization(.allCharacters)
                }
            }
            .navigationTitle("加入家庭")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("加入") {
                        onJoin(inviteCode.uppercased())
                        dismiss()
                    }
                    .disabled(inviteCode.count != 6)
                }
            }
        }
    }
}

/// 邀请码视图
struct InviteCodeSheet: View {
    @Environment(\.dismiss) var dismiss
    let code: String

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("邀请家人加入")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("扫描二维码或分享邀请码给家人")
                    .foregroundColor(.secondary)

                // 模拟二维码
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black)
                    .frame(width: 200, height: 200)
                    .overlay(
                        VStack(spacing: 8) {
                            ForEach(0..<8) { _ in
                                HStack(spacing: 8) {
                                    ForEach(0..<8) { _ in
                                        Circle()
                                            .fill(Bool.random() ? .white : .clear)
                                            .frame(width: 12, height: 12)
                                    }
                                }
                            }
                        }
                        .padding(16)
                    )

                // 邀请码
                VStack(spacing: 8) {
                    Text("邀请码")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(code)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color(uiColor: .systemGray6))
                        .cornerRadius(8)

                    Button("复制邀请码") {
                        UIPasteboard.general.string = code
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 20)

                Spacer()
            }
            .padding()
            .navigationTitle("邀请家人")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FamilyView()
}
