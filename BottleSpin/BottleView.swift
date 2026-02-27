import SwiftUI

struct BottleView: View {
    @State private var isSpinning = false
    @State private var rotationAngle: Double = 0
    @State private var spinCount = 0
    @State private var isLongPressing = false
    @State private var chargeProgress: CGFloat = 0
    @State private var chargeTimer: Timer?
    @State private var pressStartTime: Date?
    
    private let minSpinDuration: Double = 3.0
    private let maxSpinDuration: Double = 10.0
    
    private var spinDuration: Double {
        guard let startTime = pressStartTime else { return minSpinDuration }
        let pressDuration = Date().timeIntervalSince(startTime)
        let duration = minSpinDuration + pressDuration
        return min(duration, maxSpinDuration)
    }
    
    private func getRotations(for duration: Double) -> Double {
        if duration <= 3 {
            return 10
        } else if duration <= 5 {
            return 10 + (duration - 3) * 5
        } else {
            return min(20 + (duration - 5) * 4, 40)
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    if chargeProgress > 0 {
                        ChargeCircle(progress: chargeProgress)
                            .frame(width: 1200, height: 1200)
                    }
                    
                    Image("bottle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 240, height: 360)
                        .rotationEffect(.degrees(rotationAngle))
                }
                .onLongPressGesture(minimumDuration: 0.1, pressing: { pressing in
                    if pressing && !isSpinning {
                        isLongPressing = true
                        pressStartTime = Date()
                        startCharging()
                    } else if !pressing && isLongPressing {
                        isLongPressing = false
                        stopCharging()
                    }
                }, perform: {})
                .onTapGesture {
                    if !isSpinning && !isLongPressing {
                        startSpin(duration: minSpinDuration)
                    }
                }
                
                Text(isSpinning ? "旋转中..." : "点击瓶子开始旋转")
                    .font(.title3)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding()
        }
    }
    
    private func startCharging() {
        chargeProgress = 0
        chargeTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            guard let startTime = pressStartTime else { return }
            let elapsed = Date().timeIntervalSince(startTime)
            let progress = min(elapsed / maxSpinDuration, 1.0)
            chargeProgress = CGFloat(progress)
        }
    }
    
    private func stopCharging() {
        chargeTimer?.invalidate()
        chargeTimer = nil
        
        let duration = spinDuration
        chargeProgress = 0
        pressStartTime = nil
        
        startSpin(duration: duration)
    }
    
    private func startSpin(duration: Double) {
        isSpinning = true
        spinCount += 1
        
        let rotations = getRotations(for: duration)
        let totalDegrees = rotations * 360
        let randomOffset = Double.random(in: 0..<360)
        let finalAngle = rotationAngle + totalDegrees + randomOffset
        
        let accelerateTime = duration * 0.15
        let decelerateTime = duration * 0.25
        let constantTime = duration - accelerateTime - decelerateTime
        
        withAnimation(.easeIn(duration: accelerateTime)) {
            rotationAngle = finalAngle - (totalDegrees * 0.3)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + accelerateTime) {
            withAnimation(.linear(duration: constantTime)) {
                rotationAngle = finalAngle - (totalDegrees * 0.1)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + accelerateTime + constantTime) {
            withAnimation(.easeOut(duration: decelerateTime)) {
                rotationAngle = finalAngle
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            isSpinning = false
        }
    }
}

struct ChargeCircle: View {
    let progress: CGFloat
    
    var body: some View {
        Circle()
            .fill(chargeColor)
            .frame(width: chargeSize, height: chargeSize)
    }
    
    private var chargeSize: CGFloat {
        200 + progress * 950
    }
    
    private var chargeColor: Color {
        Color(red: 0.4, green: 0.5, blue: 1.0 - progress * 0.5)
            .opacity(0.3 + progress * 0.4)
    }
}

struct BottleView_Previews: PreviewProvider {
    static var previews: some View {
        BottleView()
    }
}
