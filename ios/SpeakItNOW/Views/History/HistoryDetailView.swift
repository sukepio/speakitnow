//
//  HistoryDetailView.swift
//  SpeakItNOW
//

import SwiftUI

struct HistoryDetailView: View {
    let session: InstantCompositionHistorySession
    @StateObject private var speaker = ConversationSpeaker()

    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    summaryCard

                    ForEach(session.logs) { log in
                        HistoryLogCard(log: log) { text in
                            speaker.speak(text)
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("履歴詳細")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onDisappear {
            speaker.stop()
        }
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(session.phraseText)
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    Text(session.createdAt.formatted(date: .long, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(session.perfectCount) / \(session.logs.count)")
                        .font(.title2.bold().monospacedDigit())
                        .foregroundStyle(.green)
                    Text("正解")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }
            }

            Divider()
                .overlay(.white.opacity(0.15))

            Text("\(session.difficulty) ・ \(session.scene) ・ \(session.formalLevel)")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white.opacity(0.8))
        }
        .padding(18)
        .background(Color.white.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

private struct HistoryLogCard: View {
    let log: InstantCompositionHistoryLog
    let onSpeak: (String) -> Void

    private var statusColor: Color {
        guard let isPerfect = log.isPerfect else { return .gray }
        return isPerfect ? .green : .orange
    }

    private var statusIcon: String {
        guard let isPerfect = log.isPerfect else { return "minus.circle.fill" }
        return isPerfect ? "checkmark.circle.fill" : "pencil.circle.fill"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: statusIcon)
                    .font(.title3)
                    .foregroundStyle(statusColor)

                Text(log.questionJa)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)
            }

            answerSection(
                title: "あなたの回答",
                text: log.userAnswerEn ?? "未回答",
                color: log.isAnswered ? .white : .white.opacity(0.45),
                canSpeak: log.isPerfect == true && log.userAnswerEn != nil
            )

            answerSection(
                title: "回答例",
                text: log.modelAnswerEn,
                color: .green,
                canSpeak: true
            )

            if let feedback = log.feedback, !feedback.isEmpty {
                Divider()
                    .overlay(.white.opacity(0.15))

                VStack(alignment: .leading, spacing: 6) {
                    Label("解説", systemImage: "lightbulb.fill")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.orange)
                    Text(feedback)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            if !log.alternativeAnswers.isEmpty {
                Divider()
                    .overlay(.white.opacity(0.15))

                VStack(alignment: .leading, spacing: 7) {
                    Text("別の表現例")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.55))
                    ForEach(log.alternativeAnswers, id: \.self) { answer in
                        Text("・\(answer)")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.85))
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func answerSection(
        title: String,
        text: String,
        color: Color,
        canSpeak: Bool
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.55))

                Spacer()

                if canSpeak {
                    Button {
                        onSpeak(text)
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundStyle(.blue)
                            .padding(7)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(title)を再生")
                }
            }

            Text(text)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(color)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
