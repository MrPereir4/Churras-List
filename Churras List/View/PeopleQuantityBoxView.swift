//
//  PeopleQuantityBoxView.swift
//  Churras List
//
//  Created by Vinnicius Pereira on 11/01/21.
//

import UIKit

class PeopleQuantityBoxView: UIView{
    //MARK: - Properties
    var title = String()
    var isTimePicker = Bool()
    var image = UIImage()
    
    let boxQuantity = UILabel()
    
    let stepper = UIStepper()
    
    let slider = UISlider()
    
    var numValue: Double = 0
    
    //MARK: - Lifecycle
    required init(title: String, image: UIImage, isTimePicker: Bool? = false) {
        self.title = title
        self.isTimePicker = isTimePicker!
        self.image = image
        super.init(frame: CGRect.zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    
    @objc private func handleStepper(_ stepper: UIStepper){
        numValue = stepper.value
        stepper.value = numValue
        slider.value = Float(numValue)
        boxQuantity.text = isTimePicker == false ? String(Int(stepper.value)) : "\(Int(stepper.value)):00"
    }
    
    @objc private func sliderValueChanged(sender: UISlider!){
        numValue = Double(sender.value)
        stepper.value = Double(sender.value)
        boxQuantity.text = isTimePicker == false ? String(Int(sender.value)) : "\(Int(sender.value)):00"
    }
    
    
    
    
    //MARK: - Helper functions
    private func configure(){
        
        if isTimePicker == true{
            numValue = 1.0
        }
        
        let topContentHolder = UIView()
        addSubview(topContentHolder)
        let imageIcon = UIView().viewWithShadow(image: image, viewColor: .black)
        topContentHolder.addSubview(imageIcon)
        topContentHolder.anchor(top: self.topAnchor, right: self.rightAnchor, left: self.leftAnchor, height: 90)
        imageIcon.layer.cornerRadius = 45
        imageIcon.anchor(top: topContentHolder.topAnchor, left: topContentHolder.leftAnchor, width: 90, height: 90)
        imageIcon.backgroundColor = .grayWhiteContrast
        
        
        let stackContent = UIStackView()
        stackContent.axis = .vertical
        stackContent.spacing = 8
        topContentHolder.addSubview(stackContent)
        stackContent.anchor(top: topContentHolder.topAnchor, left: imageIcon.rightAnchor, paddingLeft: 10)
        
        let boxTitle = UILabel()
        boxTitle.text = title
        boxTitle.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        stackContent.addArrangedSubview(boxTitle)
        
        
        boxQuantity.text = isTimePicker == false ? "0" : "1:00"
        boxQuantity.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        stackContent.addArrangedSubview(boxQuantity)
        
        if isTimePicker == false{
            stepper.minimumValue = 0.0
            stepper.maximumValue = 400.0
            stepper.value = 0.0
        }else{
            stepper.minimumValue = 1.0
            stepper.maximumValue = 24.0
            stepper.value = 1.0
        }
        stepper.autorepeat = true
        stepper.stepValue = 1.0
        stepper.addTarget(self, action: #selector(handleStepper(_:)), for: .valueChanged)
        
        topContentHolder.addSubview(stepper)
        stepper.anchor(right: topContentHolder.rightAnchor)
        stepper.centerY(inView: topContentHolder)
        
        
        self.addSubview(slider)
        slider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        
        if isTimePicker == false{
            slider.minimumValue = 0
            slider.maximumValue = 400
        }else{
            slider.minimumValue = 1
            slider.maximumValue = 24
        }
        
        slider.isContinuous = true
        slider.anchor(top: topContentHolder.bottomAnchor, right: self.rightAnchor, left: self.leftAnchor, paddingTop: 16)
    }
}
