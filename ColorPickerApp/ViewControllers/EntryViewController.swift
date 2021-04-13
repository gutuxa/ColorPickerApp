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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let settingsVC = segue.destination as? SettingsViewController else { return }
        settingsVC.color = view.backgroundColor
        settingsVC.delegate = self
    }
}

// MARK: - Color Delegate Methods
extension EntryViewController: ColorDelegate {
    func setColor(with color: UIColor) {
        view.backgroundColor = color
    }
}
