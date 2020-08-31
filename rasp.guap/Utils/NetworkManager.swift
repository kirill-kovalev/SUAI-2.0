//
//  NetworkManager.swift
//  rasp.guap
//
//  Created by Кирилл on 01.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation



class NetworkManager{
    class CData {
        let data:Data
        init(_ data:Data) {self.data = data}
    }
    
    private static let cache:NSCache = NSCache<NSString,CData>()
    
    
    public static func dataTask(url:String,completion: @escaping ((Result<Data,Error>)->Void)){
        guard let url = URL(string: url) else {return}
        
        if let cacheData = cache.object(forKey: url.absoluteString as NSString){
            completion(.success(cacheData.data))
        }else{
            
            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 15)
            URLSession.shared.dataTask(with: request) { (data, response, err) in
                if data != nil, (response as? HTTPURLResponse)?.statusCode == 200 {
                    cache.setObject(CData(data!), forKey: url.absoluteString as NSString)
                    DispatchQueue.main.async{ completion(.success(data!)) }
                }else{
                    if err != nil {
                        DispatchQueue.main.async{ completion(.failure(err!)) }
                    }
                    
                }
            }
        }
        
       
        
    }
}
