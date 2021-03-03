//
//  ListViewController.swift
//  Churras List
//
//  Created by Vinnicius Pereira on 27/01/21.
//

import GoogleMobileAds
import UIKit

class ListViewController: UIViewController{
    
    //MARK: - Properties
    
    var bannerView: GADBannerView!
    
    let headerHolder = UIView()
    let headerTitle = UILabel()
    
    private var shareList = String()
    
    let controlButtonsStack = UIStackView()
    let buttonBack = UIButton(type: .system)
    let buttonNext = UIButton().buttonWithShadow(buttonTitle: "", buttonColor: .white)
    
    var listData: [ListOpt] = []
    
    let noItemAddedToList = UILabel()
    
    let mainTB: UITableView = {
        let tv = UITableView()
        tv.register(StandardItemShowCell.self, forCellReuseIdentifier: "tbCell")
        return tv
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHeader()
        cofigureMainTableView()
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-1544049467353622/1917879847"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    //MARK: - Selector
    
    @objc private func configureShareSheet(){
        let shareSheetVC = UIActivityViewController(activityItems: [shareList], applicationActivities: nil)
        present(shareSheetVC, animated: true, completion: nil)
    }
    
    @objc private func handleBack(){
        self.dismiss(animated: true, completion: nil)
    }

    
    //MARK: - Helper functions
    private func configureHeader(){
        view.addSubview(headerHolder)
        headerHolder.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, left: view.leftAnchor, paddingTop: 16, paddingRight: 16, paddingLeft: 16)
        
        headerTitle.text = "Lista"
        headerTitle.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        
        headerHolder.addSubview(headerTitle)
        headerTitle.anchor(top: headerHolder.topAnchor, bottom: headerHolder.bottomAnchor, left: headerHolder.leftAnchor)
        
        
        controlButtonsStack.axis = .horizontal
        headerHolder.addSubview(controlButtonsStack)
        controlButtonsStack.anchor(top: headerHolder.topAnchor, right: headerHolder.rightAnchor, bottom: headerHolder.bottomAnchor)
        
        buttonBack.setTitle("Voltar", for: .normal)
        buttonBack.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        buttonBack.setTitleColor(.black, for: .normal)
        buttonBack.setDimensions(width: 80, height: 46)
        buttonBack.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        controlButtonsStack.addArrangedSubview(buttonBack)
        
        let uploadIcon = UIImage(named: "upload")
        
        buttonNext.setImage(uploadIcon, for: .normal)
        buttonNext.imageEdgeInsets = UIEdgeInsets(top: 12, left: 38, bottom: 12, right: 38)
        buttonNext.contentVerticalAlignment = .fill
        buttonNext.contentHorizontalAlignment = .fill
        buttonNext.setDimensions(width: 100, height: 46)
        buttonNext.addTarget(self, action: #selector(configureShareSheet), for: .touchUpInside)
        controlButtonsStack.addArrangedSubview(buttonNext)
        
        //Creating share list
        shareList.append("Lista para o churrasco criada com *Churras List*!")
        shareList.append("\n\n")
        shareList.append("*Lista:*")
        shareList.append("\n\n")
        for element in listData{
            
            if element.name == "Refrigerante" || element.name == "Cerveja"{
                shareList.append("\(element.name): \(element.mainValue)")
                shareList.append("\n")
                
                shareList.append("  \(element.detailInfos[0].0): \(element.detailInfos[0].1) ")
                shareList.append("ou")
                shareList.append("  \(element.detailInfos[1].0): \(element.detailInfos[1].1)")
                
                shareList.append("\n\n")
            }else{
                if !element.detailInfos.isEmpty{
                    for el in element.detailInfos{
                        
                        shareList.append("\(el.0): \(el.1)")
                        shareList.append("\n\n")
                    }
                }else{
                    shareList.append("\(element.name): \(element.mainValue)")
                    shareList.append("\n\n")
                }
            }
            
            
        }
        print(listData)
    }
    
}



//MARK: - UITableView
extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    
    private func cofigureMainTableView(){
        mainTB.delegate = self
        mainTB.dataSource = self
        mainTB.backgroundColor = .white
        self.mainTB.separatorStyle = UITableViewCell.SeparatorStyle.none
        mainTB.showsVerticalScrollIndicator = false
        
        noItemAddedToList.text = "Nenhum item adicionado à lista"
        noItemAddedToList.font = UIFont.systemFont(ofSize: 17)
        noItemAddedToList.textColor = .lightGray
        mainTB.addSubview(noItemAddedToList)
        noItemAddedToList.centerY(inView: mainTB)
        noItemAddedToList.centerX(inView: mainTB)
        
        view.addSubview(mainTB)
        mainTB.anchor(top: headerHolder.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
        mainTB.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if Int(listData.count) != 0 {
            noItemAddedToList.isHidden = true
        }else{
            noItemAddedToList.isHidden = false
        }
        
        return listData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if listData[indexPath.section].detailInfos.count == 0{
            return 70
        }else if listData[indexPath.section].detailInfos.count == 1{
            return 115
        }else{
            let num = listData[indexPath.section].detailInfos.count
            return CGFloat(115 + ((num - 1) * 25))
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tbCell", for: indexPath) as! StandardItemShowCell
        cell.title = listData[indexPath.section].name
        cell.shouldShowPrice = false
        cell.iconImage = listData[indexPath.section].image
        cell.mainValue = listData[indexPath.section].mainValue
        
        cell.detailsInfos = listData[indexPath.section].detailInfos
        cell.contentView.isUserInteractionEnabled = false
        if listData[indexPath.section].shouldPresendMoreInfo == true{
            if listData[indexPath.section].detailInfos.count > 0{
                cell.removeDetail()
                cell.insertDetail()
            }else{
                cell.removeDetail()
            }
        }else{
            cell.removeDetail()
        }
        
        
        cell.insertValue()
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
            return headerView
    }
    
    
}


//MARK: - Ads
extension ListViewController{
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
}
