import SwiftUI

struct BottleView: View {
    @State private var isSpinning = false
    @State private var rotationAngle: Double = 0
    @State private var spinCount = 0
    @State private var isLongPressing = false
    @State private var chargeProgress: CGFloat = 0
    
    private let minSpinDuration: Double = 3.0
    private let maxSpinDuration: Double = 10.0
    private var spinDuration: Double {
        minSpinDuration + (maxSpinDuration - minSpinDuration) * Double(chargeProgress)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 40) {
                Spacer()
                
                ZStack {
                    if chargeProgress > 0 {
                        ChargeCircle(progress: chargeProgress)
                            .frame(width: 300, height: 300)
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
        withAnimation(.linear(duration: maxSpinDuration)) {
            chargeProgress = 1.0
        }
    }
    
    private func stopCharging() {
        chargeProgress = 0
        startSpin(duration: spinDuration)
    }
    
    private func startSpin(duration: Double) {
        isSpinning = true
        spinCount += 1
        
        let randomRotations = Double.random(in: 3...10) * 360
        
        withAnimation(.easeIn(duration: 0.5)) {
            rotationAngle += randomRotations * 0.3
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.linear(duration: duration - 1.5)) {
                rotationAngle += randomRotations * 0.5
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration - 1.0) {
            withAnimation(.easeOut(duration: 1.0)) {
                rotationAngle += randomRotations * 0.2
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
            .fill(chargeColor.opacity(0.3))
            .frame(width: chargeSize, height: chargeSize)
            .overlay(
                Circle()
                    .fill(chargeColor)
                    .frame(width: chargeSize * 0.8, height: chargeSize * 0.8)
            )
    }
    
    private var chargeSize: CGFloat {
        100 + progress * 150
    }
    
    private var chargeColor: Color {
        Color(red: 0.3, green: 0.5, blue: 1.0 - progress * 0.3)
    }
}

struct BottleView_Previews: PreviewProvider {
    static var previews: some View {
        BottleView()
    }
}
