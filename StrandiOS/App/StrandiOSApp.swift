import SwiftUI

@main
struct StrandiOSApp: App {
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var isTermsAccepted: Bool = UserDefaults.standard.bool(forKey: "has_accepted_terms")
    
    var body: some Scene {
        WindowGroup {
            iOSRootView()
                .environmentObject(localizationManager)
                .environment(\.locale, localizationManager.currentLanguage.locale)
                .environment(\.layoutDirection, localizationManager.currentLanguage.layoutDirection)
                .onAppear {
                    localizationManager.applyLanguageSettings()
                }
        }
    }
}

struct iOSRootView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WorkoutView()
                .tabItem {
                    Label(String(localized: "tab_workouts"), systemImage: "figure.crossreturns")
                }
                .tag(0)
            
            RecoveryView()
                .tabItem {
                    Label(String(localized: "tab_recovery"), systemImage: "heart.text.square")
                }
                .tag(1)
            
            DevicesView()
                .tabItem {
                    Label(String(localized: "tab_devices"), systemImage: "sensor.tag.radiowaves.forward")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label(String(localized: "tab_settings"), systemImage: "gearshape")
                }
                .tag(3)
        }
    }
}

struct WorkoutView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("workout_start")
                    .font(.headline)
                
                Button(action: {}) {
                    Text("workout_start")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .navigationTitle(Text("tab_workouts"))
        }
    }
}

struct RecoveryView: View {
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("sleep_score")
                    Spacer()
                    Text("88%")
                }
                HStack {
                    Text("recovery_score")
                    Spacer()
                    Text("92%")
                }
            }
            .navigationTitle(Text("tab_recovery"))
        }
    }
}

struct DevicesView: View {
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("device_whoop")
                    Spacer()
                    Text("connected")
                        .foregroundColor(.green)
                }
                HStack {
                    Text("device_oura")
                    Spacer()
                    Text("disconnected")
                        .foregroundColor(.red)
                }
            }
            .navigationTitle(Text("tab_devices"))
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("language_selection")) {
                    Picker("language_selection", selection: $localizationManager.currentLanguage) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.autonym).tag(language)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle(Text("tab_settings"))
        }
    }
}
