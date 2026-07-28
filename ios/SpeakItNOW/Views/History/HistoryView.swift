//
//  HistoryView.swift
//  SpeakItNOW
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()

    private var groupedSessions: [(date: Date, sessions: [InstantCompositionHistorySession])] {
        let grouped = Dictionary(grouping: viewModel.filteredSessions) {
            Calendar.current.startOfDay(for: $0.createdAt)
        }
        return grouped
            .map { (date: $0.key, sessions: $0.value) }
            .sorted { $0.date > $1.date }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.9)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("瞬間英作文の履歴")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)

                    filterBar

                    content
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .task {
            await viewModel.loadSessions()
        }
        .alert("履歴を読み込めませんでした", isPresented: errorBinding) {
            Button("閉じる", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var filterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(HistoryDifficultyFilter.allCases) { filter in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.selectedFilter = filter
                        }
                    } label: {
                        Text(filter.rawValue)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(viewModel.selectedFilter == filter ? .white : .white.opacity(0.7))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 9)
                            .background(viewModel.selectedFilter == filter ? Color.blue : Color.white.opacity(0.1))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.sessions.isEmpty {
            Spacer()
            ProgressView("履歴を読み込み中...")
                .tint(.white)
                .foregroundStyle(.white)
            Spacer()
        } else if groupedSessions.isEmpty {
            emptyView
        } else {
            List {
                ForEach(groupedSessions, id: \.date) { group in
                    Section {
                        ForEach(group.sessions) { session in
                            NavigationLink {
                                HistoryDetailView(session: session)
                            } label: {
                                HistorySessionCard(session: session)
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                            .swipeActions {
                                Button(role: .destructive) {
                                    Task {
                                        await viewModel.deleteSession(session)
                                    }
                                } label: {
                                    Label("削除", systemImage: "trash")
                                }
                            }
                        }
                    } header: {
                        Text(sectionTitle(for: group.date))
                            .font(.headline)
                            .foregroundStyle(.white.opacity(0.75))
                            .textCase(nil)
                            .padding(.horizontal, 4)
                    }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .refreshable {
                await viewModel.loadSessions()
            }
        }
    }

    private var emptyView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 52))
                .foregroundStyle(.white.opacity(0.45))
            Text(viewModel.selectedFilter == .all ? "まだ履歴がありません" : "該当する履歴がありません")
                .font(.title3.bold())
                .foregroundStyle(.white)
            Text("瞬間英作文をプレイすると、ここに結果が表示されます。")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.65))
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.horizontal, 32)
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.errorMessage = nil
                }
            }
        )
    }

    private func sectionTitle(for date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "今日"
        }
        if Calendar.current.isDateInYesterday(date) {
            return "昨日"
        }
        return date.formatted(.dateTime.year().month().day().weekday(.abbreviated))
    }
}

private struct HistorySessionCard: View {
    let session: InstantCompositionHistorySession

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.phraseText)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .lineLimit(2)

                    Text(session.createdAt.formatted(date: .omitted, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.55))
                }

                Spacer()

                scoreBadge
            }

            HStack(spacing: 8) {
                metadataBadge(session.difficulty, color: .blue)
                metadataBadge(session.scene, color: .purple)
                metadataBadge(session.formalLevel, color: .gray)
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var scoreBadge: some View {
        VStack(alignment: .trailing, spacing: 3) {
            Text("\(session.perfectCount) / \(session.logs.count)")
                .font(.headline.monospacedDigit())
                .foregroundStyle(session.isCompleted ? .green : .orange)
            Text(session.isCompleted ? "正解" : "\(session.answeredCount)問回答済み")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.6))
        }
    }

    private func metadataBadge(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.caption2.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(color.opacity(0.75))
            .clipShape(Capsule())
            .lineLimit(1)
    }
}

#Preview {
    HistoryView()
}
