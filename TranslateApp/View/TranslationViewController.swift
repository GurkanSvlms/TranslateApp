//
//  TranslationViewController.swift
//  TranslateApp
//
//  Created by Ali Gürkan Sevilmis on 2.08.2023.
//

import UIKit

class TranslationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // Storyboard'dan bağlantıları
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var outputTextField: UITextField!
    @IBOutlet weak var languageButtonInput: UIButton!
    @IBOutlet weak var languageButtonOutput: UIButton!
    
    // ViewModeller
    private let languageViewModel = LanguageViewModel()
    private let translationViewModel = TranslationViewModel()
    private let detectionViewModel = DetectionViewModel()
    
    //UIPickerView
    private var pickerView: UIPickerView!
    private var selectedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIPickerView datasource ve delegate
        pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = .white
        
        //LanguageViewModel-fetchLanguages fonksiyonu çağrımı
        fetchLanguages()
    }
    
    // Dil modellerini çeker
    private func fetchLanguages() {
        languageViewModel.fetchLanguages { [weak self] error in
            if let error = error {
                print("Diller alınırken hata oluştu: \(error)")
            } else {
                DispatchQueue.main.async {
                    self?.updateLanguageButtons()
                }
            }
        }
    }
    
    //metin çevirisi işlemini başlatma
    @IBAction func translateButtonTapped(_ sender: UIButton) {
        guard let inputText = inputTextField.text,
              let sourceLanguage = languageButtonInput.titleLabel?.text,
              let targetLanguage = languageButtonOutput.titleLabel?.text else {
            return
        }
        
        // TranslationViewModel translate fonksiyonu
        translationViewModel.translate(inputText: inputText, sourceLanguage: sourceLanguage, targetLanguage: targetLanguage) { [weak self] result in
            switch result {
            case .success(let translatedText):
                DispatchQueue.main.async {
                    self?.outputTextField.text = translatedText
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("Translation Error: \(error)")
                }
            }
        }
    }
    
    // dil seçme butonlarının güncellenmesi
    private func updateLanguageButtons() {
        if let inputLanguageCode = languageButtonInput.titleLabel?.text {
            languageButtonInput.setTitle(inputLanguageCode, for: .normal)
        }
        
        if let outputLanguageCode = languageButtonOutput.titleLabel?.text {
            languageButtonOutput.setTitle(outputLanguageCode, for: .normal)
        }
    }
    
    @IBAction func languageButtonInputTapped(_ sender: UIButton) {
        detectionViewModel.detectLanguage(for: inputTextField.text!) { [weak self] detectedLanguage, error in
            DispatchQueue.main.async {
                if error != nil {
                    self?.detectionViewModel.showAlert(with: "Hata", message: "Dil algılanamadı.")
                    self?.showLanguageSelectionPicker(for: sender, using: (self?.pickerView)!)
                } else {
                    self?.languageButtonInput.setTitle(detectedLanguage, for: .normal)
                }
            }
        }
    }
    
    @IBAction func languageButtonOutputTapped(_ sender: UIButton) {
        showLanguageSelectionPicker(for: sender, using: pickerView)
    }
    
    // Dil seçim picker'ını göstereir
    private func showLanguageSelectionPicker(for button: UIButton, using pickerView: UIPickerView) {
        selectedButton = button
        
        pickerView.reloadAllComponents()
        pickerView.selectRow(selectedLanguageIndex(for: button), inComponent: 0, animated: false)
        
        let alertController = UIAlertController(title: "Dil Seçin", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alertController.view.addSubview(pickerView)
        
        let selectAction = UIAlertAction(title: "Seç", style: .default) { [weak self] _ in
            self?.updateSelectedLanguage()
        }
        alertController.addAction(selectAction)
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel) { [weak self] _ in
            self?.pickerView.removeFromSuperview()
        }
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
            popoverController.permittedArrowDirections = []
        }
        
        alertController.preferredAction = selectAction
        
        present(alertController, animated: true, completion: nil)
    }
    
    // seçilen dilin indeksi
    private func selectedLanguageIndex(for button: UIButton) -> Int {
        guard let selectedLanguageCode = button.titleLabel?.text else {
            return 0
        }
        return languageViewModel.languages.firstIndex { $0.languageCode == selectedLanguageCode } ?? 0
    }
    
    // seçilen dili güncelleyer
    private func updateSelectedLanguage() {
        if let selectedButton = selectedButton {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            let selectedLanguage = languageViewModel.languages[selectedRow].languageCode
            selectedButton.setTitle(selectedLanguage, for: .normal)
            pickerView.removeFromSuperview()
        }
    }
    
    // UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageViewModel.numberOfLanguages
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languageViewModel.languages[row].languageCode
    }
}
