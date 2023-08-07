//
//  DetectionViewModel.swift
//  TranslateApp
//
//  Created by Ali Gürkan Sevilmis on 7.08.2023.
//

import Foundation
import UIKit

class DetectionViewModel {
    private let detectionService = DetectionService()
    
    //detect işlemi içni servis sınıfını kullanma
    func detectLanguage(for text: String, completion: @escaping (String?, Error?) -> Void) {
        detectionService.detectLanguage(for: text) { result, error in
            if let error = error {
                //hata
                completion(nil, error)
            } else {
                //başarılı
                let detectedLanguage = result?.language ?? ""
                completion(detectedLanguage, nil)
            }
        }
    }
    //dil algılanamazsa kullanıcıya hata gösterimi
    func showAlert(with title: String, message: String, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let viewController = scene.windows.first?.rootViewController {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Tamam", style: .default) { _ in
                    completion?()
                }
                alertController.addAction(okAction)
                viewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

