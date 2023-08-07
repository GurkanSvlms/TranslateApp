//
//  LanguageService.swift
//  TranslateApp
//
//  Created by Ali Gürkan Sevilmis on 2.08.2023.
//

import Foundation

class LanguageService {
    
    // Dil kodlarını asenkron bir biçimde servisten çeker
    
    func fetchLanguages(completion: @escaping ([LanguageModel]?, Error?) -> Void) {
        
        // Headers
        let headers = [
            "Accept-Encoding": "application/gzip",
            "X-RapidAPI-Key": "c19b4f08admsha03a85c0fb26852p106ce4jsn056564b9c899",
            "X-RapidAPI-Host": "google-translate1.p.rapidapi.com"
        ]
        
        // Url
        let request = NSMutableURLRequest(url: NSURL(string: "https://google-translate1.p.rapidapi.com/language/translate/v2/languages")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        // Api isteği
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if let error = error {
                // Hata durumu
                completion(nil, error)
                return
            }
            
            // Gelen yanıt kontrolü
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Yanıt Kodu: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        do {
                            // JSON verilerini çözümleme
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            if let languageData = json?["data"] as? [String: Any], let languagesArray = languageData["languages"] as? [[String: String]] {
                                // Çekilen dilleri LanguageModel dizisine dönrürür
                                let languages = languagesArray.map { dict -> LanguageModel in
                                    return LanguageModel(languageCode: dict["language"] ?? "")
                                }
                                completion(languages, nil)
                            } else {
                                // Veri çekme hatası
                                let error = NSError(domain: "com.guko.TranslateApp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Diller alınamadı."])
                                completion(nil, error)
                            }
                        } catch {
                            // JSON verilerini çözümleme hatası
                            completion(nil, error)
                        }
                    } else {
                        // Veri olmama hatası
                        let error = NSError(domain: "com.guko.TranslateApp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Diller alınamadı."])
                        completion(nil, error)
                    }
                } else {
                    // Başarısız kod
                    let error = NSError(domain: "com.guko.TranslateApp", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Diller alınamadı."])
                    completion(nil, error)
                }
            } else {
                // Yanıt alınamadığı hata
                let error = NSError(domain: "com.guko.TranslateApp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Diller alınamadı."])
                completion(nil, error)
            }
        }
        
        // URLSession verileri çekmek işlemi
        dataTask.resume()
    }
}
