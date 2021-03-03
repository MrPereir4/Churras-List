//
//  StandardItemPickCell.swift
//  Churras List
//
//  Created by Vinnicius Pereira on 14/01/21.
//

import UIKit

class StandardItemPickCell: UICollectionViewCell{
    //MARK: - Properties
    
    var boxName = String()
    var iconImage = UIImage()
    
    let iconView = UIView().viewWithShadow(viewColor: .black)
    var whiteSelect = UIView()
    let iconImageView = UIImageView()
    
    let boxTitle = UILabel()

    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.allSideConstraint(inView: self)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Helper functions
    func configure(){
        
        whiteSelect.backgroundColor = .white
        whiteSelect.layer.cornerRadius = 35
        whiteSelect.alpha = 0.9
        
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 5
        contentView.addSubview(mainStack)
        mainStack.anchor(top: self.topAnchor, right: self.rightAnchor, left: self.leftAnchor)
        
        let imageHolder = UIView()
        imageHolder.setDimensions(width: 80, height: 70)
        mainStack.addArrangedSubview(imageHolder)
        
       
        imageHolder.addSubview(iconView)
        iconView.centerX(inView: imageHolder)
        iconView.setDimensions(width: 70, height: 70)
        iconView.backgroundColor = .grayWhiteContrast
        iconView.layer.cornerRadius = 35
        
        iconView.addSubview(iconImageView)
        iconImageView.setDimensions(width: 35, height: 35)
        iconImageView.centerX(inView: iconView)
        iconImageView.centerY(inView: iconView)
        
        
        
        mainStack.addArrangedSubview(boxTitle)
        boxTitle.text = boxName
        boxTitle.textAlignment = .center
        boxTitle.numberOfLines = 2
        boxTitle.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }

    func selectBox(){
        iconView.addSubview(whiteSelect)
        let checkIcon = UIImageView(image: #imageLiteral(resourceName: "check"))
        whiteSelect.addSubview(checkIcon)
        checkIcon.setDimensions(width: 40, height: 40)
        checkIcon.centerY(inView: whiteSelect)
        checkIcon.centerX(inView: whiteSelect)
        whiteSelect.allSideConstraint(inView: iconView)
        
    }
    
    func deselectBox(){
        whiteSelect.removeFromSuperview()
    }
    
    func insertValue(){
        iconImageView.image = iconImage
        boxTitle.text = boxName
        
    }
}
