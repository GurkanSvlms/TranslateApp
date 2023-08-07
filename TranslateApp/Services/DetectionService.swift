//
//  DetectionService.swift
//  TranslateApp
//
//  Created by Ali Gürkan Sevilmis on 7.08.2023.
//

import Foundation

class DetectionService {
    
    // Headers
    private let headers = [
        "content-type": "application/x-www-form-urlencoded",
        "Accept-Encoding": "application/gzip",
        "X-RapidAPI-Key": "c19b4f08admsha03a85c0fb26852p106ce4jsn056564b9c899",
        "X-RapidAPI-Host": "google-translate1.p.rapidapi.com"
    ]
    
    // verilen stringdeki dili algılar.
    func detectLanguage(for text: String, completion: @escaping (DetectionResult?, Error?) -> Void) {
        
        // API isteği
        let postData = "q=\(text)".data(using: .utf8)!
        var request = URLRequest(url: URL(string: "https://google-translate1.p.rapidapi.com/language/translate/v2/detect")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        // URLSession
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, error)
            } else if let data = data {
                // JSON çözümleme
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(DetectionResponse.self, from: data)
                    if let detectionResult = response.data.detections.first?.first {
                        completion(detectionResult, nil)
                    } else {
                        //hata durumu
                        let noDetectionError = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Dil algılanamadı"])
                        completion(nil, noDetectionError)
                    }
                } catch {
                    // JSON  çözümleme hatası
                    completion(nil, error)
                }
            }
        }
        dataTask.resume()
    }
}
