//
//  HomeViewController.swift
//  Churras List
//
//  Created by Vinnicius Pereira on 09/01/21.
//

import UIKit


class HomeViewController: UIViewController{
    //MARK: - Properties

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    //MARK: - Selector
    
    @objc private func handleBegin(){
        let fullGetInfosViewController = FullGetInfosViewController()
        fullGetInfosViewController.modalPresentationStyle = .fullScreen
        present(fullGetInfosViewController, animated: true, completion: nil)
    }

    //MARK: - Helper functions
    private func configure(){
        view.backgroundColor = .white
        
        let beginButton = UIButton().buttonWithShadow(buttonTitle: "Começar", buttonColor: .brown)
        
        view.addSubview(beginButton)
                
        beginButton.addTarget(self, action: #selector(handleBegin), for: .touchUpInside)
        
        beginButton.anchor(right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.leftAnchor, paddingRight: 16, paddingBottom: 16, paddingLeft: 16, height: 56)
        
        ///- Inserting logo
        
        let stackLogoHolder = UIStackView()
        stackLogoHolder.axis = .horizontal
        stackLogoHolder.alignment = .center
        stackLogoHolder.spacing = 10
        stackLogoHolder.distribution = .fillProportionally
        view.addSubview(stackLogoHolder)
        
        stackLogoHolder.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 30)
        stackLogoHolder.centerX(inView: view)
        
        let logoImageIcon = UIImageView(image: #imageLiteral(resourceName: "logoIcon"))
        let logoImageText = UIImageView(image: #imageLiteral(resourceName: "logoText"))
        
        logoImageText.setDimensions(width: 200, height: 200)
        
        logoImageIcon.setDimensions(width: 115, height: 115)
        stackLogoHolder.addArrangedSubview(logoImageIcon)
        stackLogoHolder.addArrangedSubview(logoImageText)
        
        ///- Inserting app descripition
        
        let appDesc = UILabel()
        
        view.addSubview(appDesc)
        appDesc.numberOfLines = 0
        appDesc.text = "Ferramenta que auxilia a organização do seu churrasco!"
        appDesc.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        appDesc.textAlignment = .center
        appDesc.anchor(top: stackLogoHolder.bottomAnchor, right: view.rightAnchor, left: view.leftAnchor, paddingTop: 50, paddingRight: 16, paddingLeft: 16)
        
        
    }
}
