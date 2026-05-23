//
//  DrakonBladeStyle.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import SwiftUI

enum DrakonBladePalette {
    static let black = Color(red: 0.018, green: 0.018, blue: 0.022)
    static let panel = Color(red: 0.055, green: 0.058, blue: 0.068)
    static let panelLight = Color(red: 0.085, green: 0.088, blue: 0.102)
    static let gold = Color(red: 0.95, green: 0.72, blue: 0.18)
    static let blue = Color(red: 0.08, green: 0.24, blue: 0.62)
    static let mutedText = Color.white.opacity(0.62)
}

struct DrakonBladeShape: Shape {
    let pointDepth: CGFloat
    let slant: CGFloat

    func path(in rect: CGRect) -> Path {
        let pointDepth = min(pointDepth, rect.width * 0.24)
        let slant = min(slant, rect.height * 0.40)

        var path = Path()
        path.move(to: CGPoint(x: rect.minX + slant, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - pointDepth, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX - pointDepth, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + slant, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

struct DrakonCutRectangle: Shape {
    let cut: CGFloat

    func path(in rect: CGRect) -> Path {
        let cut = min(cut, min(rect.width, rect.height) / 2)

        var path = Path()
        path.move(to: CGPoint(x: rect.minX + cut, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cut))
        path.addLine(to: CGPoint(x: rect.maxX - cut, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cut))
        path.closeSubpath()
        return path
    }
}

struct DrakonScreenBackground: View {
    var body: some View {
        DrakonBladePalette.black
            .overlay(alignment: .topTrailing) {
                RemoteAssetImage(name: "drakon_icon")
                    .scaledToFit()
                    .frame(width: 240, height: 240)
                    .opacity(0.045)
                    .offset(x: 62, y: -44)
            }
            .overlay(alignment: .bottomLeading) {
                RemoteAssetImage(name: "drakon_icon")
                    .scaledToFit()
                    .frame(width: 260, height: 260)
                    .opacity(0.035)
                    .offset(x: -92, y: 76)
            }
            .ignoresSafeArea()
    }
}
