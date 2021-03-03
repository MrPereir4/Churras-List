//
//  PeopleGetInfosCell.swift
//  Churras List
//
//  Created by Vinnicius Pereira on 11/01/21.
//

import UIKit
import LBTATools

class PeopleGetInfosCell: UICollectionViewCell{
    //MARK: - Properties
    
    private let contentStackHolder = UIStackView()
    private let scrollView = UIScrollView()
    
    let mansPicker = PeopleQuantityBoxView(title: "Homens", image: #imageLiteral(resourceName: "dad"))
    let womansPicker = PeopleQuantityBoxView(title: "Mulheres", image: #imageLiteral(resourceName: "businesswoman"))
    let kidsPicker = PeopleQuantityBoxView(title: "Crianças", image: #imageLiteral(resourceName: "children"))
    let barbecueDurationPicker = PeopleQuantityBoxView(title: "Duração do churrasco", image: #imageLiteral(resourceName: "clock"), isTimePicker: true)

    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureScrollHeight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    
    
    //MARK: - Helper functions
    
    private func configure(){
        scrollView.contentInsetAdjustmentBehavior = .never
               
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
       
        scrollView.frame.size = frame.size
        scrollView.fillSuperview()
        scrollView.backgroundColor = .white
       
        contentStackHolder.isLayoutMarginsRelativeArrangement = true
        contentStackHolder.axis = .vertical
       
        scrollView.addSubview(contentStackHolder)
       
        contentStackHolder.anchor(top: scrollView.topAnchor,
                                  right: self.rightAnchor,
                                  left: self.leftAnchor,
                                 paddingRight: 16,
                                 paddingLeft: 16)
        
        contentStackHolder.spacing = 30
        
        contentStackHolder.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 70, right: 0)
        
        
        mansPicker.translatesAutoresizingMaskIntoConstraints = false
        womansPicker.translatesAutoresizingMaskIntoConstraints = false
        kidsPicker.translatesAutoresizingMaskIntoConstraints = false
        barbecueDurationPicker.translatesAutoresizingMaskIntoConstraints = false
        
        contentStackHolder.addArrangedSubview(mansPicker)
        mansPicker.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        contentStackHolder.addArrangedSubview(womansPicker)
        womansPicker.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        contentStackHolder.addArrangedSubview(kidsPicker)
        kidsPicker.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        contentStackHolder.addArrangedSubview(barbecueDurationPicker)
        
        barbecueDurationPicker.heightAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    private func configureScrollHeight(){
        contentStackHolder.layoutIfNeeded()
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        let safeAreas = (window?.safeAreaInsets.bottom)! + 8
        
        if contentStackHolder.frame.height > self.frame.height - safeAreas{
            scrollView.contentSize.height = contentStackHolder.frame.height + safeAreas
        }
    }
}
