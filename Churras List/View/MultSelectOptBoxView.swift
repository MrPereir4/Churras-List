//
//  MultSelectOptBoxView.swift
//  Churras List
//
//  Created by Vinnicius Pereira on 19/01/21.
//

import UIKit

class MultSelectOptBoxView: UIView{
    //MARK: - Properties
    var title = String()
    var isSpendPicker = Bool()
    var indexSelected = Int()
    
    var segController: UISegmentedControl?
    
    //MARK: - Lifecycle
    required init(title: String, isSpendPicker: Bool? = true, indexSelected: Int) {
        self.title = title
        self.isSpendPicker = isSpendPicker!
        self.indexSelected = indexSelected
        super.init(frame: CGRect.zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector
    
    //MARK: - Helper functions
    
    private func configure(){
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        addSubview(stack)
        stack.anchor(top: self.topAnchor, right: self.rightAnchor, left: self.leftAnchor)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textAlignment = .left
        
        if isSpendPicker == true{
            segController = UISegmentedControl(items: ["Baixo", "Medio", "Alto"])
        }else{
            segController = UISegmentedControl(items: ["Sim", "Não"])
        }
        
        segController?.selectedSegmentIndex = indexSelected
        
        guard let segController = segController else {return}
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(segController)
    }
    
}
