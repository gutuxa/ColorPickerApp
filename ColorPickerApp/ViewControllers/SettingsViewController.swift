//
//  SettingsViewController.swift
//  ColorPickerApp
//
//  Created by Oksana Tugusheva on 26.03.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redTF: UITextField!
    @IBOutlet var greenTF: UITextField!
    @IBOutlet var blueTF: UITextField!
    
    @IBOutlet var colorView: UIView! {
        didSet {
            colorView.layer.cornerRadius = 10
            colorView.layer.shadowColor = UIColor.black.cgColor
            colorView.layer.shadowOpacity = 0.13
            colorView.layer.shadowOffset = .zero
            colorView.layer.shadowRadius = 8
        }
    }
    
    @IBOutlet var doneButton: UIButton! {
        didSet {
            doneButton.layer.cornerRadius = 8
        }
    }
    
    var color: UIColor!
    var delegate: ColorDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redTF.delegate = self
        greenTF.delegate = self
        blueTF.delegate = self
        
        setSliders()
        setValue(for: redLabel, greenLabel, blueLabel)
        setValue(for: redTF, greenTF, blueTF)
        applyColor()
    }

    @IBAction func sliderChanged(_ sender: UISlider) {
        switch sender {
        case redSlider:
            setValue(for: redLabel)
            setValue(for: redTF)
        case greenSlider:
            setValue(for: greenLabel)
            setValue(for: greenTF)
        default:
            setValue(for: blueLabel)
            setValue(for: blueTF)
        }
        
        setColor()
        applyColor()
    }
    
    @IBAction func doneButtonPressed() {
        view.endEditing(true)
        delegate.setColor(with: color)
        dismiss(animated: true)
    }
}

// MARK: - Private Methods
extension SettingsViewController {
    private func setColor() {
        color = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
    
    private func applyColor() {
        colorView.backgroundColor = color
    }
    
    private func setSliders() {
        let ciColor = CIColor(color: color)
        
        redSlider.value = Float(ciColor.red)
        greenSlider.value = Float(ciColor.green)
        blueSlider.value = Float(ciColor.blue)
    }
    
    private func setValue(for labels: UILabel...) {
        for label in labels {
            switch label {
            case redLabel: label.text = string(from: redSlider)
            case greenLabel: label.text = string(from: greenSlider)
            default: label.text = string(from: blueSlider)
            }
        }
    }
    
    private func setValue(for textFields: UITextField...) {
        for textField in textFields {
            switch textField {
            case redTF: textField.text = string(from: redSlider)
            case greenTF: textField.text = string(from: greenSlider)
            default: textField.text = string(from: blueSlider)
            }
        }
    }
    
    private func string(from slider: UISlider) -> String {
        String(format: "%.2f", slider.value)
    }
    
    private func showErrorAlert(for textField: UITextField) {
        let alert = UIAlertController(
            title: "Invalid value",
            message: "Please enter number beetwen 0 and 1",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "Ok",
            style: .default,
            handler: { _ in textField.becomeFirstResponder() }
        )
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - TextField Methods
extension SettingsViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let value = Float(textField.text ?? ""), value >= 0 && value <= 1 else {
            showErrorAlert(for: textField)
            
            switch textField {
            case redTF: setValue(for: redTF)
            case greenTF: setValue(for: greenTF)
            default: setValue(for: blueTF)
            }
            
            return
        }
        
        switch textField {
        case redTF:
            redSlider.setValue(value, animated: true)
            setValue(for: redLabel)
        case greenTF:
            greenSlider.setValue(value, animated: true)
            setValue(for: greenLabel)
        default:
            blueSlider.setValue(value, animated: true)
            setValue(for: blueLabel)
        }
        
        setColor()
        applyColor()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let toolbar = UIToolbar()
        
        toolbar.sizeToFit()
        textField.inputAccessoryView = toolbar
        
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(keyboardDoneButtonPressed)
        )
        
        toolbar.items = [flexibleSpace, doneButton]
    }
    
    @objc private func keyboardDoneButtonPressed() {
        view.endEditing(true)
    }
}

