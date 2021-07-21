//
//  ContentView.swift
//  AsyncAwait
//
//  Created by jeevan tiwari on 6/12/21.
//

import SwiftUI

struct ContentView: View {
    @State var rotationEffect: Double = 45
    @State var scale: CGFloat = 1
    var body: some View {
        VStack{
            Spacer()
            ZStack{
                ForEach(0..<8){ item in
                    RoundedRectangle(cornerRadius: 70)
                        .frame(width: 70, height: 140)
                        .foregroundColor(.orange)
                        .opacity(0.8)
                        .hueRotation(.degrees(Double(item) * 45))
                        .blendMode(.multiply)
                        .offset(y: -2)
                        .scaleEffect(scale)
                        .rotationEffect(.degrees(45 * Double(item)), anchor: .bottom)
                        
                }
            }
            .offset(y: -50)
            Spacer()
        }
        .onAppear {
            let baseAnimation = Animation.spring(response: 1, dampingFraction: 1, blendDuration: 1)
            let repeated = baseAnimation.repeatForever(autoreverses: true)
            withAnimation(repeated) {
                scale = 0
                    rotationEffect = 0
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()//.environment(\.colorScheme, .dark)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
