//
//  RemoteManifest.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Foundation

struct RemoteManifest: Codable {
    let jsonFiles: [String]
    let assetBaseURL: String?
    let assets: [RemoteAsset]
}

struct RemoteAsset: Codable, Identifiable {
    let id: String
    let file: String
}
