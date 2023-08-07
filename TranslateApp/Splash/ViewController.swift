//
//  ViewController.swift
//  TranslateApp
//
//  Created by Ali Gürkan Sevilmis on 1.08.2023.
//

import UIKit
import Network

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkInternetConnection()
    }
    
    func checkInternetConnection() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                // İnternet bağlantısı varsa ana ekrana geç
                DispatchQueue.main.async {
                    self.navigateToMainScreen()
                }
            } else {
                // İnternet bağlantısı yoksa hata mesajı göster ve yeniden dene
                DispatchQueue.main.async {
                    self.showNetworkError()
                }
            }
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    func navigateToMainScreen() {
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(showLoginScreen), userInfo: nil, repeats: false)
    }
    
    func showNetworkError() {
        let alertController = UIAlertController(title: "Hata", message: "İnternet bağlantısı yok. Lütfen internet bağlantınızı kontrol edin ve tekrar deneyin.", preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Tekrar Dene", style: .default) { _ in
            self.checkInternetConnection()
        }
        alertController.addAction(retryAction)
        present(alertController, animated: true, completion: nil)
    }
    @objc func showLoginScreen() {
        //            Splash Screen Segue
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.performSegue(withIdentifier: "goToMainVC", sender: nil)
        }
        
    }
}


