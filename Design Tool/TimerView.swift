import SwiftUI
import Foundation
import Combine

struct TimerView: View {
    @ObservedObject var viewModel: TimerViewModel
    @State private var showingEdit = false
    private let customFontName = "Inter" // 自定义字体名称
    
    var body: some View {
        VStack(spacing: 0) {
            // 会话标题
            Text(viewModel.sessions[viewModel.currentSessionIndex].title)
                .font(.custom(customFontName, size: 24)) // 使用自定义字体
                .frame(maxWidth: .infinity)
                .background(Color.black)
            
            // 计时器显示
            Text(timeString(time: viewModel.remainingTime))
                .font(.custom(customFontName, size: 100).weight(.bold)) // 自定义字体
                .foregroundColor(.white)
                .padding()
            
            // 控制按钮
            HStack {
                Button(action: {
                    hapticFeedback()
                    viewModel.previousSession()
                }) {
                    Image(systemName: "backward.fill")
                        .font(.title)
                        .padding()
                }
                .disabled(viewModel.currentSessionIndex == 0)
                .foregroundColor(viewModel.currentSessionIndex == 0 ? .gray : .white)
                
                Spacer()
                
                Button(action: {
                    hapticFeedback()
                    viewModel.isRunning ? viewModel.pause() : viewModel.start()
                }) {
                    Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                        .font(.title)
                        .padding()
                }
                .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    hapticFeedback()
                    viewModel.nextSession()
                }) {
                    Image(systemName: "forward.fill")
                        .font(.title)
                        .padding()
                }
                .disabled(viewModel.currentSessionIndex == viewModel.sessions.count - 1)
                .foregroundColor(viewModel.currentSessionIndex == viewModel.sessions.count - 1 ? .gray : .white)
            }
            .padding(.horizontal, 30)
        }
        .frame(width: 350, height: 350)
        .padding(.vertical, 10)
        .foregroundColor(.white)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .cornerRadius(25)
        .padding(.horizontal, 20)
        .shadow(radius: 5)

        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    hapticFeedback()
                    showingEdit.toggle()
                }) {
                    Image(systemName: "pencil")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding()
                }
                .foregroundColor(.black)
            }
        }
        .sheet(isPresented: $showingEdit) {
            EditSessionsView(viewModel: viewModel)
        }
    }
    
    // 计时器格式化
    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    // MARK: - 触觉反馈
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

class TimerViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var currentSessionIndex: Int = 0
    @Published var remainingTime: TimeInterval = 0
    @Published var isRunning: Bool = false
    
    private var timer: Timer?
    
    init() {
        loadSessions()
        if let firstSession = sessions.first {
            self.remainingTime = firstSession.duration
        }
    }
    
    // MARK: - 数据持久化
    func loadSessions() {
        if let data = UserDefaults.standard.data(forKey: "sessions"),
           let decoded = try? JSONDecoder().decode([Session].self, from: data) {
            self.sessions = decoded
        } else {
            loadDefaultSessions()
        }
    }
    
    func saveSessions() {
        if let encoded = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(encoded, forKey: "sessions")
        }
    }
    
    // MARK: - 默认会话
    func loadDefaultSessions() {
        // 加载默认会话
        sessions = [
            Session(title: "Introduction", duration: 800, isBreak: false),
            Session(title: "Session 1", duration: 900, isBreak: false),
            Session(title: "Break", duration: 120, isBreak: true),
            Session(title: "Session 2", duration: 900, isBreak: false),
            Session(title: "Feedback", duration: 300, isBreak: false),
            Session(title: "Wrap up", duration: 90, isBreak: false)
        ]
        saveSessions()
    }
    
    // MARK: - 计时器控制
    func start() {
        guard !isRunning else { return }
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.tick()
        }
    }
    
    func pause() {
        isRunning = false
        timer?.invalidate()
    }
    
    func stop() {
        isRunning = false
        timer?.invalidate()
        resetCurrentSession()
    }
    
    func reset() {
        stop()
        currentSessionIndex = 0
        resetCurrentSession()
    }
    
    private func tick() {
        if remainingTime > 0 {
            remainingTime -= 1
        } else {
            timer?.invalidate()
            isRunning = false
            // 触发会话结束动作
            nextSession()
            // 可选：添加本地通知或其他提示
        }
    }
    
    func nextSession() {
        if currentSessionIndex + 1 < sessions.count {
            currentSessionIndex += 1
            resetCurrentSession()
            // 可选：自动开始下一个会话
            // start()
        } else {
            // 所有会话完成，重置
            reset()
        }
    }
    
    func previousSession() {
        if currentSessionIndex > 0 {
            currentSessionIndex -= 1
            resetCurrentSession()
        }
    }
    
    private func resetCurrentSession() {
        if sessions.indices.contains(currentSessionIndex) {
            remainingTime = sessions[currentSessionIndex].duration
            saveSessions()
        }
    }
    
    // MARK: - 会话管理
    func addSession(title: String, duration: TimeInterval, isBreak: Bool) {
        let newSession = Session(title: title, duration: duration, isBreak: isBreak)
        sessions.append(newSession)
        saveSessions()
    }
    
    func updateSession(session: Session) {
        if let index = sessions.firstIndex(where: { $0.id == session.id }) {
            sessions[index] = session
            saveSessions()
        }
    }
    
    func deleteSession(at offsets: IndexSet) {
        sessions.remove(atOffsets: offsets)
        saveSessions()
        reset()
    }
}

