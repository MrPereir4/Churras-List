//
//  BeveragesGetInfosCell.swift
//  Churras List
//
//  Created by Vinnicius Pereira on 18/01/21.
//

import UIKit

class BeveragesGetInfosCell: UICollectionViewCell{
    //MARK: - Properties
    
    var beveragesData: [Beverages] = [
        Beverages(name: "Cerveja", price: 2, image: #imageLiteral(resourceName: "beer"), firstOpt: "Lata", sncOpt: "Garrafa", shouldHaveSegment: false, isMarked: false),
        Beverages(name: "Água", price: 2, image: #imageLiteral(resourceName: "plastic-bottle"), firstOpt: "", sncOpt: "", isMarked: false),
        Beverages(name: "Suco", price: 2, image: #imageLiteral(resourceName: "orange-juice"), firstOpt: "", sncOpt: "", isMarked: false),
        Beverages(name: "Refrigerante", price: 2, image: #imageLiteral(resourceName: "soda"), firstOpt: "Lata", sncOpt: "Garrafa", shouldHaveSegment: false, isMarked: false),
        Beverages(name: "Destilado", price: 3, image: #imageLiteral(resourceName: "vodka"), firstOpt: "", sncOpt: "", isMarked: false)
    ]
    
    var beveragesSelected: [Beverages] = []

    let mainCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(StandardItemPickCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        return cv
    }()
    
    let mainTB: UITableView = {
        let tv = UITableView()
        tv.register(StandardItemShowCell.self, forCellReuseIdentifier: "tbCell")
        return tv
    }()
    
    let listLabel = UILabel()
    
    let noItemAddedToList = UILabel()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureMainColletionView()
        cofigureMainTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selector

    //MARK: - Helper functions
    
    private func configure(){
        self.addSubview(mainCV)
        self.backgroundColor = .white
        mainCV.anchor(top: self.topAnchor, right: self.rightAnchor, left: self.leftAnchor, height: 125)
        
        
        listLabel.text = "Lista - 0"
        listLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        self.addSubview(listLabel)
        listLabel.anchor(top: mainCV.bottomAnchor, right: self.rightAnchor, left: self.leftAnchor, paddingTop: 5, paddingRight: 16, paddingLeft: 16)
        
    }
}

//MARK: - UICollectionView
extension BeveragesGetInfosCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    
    private func configureMainColletionView(){
        mainCV.delegate = self
        mainCV.dataSource = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return beveragesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? StandardItemPickCell {
            if beveragesData[indexPath.row].isMarked == false{
                beveragesData[indexPath.row].isMarked = true
                beveragesSelected.append(beveragesData[indexPath.row])
                cell.selectBox()
            }else{
                
                beveragesData[indexPath.row].isMarked = false
                beveragesSelected.removeAll(where: {$0.name == beveragesData[indexPath.row].name})
                cell.deselectBox()
            }
            mainTB.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StandardItemPickCell
        cell.boxName = beveragesData[indexPath.row].name
        cell.iconImage = beveragesData[indexPath.row].image
        
        if beveragesData[indexPath.row].isMarked == false{
            cell.deselectBox()
        }else{
            cell.selectBox()
        }
        
        cell.insertValue()
        return cell
    }
}


//MARK: - UITableView
extension BeveragesGetInfosCell: UITableViewDelegate, UITableViewDataSource{
    
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
        
        self.addSubview(mainTB)
        mainTB.anchor(top: listLabel.bottomAnchor, right: self.rightAnchor, bottom: self.bottomAnchor, left: self.leftAnchor, paddingTop: 5)
        mainTB.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        listLabel.text = "Lista - \(String(Int(beveragesSelected.count)))"
        
        if Int(beveragesSelected.count) != 0 {
            noItemAddedToList.isHidden = true
        }else{
            noItemAddedToList.isHidden = false
        }
        
        return beveragesSelected.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if beveragesSelected[indexPath.section].shouldHaveSegment == true{
            return 113
        }else{
            return 70
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tbCell", for: indexPath) as! StandardItemShowCell
        cell.title = beveragesSelected[indexPath.section].name
        cell.priceTag = beveragesSelected[indexPath.section].price
        cell.iconImage = beveragesSelected[indexPath.section].image
        cell.shouldHaveSegm = beveragesSelected[indexPath.section].shouldHaveSegment!
        cell.segIndex0 = beveragesSelected[indexPath.section].firstOpt
        cell.segIndex1 = beveragesSelected[indexPath.section].sncOpt
        cell.segController.isHidden = true
        cell.contentView.isUserInteractionEnabled = false
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
