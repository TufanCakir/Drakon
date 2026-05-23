//
//  RemoteAssetImage.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import SwiftUI
import UIKit

struct RemoteAssetImage: View {
    let name: String

    var body: some View {
        if let url = RemoteAssetManager.shared.localURL(for: name),
            let image = UIImage(contentsOfFile: url.path)
        {
            Image(uiImage: image)
                .resizable()
        } else {
            DrakonBladePalette.panel
                .overlay {
                    Text("DRK")
                        .font(
                            .system(size: 14, weight: .black, design: .rounded)
                        )
                        .foregroundStyle(.white)
                }
        }
    }
}