struct EditSessionsView: View {
    @ObservedObject var viewModel: TimerViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAddSession = false
    @State private var editSession: Session?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.sessions) { session in
                    Button(action: {
                        hapticFeedback()
                        editSession = session
                    }) {
                        HStack {
                            Text(session.title)
                            Spacer()
                            Text("\(Int(session.duration) / 60) min")
                            if session.isBreak {
                                Text("Break")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .padding(4)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                        }
                        .foregroundColor(.black)
                    }
                }
                .onDelete(perform: deleteSession)
            }
            .navigationBarTitle("Edit", displayMode: .inline)
            .navigationBarItems(leading:
                Button("Cancel") {
                    hapticFeedback()
                    presentationMode.wrappedValue.dismiss()
                },
                trailing:
                Button(action: {
                    hapticFeedback()
                    showingAddSession.toggle()
                }) {
                    Image(systemName: "plus")
                }
                .foregroundColor(.black)
            )
            .sheet(isPresented: $showingAddSession) {
                AddEditSessionView(viewModel: viewModel)
            }
            .sheet(item: $editSession) { session in
                AddEditSessionView(viewModel: viewModel, sessionToEdit: session)
            }
        }
    }
    
    private func deleteSession(at offsets: IndexSet) {
        viewModel.deleteSession(at: offsets)
        hapticFeedback()
    }
    
    // MARK: - 触觉反馈
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}


struct AddEditSessionView: View {
    @ObservedObject var viewModel: TimerViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title: String = ""
    @State private var duration: String = ""
    @State private var isBreak: Bool = false
    
    var sessionToEdit: Session?
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Session Title", text: $title)
                TextField("Duration(min)", text: $duration)
                    .keyboardType(.numberPad)
                Toggle("Break", isOn: $isBreak)
            }
            .navigationBarTitle(sessionToEdit == nil ? "Add Session" : "Edit Session", displayMode: .inline)
            .navigationBarItems(leading:
                Button("Cancel") {
                    hapticFeedback()
                    presentationMode.wrappedValue.dismiss()
                },
                trailing:
                Button("Save") {
                    hapticFeedback()
                    saveSession()
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(!isFormValid())
                .foregroundColor(.black)
            )
            .onAppear {
                if let session = sessionToEdit {
                    title = session.title
                    duration = "\(Int(session.duration / 60))"
                    isBreak = session.isBreak
                }
            }
        }
    }
    
    private func saveSession() {
        guard let durationInMinutes = Double(duration) else { return }
        if let session = sessionToEdit {
            let updatedSession = Session(id: session.id, title: title, duration: durationInMinutes * 60, isBreak: isBreak)
            viewModel.updateSession(session: updatedSession)
        } else {
            viewModel.addSession(title: title, duration: durationInMinutes * 60, isBreak: isBreak)
        }
    }
    
    private func isFormValid() -> Bool {
        return !title.trimmingCharacters(in: .whitespaces).isEmpty &&
               (Double(duration) != nil && Double(duration)! > 0)
    }
    
    // MARK: - 触觉反馈
    private func hapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}
