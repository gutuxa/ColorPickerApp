//
//  EntryViewController.swift
//  ColorPickerApp
//
//  Created by Oksana Tugusheva on 09.04.2021.
//

import UIKit

protocol ColorDelegate {
    func setColor(with color: UIColor)
}

class EntryViewController: UIViewController {
    
    private var color = UIColor(red: 1, green: 1, blue: 1, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewColor(with: color)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else { return }
        settingsVC.color = color
        settingsVC.delegate = self
    }
}

// MARK: - Private Methods
extension EntryViewController {
    private func setupViewColor(with color: UIColor) {
        view.backgroundColor = color
    }
}

// MARK: - ColorDelegate Methods
extension EntryViewController: ColorDelegate {
    func setColor(with color: UIColor) {
        self.color = color
        setupViewColor(with: color)
    }
}
