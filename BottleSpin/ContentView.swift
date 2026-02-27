import SwiftUI

struct ContentView: View {
    @StateObject private var adManager = AdManager.shared
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                BottleView()
                
                if !adManager.isAdRemoved {
                    AdPlaceholderView()
                        .frame(height: 50)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                            .font(.title)
                    }
                }
            }
        }
    }
}

struct AdPlaceholderView: View {
    var body: some View {
        Text("广告位")
            .font(.caption)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.gray.opacity(0.3))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
