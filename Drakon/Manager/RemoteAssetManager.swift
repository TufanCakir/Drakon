//
//  RemoteAssetManager.swift
//  Drakon
//
//  Created by Tufan Cakir on 23.05.26.
//

import Foundation

final class RemoteAssetManager {
    static let shared = RemoteAssetManager()

    private let folderName = "RemoteDrakonAssets"

    private init() {
        migrateLegacyCacheIfNeeded()
    }

    func preload(manifest: RemoteManifest, completion: @escaping () -> Void) {
        guard let baseURL = manifest.assetBaseURL.flatMap(URL.init(string:))
        else {
            completion()
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            for asset in manifest.assets {
                guard self.localURL(for: asset.id) == nil else { continue }
                let remoteURL = baseURL.appendingPathComponent(asset.file)
                guard let data = try? Data(contentsOf: remoteURL) else {
                    continue
                }
                self.save(
                    data,
                    id: asset.id,
                    fileExtension: remoteURL.pathExtension
                )
            }

            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func localURL(for id: String) -> URL? {
        let directory = remoteDirectory()
        let matches =
            (try? FileManager.default.contentsOfDirectory(
                at: directory,
                includingPropertiesForKeys: nil
            )) ?? []
        return matches.first {
            $0.deletingPathExtension().lastPathComponent == id
        }
    }

    func download(asset: RemoteAsset, baseURL: URL) -> Int {
        if let localURL = localURL(for: asset.id),
            let size = try? localURL.resourceValues(forKeys: [.fileSizeKey])
                .fileSize
        {
            return size
        }

        let remoteURL = baseURL.appendingPathComponent(asset.file)
        guard let data = try? Data(contentsOf: remoteURL) else { return 0 }
        save(data, id: asset.id, fileExtension: remoteURL.pathExtension)
        return data.count
    }

    func cachedAssetCount(in manifest: RemoteManifest) -> Int {
        manifest.assets.filter { localURL(for: $0.id) != nil }.count
    }

    private func save(_ data: Data, id: String, fileExtension: String) {
        let directory = remoteDirectory()
        try? FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: true
        )
        let url = directory.appendingPathComponent(id).appendingPathExtension(
            fileExtension.isEmpty ? "png" : fileExtension
        )
        try? data.write(to: url, options: .atomic)
    }

    private func remoteDirectory() -> URL {
        FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        )[0]
        .appendingPathComponent(folderName, isDirectory: true)
    }

    private func legacyCacheDirectory() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(folderName, isDirectory: true)
    }

    private func migrateLegacyCacheIfNeeded() {
        let fileManager = FileManager.default
        let legacyDirectory = legacyCacheDirectory()
        let destinationDirectory = remoteDirectory()

        guard fileManager.fileExists(atPath: legacyDirectory.path) else {
            return
        }

        try? fileManager.createDirectory(
            at: destinationDirectory,
            withIntermediateDirectories: true
        )

        let files =
            (try? fileManager.contentsOfDirectory(
                at: legacyDirectory,
                includingPropertiesForKeys: nil
            )) ?? []

        for file in files {
            let destination = destinationDirectory.appendingPathComponent(
                file.lastPathComponent
            )
            guard !fileManager.fileExists(atPath: destination.path) else {
                continue
            }
            try? fileManager.copyItem(at: file, to: destination)
        }
    }
}
