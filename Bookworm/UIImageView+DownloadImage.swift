//
//  UIImageView+DownloadImage.swift
//  Bookworm
//
//  Created by Celeste Urena on 11/19/22.
//

import UIKit

extension UIImageView {
    func loadImage(url: URL) -> URLSessionDownloadTask {
        
        let session = URLSession.shared
        // Creates download task after obtaining reference
        let downloadTask = session.downloadTask(with: url) {
            [weak self] url, _, error in
            // URL to find the downloaded file
            if error == nil, let url = url,
               let data = try? Data(contentsOf: url),
               // With the local URL, load file into a data object and then create an image from that
               let image = UIImage(data: data) {
                // Puts image in UIImageView image property once it's retrieved
                DispatchQueue.main.async {
                    if let weakSelf = self {
                        weakSelf.image = image
                    }
                }
            }
        }
        // Call download task to start it
        downloadTask.resume()
        return downloadTask
    }
}
