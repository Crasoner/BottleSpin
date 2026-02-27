import SwiftUI
import Combine

class AdManager: NSObject, ObservableObject {
    static let shared = AdManager()
    
    @Published var isAdRemoved: Bool = false
    
    private let removeAdsProductID = "remove_ads"
    
    override init() {
        super.init()
        loadAdRemovalStatus()
    }
    
    private func loadAdRemovalStatus() {
        isAdRemoved = UserDefaults.standard.bool(forKey: "isAdRemoved")
    }
    
    func purchaseRemoveAds() {
        UserDefaults.standard.set(true, forKey: "isAdRemoved")
        isAdRemoved = true
    }
}
