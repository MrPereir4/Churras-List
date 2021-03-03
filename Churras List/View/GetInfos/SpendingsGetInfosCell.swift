//
//  SpendingsGetInfosCell.swift
//  Churras List
//
//  Created by Vinnicius Pereira on 19/01/21.
//

import UIKit
import LBTATools

class SpendingsGetInfosCell: UICollectionViewCell{
    
    //MARK: - Properties
    
    private let contentStackHolder = UIStackView()
    private let scrollView = UIScrollView()
    
    let meatSpending = MultSelectOptBoxView(title: "Carnes", indexSelected: 1)
    let beveragesSpending = MultSelectOptBoxView(title: "Bebidas", indexSelected: 1)
    let othersSpending = MultSelectOptBoxView(title: "Outros", indexSelected: 0)
    let addExtraSpending = MultSelectOptBoxView(title: "Adicionar quantidade extra?", isSpendPicker: false, indexSelected: 1)
    

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
        
        
        contentStackHolder.addArrangedSubview(meatSpending)
        
        meatSpending.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        
        contentStackHolder.addArrangedSubview(beveragesSpending)
        
        beveragesSpending.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        
        
        contentStackHolder.addArrangedSubview(othersSpending)
        
        othersSpending.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        
        
        contentStackHolder.addArrangedSubview(addExtraSpending)
        
        addExtraSpending.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
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
