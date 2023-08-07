//
//  TranslationService.swift
//  TranslateApp
//
//  Created by Ali Gürkan Sevilmis on 5.08.2023.
//

import Foundation

class TranslationService {
    
    // Dilleri çevirme fonksitonu
    func translateText(inputText: String, sourceLanguage: String, targetLanguage: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        // Headers
        let headers = [
            "content-type": "application/x-www-form-urlencoded",
            "Accept-Encoding": "application/gzip",
            "X-RapidAPI-Key": "c19b4f08admsha03a85c0fb26852p106ce4jsn056564b9c899",
            "X-RapidAPI-Host": "google-translate1.p.rapidapi.com"
        ]
        
        // POST
        let postData = "q=\(inputText)&source=\(sourceLanguage)&target=\(targetLanguage)"
        
        // Url
        let request = NSMutableURLRequest(url: NSURL(string: "https://google-translate1.p.rapidapi.com/language/translate/v2")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData.data(using: String.Encoding.utf8)
        
        // Api isteği
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let error = error {
                // Hata durumu
                completion(.failure(error))
            } else {
                // JSON çözümlemesi
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let translationResponse = try decoder.decode(TranslationResponse.self, from: data)
                        if let translatedText = translationResponse.data.translations.first?.translatedText {
                            completion(.success(translatedText))
                        } else {
                            // Çeviri hatası
                            completion(.failure(NSError(domain: "Translation Error", code: 0, userInfo: nil)))
                        }
                    } catch {
                        // JSON verilerini çözümleme hatası
                        completion(.failure(error))
                    }
                } else {
                    // Veri yoksa hata
                    completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                }
            }
        }
        
        // URLSession verileri çekmek
        dataTask.resume()
    }
}
