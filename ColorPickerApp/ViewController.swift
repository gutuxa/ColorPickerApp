//
//  ViewController.swift
//  ColorPickerApp
//
//  Created by Oksana Tugusheva on 26.03.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var colorView: UIView!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Color View
        colorView.layer.cornerRadius = 10
        colorView.layer.shadowColor = UIColor.black.cgColor
        colorView.layer.shadowOpacity = 0.13
        colorView.layer.shadowOffset = .zero
        colorView.layer.shadowRadius = 8
        
        // Label Values
        redLabel.text = String(format: "%.2f", redSlider.value)
        greenLabel.text = String(format: "%.2f", greenSlider.value)
        blueLabel.text = String(format: "%.2f", blueSlider.value)
        
        mixColor()
    }

    @IBAction func redSliderChanged() {
        redLabel.text = String(format: "%.2f", redSlider.value)
        mixColor()
    }
    
    @IBAction func greenSliderChanged() {
        greenLabel.text = String(format: "%.2f", greenSlider.value)
        mixColor()
    }
    
    @IBAction func blueSliderChanged() {
        blueLabel.text = String(format: "%.2f", blueSlider.value)
        mixColor()
    }
    
    
    private func mixColor() {
        colorView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value),
            green: CGFloat(greenSlider.value),
            blue: CGFloat(blueSlider.value),
            alpha: 1
        )
    }
}

