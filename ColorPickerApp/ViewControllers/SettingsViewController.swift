//
//  SettingsViewController.swift
//  ColorPickerApp
//
//  Created by Oksana Tugusheva on 26.03.2021.
//

import UIKit

enum Color {
    case red, green, blue
}

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
        setupUI()
        setupTextFields()
    }

    @IBAction func sliderChanged(_ sender: UISlider) {
        switch sender {
        case redSlider:
            setColor(red: sender.value)
            setValues(for: .red)
        case greenSlider:
            setColor(green: sender.value)
            setValues(for: .green)
        default:
            setColor(blue: sender.value)
            setValues(for: .blue)
        }
        
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
    private func setupUI() {
        setValues(for: .red, .green, .blue)
        applyColor()
    }
    
    private func getRGB() -> (red: Float, green: Float, blue: Float) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red: Float(red), green: Float(green), blue: Float(blue))
    }
    
    private func setColor(red: Float? = nil, green: Float? = nil, blue: Float? = nil) {
        color = UIColor(
            red: CGFloat(red ?? redSlider.value),
            green: CGFloat(green ?? greenSlider.value),
            blue: CGFloat(blue ?? blueSlider.value),
            alpha: 1
        )
    }
    
    private func applyColor() {
        colorView.backgroundColor = color
    }
    
    private func setValues(for colors: Color...) {
        let (red, green, blue) = getRGB()
        
        for color in colors {
            switch color {
            case .red:
                redSlider.setValue(red, animated: false)
                redLabel.text = string(for: red)
                redTF.text = string(for: red)
            case .green:
                greenSlider.setValue(green, animated: false)
                greenLabel.text = string(for: green)
                greenTF.text = string(for: green)
            case .blue:
                blueSlider.setValue(blue, animated: false)
                blueLabel.text = string(for: blue)
                blueTF.text = string(for: blue)
            }
        }
    }
    
    private func string(for number: Float) -> String {
        String(format: "%.2f", number)
    }
}

// MARK: - TextField Methods
extension SettingsViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super .touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let value = Float(textField.text ?? ""), value >= 0 && value <= 1 else {
            switch textField {
            case redTF: setValues(for: .red)
            case greenTF: setValues(for: .green)
            default: setValues(for: .blue)
            }
            return
        }
        
        switch textField {
        case redTF:
            setColor(red: value)
            setValues(for: .red)
        case greenTF:
            setColor(green: value)
            setValues(for: .green)
        default:
            setColor(blue: value)
            setValues(for: .blue)
        }
        
        applyColor()
    }
    
    private func setupTextFields() {
        for textField in [redTF, greenTF, blueTF] {
            guard let textField = textField else { return }
            
            textField.delegate = self
            setupDecimalKeyboard(for: textField)
        }
    }
    
    private func setupDecimalKeyboard(for textField: UITextField) {
        textField.keyboardType = .decimalPad
        
        let toolbar = UIToolbar(
            frame: CGRect.init(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 44
            )
        )
        
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: nil,
            action: #selector(keyboardDoneButtonPressed)
        )
        
        toolbar.items = [flexibleSpace, doneButton]
        textField.inputAccessoryView = toolbar
    }
    
    @objc private func keyboardDoneButtonPressed() {
        view.endEditing(true)
    }
}

