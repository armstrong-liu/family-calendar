//
//  CreateEventView.swift
//  FamilyCalendar
//
//  Created by FamilyCalendar
//

import SwiftUI

/// 创建事项视图
struct CreateEventView: View {
    @StateObject private var viewModel: CreateEventViewModel
    @Environment(\.dismiss) var dismiss

    let onSave: (() -> Void)?

    init(familyID: String? = nil, onSave: (() -> Void)? = nil) {
        let familyID = familyID ?? UserDefaults.standard.string(forKey: "currentFamilyID") ?? ""
        _viewModel = StateObject(wrappedValue: CreateEventViewModel(familyID: familyID))
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("事项信息")) {
                    TextField("标题", text: $viewModel.title)
                        .textInputAutocapitalization(.sentences)

                    TextField("描述", text: $viewModel.eventDescription, axis: .vertical)
                        .lineLimit(3...6)

                    TextField("地点", text: $viewModel.location)
                }

                Section(header: Text("时间")) {
                    DatePicker("开始时间", selection: $viewModel.startDate)

                    DatePicker("结束时间", selection: $viewModel.endDate)

                    Toggle("设置提醒", isOn: $viewModel.hasReminder)

                    if viewModel.hasReminder {
                        DatePicker("提醒时间", selection: $viewModel.reminderTime)
                    }
                }

                Section(header: Text("分类")) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(viewModel.availableCategories, id: \.self) { category in
                            CategoryButton(
                                category: category,
                                isSelected: viewModel.selectedCategory == category
                            ) {
                                viewModel.selectedCategory = category
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("创建事项")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        Task {
                            if await viewModel.createEvent() {
                                onSave?()
                                dismiss()
                            }
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .disabled(viewModel.isLoading)
            .overlay {
                if viewModel.isLoading {
                    ProgressView("创建中...")
                }
            }
        }
    }
}

/// 分类按钮
struct CategoryButton: View {
    let category: EventCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(category.icon)
                    .font(.title)

                Text(category.rawValue)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSelected ? Color.orange.opacity(0.1) : Color(uiColor: .systemGray6))
            .foregroundColor(isSelected ? .orange : .primary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
            )
        }
    }
}

#Preview {
    CreateEventView {
        print("Saved")
    }
}
