import SwiftUI

struct SettingsView: View {
    @StateObject private var adManager = AdManager.shared
    @State private var showPurchaseAlert = false
    @State private var purchaseSuccess = false
    
    var body: some View {
        List {
            Section("关于") {
                Text("版本 1.0.0")
                Text("© 2026 瓶子旋转")
            }
            
            Section("商业化") {
                Button(action: {
                    if !adManager.isAdRemoved {
                        showPurchaseAlert = true
                    }
                }) {
                    HStack {
                        Text(adManager.isAdRemoved ? "已移除广告" : "移除广告 (¥6)")
                        Spacer()
                        Image(systemName: adManager.isAdRemoved ? "checkmark.circle.fill" : "xmark.circle")
                            .foregroundColor(adManager.isAdRemoved ? .green : .blue)
                    }
                }
                .disabled(adManager.isAdRemoved)
            }
        }
        .navigationTitle("设置")
        .alert("移除广告", isPresented: $showPurchaseAlert) {
            Button("取消", role: .cancel) {}
            Button("购买 ¥6") {
                adManager.purchaseRemoveAds()
                purchaseSuccess = true
            }
        } message: {
            Text("确认以 ¥6 购买移除广告？")
        }
        .alert("购买成功", isPresented: $purchaseSuccess) {
            Button("确定", role: .cancel) {}
        } message: {
            Text("广告已成功移除，感谢您的支持！")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
