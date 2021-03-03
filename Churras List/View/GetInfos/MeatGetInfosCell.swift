//
//  MeatGetInfosCell.swift
//  Churras List
//
//  Created by Vinnicius Pereira on 11/01/21.
//

import UIKit

class MeatGetInfosCell: UICollectionViewCell{
    
    //MARK: - Properties
    
    var meatData =
        [Meat(name: "Picanha", price: 3, image: #imageLiteral(resourceName: "cow"), type: 0, isMarked: false),
        Meat(name: "Maminha", price: 3, image: #imageLiteral(resourceName: "cow"), type: 0, isMarked: false),
        Meat(name: "Filé mignon", price: 3, image: #imageLiteral(resourceName: "cow"), type: 0, isMarked: false),
        Meat(name: "Entrecot", price: 3, image: #imageLiteral(resourceName: "cow"), type: 0, isMarked: false),
        Meat(name: "Alcatra", price: 3, image: #imageLiteral(resourceName: "cow"), type: 0, isMarked: false),
        Meat(name: "Lagarto", price: 2, image: #imageLiteral(resourceName: "cow"), type: 0, isMarked: false),
        Meat(name: "Coxão mole", price: 2, image: #imageLiteral(resourceName: "cow"), type: 0, isMarked: false),
        Meat(name: "Coxão duro", price: 2, image: #imageLiteral(resourceName: "cow"), type: 0, isMarked: false),
        Meat(name: "Patinho", price: 2, image: #imageLiteral(resourceName: "cow"), type: 0, isMarked: false),
        Meat(name: "Cupim", price: 3, image: #imageLiteral(resourceName: "cow"), type: 0, isMarked: false),
        Meat(name: "Fraldinha", price: 1, image: #imageLiteral(resourceName: "cow"), type: 0, isMarked: false),
        Meat(name: "Capa de filé", price: 1, image: #imageLiteral(resourceName: "cow"), type: 0, isMarked: false),
        Meat(name: "Paleta", price: 1, image: #imageLiteral(resourceName: "cow"), type: 0, isMarked: false),
        Meat(name: "Peito", price: 1, image: #imageLiteral(resourceName: "cow"), type: 0, isMarked: false),
        Meat(name: "Costela", price: 1, image: #imageLiteral(resourceName: "cow"), type: 0, isMarked: false),
        Meat(name: "Filé mignon suína", price: 2, image: #imageLiteral(resourceName: "pig"), type: 1, isMarked: false),
        Meat(name: "Picanha suína", price: 2, image: #imageLiteral(resourceName: "pig"), type: 1, isMarked: false),
        Meat(name: "Lombo", price: 2, image: #imageLiteral(resourceName: "pig"), type: 1, isMarked: false),
        Meat(name: "Maminha suína", price: 2, image: #imageLiteral(resourceName: "pig"), type: 1, isMarked: false),
        Meat(name: "Asa de frango", price: 1, image: #imageLiteral(resourceName: "hen"), type: 2, isMarked: false),
        Meat(name: "Coxa de frango", price: 1, image: #imageLiteral(resourceName: "hen"), type: 2, isMarked: false),
        Meat(name: "Tulipa de frango", price: 1, image: #imageLiteral(resourceName: "hen"), type: 2, isMarked: false)
        ]
    
    var meatSelected: [Meat] = []

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
extension MeatGetInfosCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    
    private func configureMainColletionView(){
        mainCV.delegate = self
        mainCV.dataSource = self
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meatData.count
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
            
            if meatData[indexPath.row].isMarked == false{
                meatData[indexPath.row].isMarked = true
                meatSelected.append(meatData[indexPath.row])
                cell.selectBox()
            }else{
                
                meatData[indexPath.row].isMarked = false
                meatSelected.removeAll(where: {$0.name == meatData[indexPath.row].name})
                cell.deselectBox()
            }
            mainTB.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StandardItemPickCell
        
        cell.boxName = meatData[indexPath.row].name
        cell.iconImage = meatData[indexPath.row].image
        if meatData[indexPath.row].isMarked == false{
            cell.deselectBox()
        }else{
            cell.selectBox()
        }
        
        cell.insertValue()
        return cell
    }
}

//MARK: - UITableView
extension MeatGetInfosCell: UITableViewDelegate, UITableViewDataSource{
    
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
        listLabel.text = "Lista - \(String(Int(meatSelected.count)))"
        if Int(meatSelected.count) != 0 {
            noItemAddedToList.isHidden = true
        }else{
            noItemAddedToList.isHidden = false
        }
        return meatSelected.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tbCell", for: indexPath) as! StandardItemShowCell
        cell.title = meatSelected[indexPath.section].name
        cell.priceTag = meatSelected[indexPath.section].price
        cell.iconImage = meatSelected[indexPath.section].image
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
