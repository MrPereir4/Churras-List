//
//  Extensions.swift
//  Churras List
//
//  Created by Vinnicius Pereira on 09/01/21.
//

import UIKit

extension UIColor{
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor{
        return UIColor.init(displayP3Red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let placeholderGray = rgb(196, 196, 198)
    static let overContentGray = rgb(149, 149, 153)
    static let darkerBackground = rgb(239, 239, 244)
    static let grayBack = rgb(242, 242, 247)
    static let ultraLightGray = rgb(244, 244, 244)
    static let grayWhiteContrast = rgb(242, 242, 247)
    static let pinkRed = rgb(255, 45, 85)
    
    
    static let customSystemBlue = rgb(0, 122, 255)
    static let customSystemGreen = rgb(52, 199, 89)
    static let customSystemRed = rgb(255, 59, 48)
    static let customSystemYellow = rgb(255, 204, 0)
    
    static let animationLightColor = rgb(229, 229, 229)
    
    static let mainBackgroundColor = rgb(255, 255, 255)
}

extension UIView{
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingRight: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil
                ){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let right = right{
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let left = left{
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let width = width{
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height{
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func setDimensions(width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalToConstant: height).isActive = true
        
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func centerX(inView view: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(inView view: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func allSideConstraint(inView view: UIView, paddingY: CGFloat = 0, paddingX: CGFloat = 0){
        translatesAutoresizingMaskIntoConstraints = false
        
        
        
        anchor(top: view.topAnchor,
               right: view.rightAnchor,
               bottom: view.bottomAnchor,
               left: view.leftAnchor,
               paddingTop: paddingY,
               paddingRight: paddingX,
               paddingBottom: paddingY,
               paddingLeft: paddingX)
        
    }
    
    func viewWithShadow(image: UIImage? = nil, viewColor: UIColor) -> UIView{
        let view = UIView()
        
        ///- Adding shadow
        view.layer.cornerRadius = 12
        view.layer.shadowColor = viewColor.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        view.layer.shadowOpacity = 0.25
        view.layer.shadowRadius = 4
        
        if image != nil{
            let imageView = UIImageView(image: image)
            view.addSubview(imageView)
            
            imageView.setDimensions(width: 50, height: 50)
            imageView.centerX(inView: view)
            imageView.centerY(inView: view)
        }
        
        
        return view
    }
}


//MARK: - UIButton

extension UIButton{
    
    func buttonWithShadow(buttonTitle: String, buttonColor: UIColor) -> UIButton{
        let button = UIButton(type: .system)
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = buttonColor
        
        ///- Adding shadow
        button.layer.cornerRadius = 12
        button.layer.shadowColor = buttonColor.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 4
        
        return button
    }
    
}
