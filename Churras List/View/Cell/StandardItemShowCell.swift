//
//  StandardItemShowCell.swift
//  Churras List
//
//  Created by Vinnicius Pereira on 14/01/21.
//

import UIKit

class StandardItemShowCell: UITableViewCell{
    //MARK: - Properties
    
    let holder = UIView()
    let contentHolder = UIView()
    let mainInfosHolder = UIView()
    
    var title = String()
    var shouldShowPrice: Bool = true
    var priceTag = Int()
    var iconImage = UIImage()
    let segController = UISegmentedControl(items: ["", ""])
    
    var shouldHaveSegm = Bool()
    var segIndex0 = String()
    var segIndex1 = String()
    
    let titleLabel = UILabel()
    let priceIndicator = UILabel()
    let iconImageView = UIImageView()
    
    var mainValue = String()
    var detailsInfos: [(String, String)]?
    
    var divisor: UIView!
    var detailStack: UIStackView!

    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector

    //MARK: - Helper functions
    
    func configure(){
        
        self.addSubview(holder)
        holder.allSideConstraint(inView: self)
        
        
        holder.addSubview(contentHolder)
        contentHolder.allSideConstraint(inView: holder, paddingX: 16)
        
        contentHolder.backgroundColor = .grayWhiteContrast
        contentHolder.layer.cornerRadius = 20
        
        contentHolder.addSubview(mainInfosHolder)
        mainInfosHolder.anchor(top: contentHolder.topAnchor, right: contentHolder.rightAnchor, left: contentHolder.leftAnchor, paddingTop: 5, height: 60)
        
        let iconView = UIView().viewWithShadow(viewColor: .black)
        iconView.layer.cornerRadius = 30
        iconView.backgroundColor = .grayWhiteContrast
        mainInfosHolder.addSubview(iconView)
        iconView.centerY(inView: mainInfosHolder)
        iconView.anchor(left: mainInfosHolder.leftAnchor, paddingLeft: 8, width: 60, height: 60)
        

        titleLabel.font = UIFont.systemFont(ofSize: 17)
        mainInfosHolder.addSubview(titleLabel)
        titleLabel.anchor(left: iconView.rightAnchor, paddingLeft: 8)
        titleLabel.centerY(inView: mainInfosHolder)
        
        
        
        priceIndicator.textColor = .customSystemGreen
        priceIndicator.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        mainInfosHolder.addSubview(priceIndicator)
        priceIndicator.anchor(right: contentHolder.rightAnchor, paddingRight: 8)
        priceIndicator.centerY(inView: mainInfosHolder)
        
        iconView.addSubview(iconImageView)
        iconImageView.setDimensions(width: 35, height: 35)
        iconImageView.centerX(inView: iconView)
        iconImageView.centerY(inView: iconView)
        
        
        contentHolder.addSubview(segController)
        segController.anchor(top: mainInfosHolder.bottomAnchor, right: contentHolder.rightAnchor, left: contentHolder.leftAnchor, paddingTop: 10, paddingRight: 8, paddingBottom: 5, paddingLeft: 8)
        segController.selectedSegmentIndex = 0
        segController.isHidden = true
        
    }
    
    func insertValue(){
        titleLabel.text = title
        
        if shouldShowPrice == true{
            if priceTag == 1{
                priceIndicator.text = "$"
            }else if priceTag == 2 {
                priceIndicator.text = "$$"
            }else{
                priceIndicator.text = "$$$"
            }
        }else{
            priceIndicator.textColor = .black
            priceIndicator.text = mainValue
        }
        
        iconImageView.image = iconImage
        
        if shouldHaveSegm == true{
            segController.isHidden = false
            segController.setTitle(segIndex0, forSegmentAt: 0)
            segController.setTitle(segIndex1, forSegmentAt: 1)
        }
    }
    
    func insertDetail(){
        divisor = UIView()
        detailStack = UIStackView()
        removeDetail()
        divisor.backgroundColor = .black
        divisor.alpha = 0.3
        contentHolder.addSubview(divisor)
        divisor.anchor(top: mainInfosHolder.bottomAnchor, right: contentHolder.rightAnchor, left: contentHolder.leftAnchor, paddingTop: 10, paddingRight: 16, paddingLeft: 16, height: 0.6)
        
        
        detailStack.spacing = 5
        detailStack.axis = .vertical
        contentHolder.addSubview(detailStack)
        detailStack.anchor(top: divisor.bottomAnchor, right: contentHolder.rightAnchor, left: contentHolder.leftAnchor, paddingTop: 10, paddingRight: 24, paddingLeft: 24)
        
        for sDetail in detailsInfos!{
            let label = UILabel()
            label.text = "\(sDetail.0): \(sDetail.1)"
            detailStack.addArrangedSubview(label)
        }
    }
    
    func removeDetail(){
        if let divisor = divisor{
            divisor.removeFromSuperview()
        }
        
        if let detailStack = detailStack{
            detailStack.removeFromSuperview()
        }
        
        
    }
}
