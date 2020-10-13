//
//  NetworkManager.swift
//  rasp.guap
//
//  Created by Кирилл on 01.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

class NetworkManager {
    class CData {
        let data: Data
        init(_ data: Data) {self.data = data}
    }
    
    private static let cache: NSCache = NSCache<NSString, CData>()
    
    public static func dataTask(url: String, completion: @escaping ((Result<Data, Error>) -> Void)) {
        guard let url = URL(string: url) else {return}
        
        if let cacheData = cache.object(forKey: url.absoluteString as NSString) {
            completion(.success(cacheData.data))
        } else {
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 15)
            URLSession.shared.dataTask(with: request) { (data, response, err) in
                if data != nil, (response as? HTTPURLResponse)?.statusCode == 200 {
                    cache.setObject(CData(data!), forKey: url.absoluteString as NSString)
                    DispatchQueue.main.async { completion(.success(data!)) }
                } else {
                    if err != nil {
                        DispatchQueue.main.async { completion(.failure(err!)) }
                    }
                    
                }
            }.resume()
        }
        
    }
	
	private static func parseFilename(header content: String) -> String? {
		if let regexp = try? NSRegularExpression(pattern: "(.*?)filename=\"(.*)\"", options: []) {
			return regexp.stringByReplacingMatches(in: content, options: .withTransparentBounds, range: NSRange(location: 0, length: content.count), withTemplate: "$2")
		}
		return nil
	}
// swiftlint:disable opening_brace
// Потому что иначе уродливо
	public static func downloadFile(url: String, as fileName: String? = nil, delegate: URLSessionDelegate? = nil, completion: @escaping ((Result<URL, Error>) -> Void)) {
		guard let downloadURL = URL(string: url),
			let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
		else {return}
		
		if let cacheData = cache.object(forKey: downloadURL.absoluteString as NSString) {
			let fileURLString = String(data: cacheData.data, encoding: .utf8)
			let fileURL = URL(string: fileURLString!)
			FileManager.default.fileExists(atPath: fileURLString!)
			print("from cache")
			completion(.success(fileURL!))
		} else {
			let downloadSession = URLSession(configuration: .default, delegate: delegate, delegateQueue: OperationQueue.main)
			downloadSession.downloadTask(with: downloadURL) { (fileUrl, response, err) in
				print("start downloading")
				if let fileUrl = fileUrl,
					let response = response as? HTTPURLResponse,
					let contentHeader = response.allHeaderFields["Content-Disposition"] as? String,
					let headerFilename = parseFilename(header: contentHeader)
				{
					let destinationURL = documentsFolder.appendingPathComponent(fileName ?? headerFilename)
					print(destinationURL.absoluteString)
					
					try? FileManager.default.removeItem(at: destinationURL)
					do {
						try FileManager.default.copyItem(at: fileUrl, to: destinationURL)
						if let encodedFilePath = destinationURL.absoluteString.data(using: .utf8) {
							cache.setObject(CData(encodedFilePath), forKey: downloadURL.absoluteString as NSString)
						}
						completion(.success(destinationURL))
					} catch {
						completion(.failure(error))
					}
				}
				if let err = err {
					completion(.failure(err))
				}
			}.resume()
			
		}
	}
	
}
