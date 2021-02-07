//
//  ViewController.swift
//  DrawingApp
//
//  Created by Prasan Dhareshwar on 1/9/21.
//

import UIKit


class ViewController: UIViewController {
    
    let canvas = Canvas()
    
    let undoButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Undo", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleUndo), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleUndo() {
        canvas.undo()
    }
    
    let clearButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleClear), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleClear() {
        canvas.clear()
    }
    
    let yellowButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .yellow
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange), for: .touchUpInside)
        return button
    }()
    
    let redButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .red
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange), for: .touchUpInside)
        return button
    }()
    
    let blueButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleColorChange), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleColorChange(button: UIButton) {
        canvas.setStrokeColor(color: button.backgroundColor ?? .black)
    }
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 10
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    @objc fileprivate func handleSliderChange() {
        canvas.setStrokeWidth(value: slider.value)
    }
    
    override func loadView() {
        self.view = canvas
    }

    fileprivate func setupLayout() {
        //        canvas.frame = view.frame
        
        let colorsStackView = UIStackView(arrangedSubviews: [
            yellowButton,
            redButton,
            blueButton
        ])
        colorsStackView.distribution = .fillEqually
        
        let stackView = UIStackView(arrangedSubviews: [
            undoButton,
            clearButton,
            colorsStackView,
            slider,
        ])
        stackView.spacing = 24
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo:
                                            view.leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo:
                                            view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo:
                                                view.trailingAnchor, constant: -8).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.addSubview(canvas)
        canvas.backgroundColor = .white
        setupLayout()
    }


}

