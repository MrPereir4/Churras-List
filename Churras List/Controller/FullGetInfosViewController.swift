//
//  FullGetInfosViewController.swift
//  Churras List
//
//  Created by Vinnicius Pereira on 09/01/21.
//

import GoogleMobileAds
import UIKit

class FullGetInfosViewController: UIViewController{
    //MARK: - Properties
    
    var bannerView: GADBannerView!
    
    let headerHolder = UIView()
    let headerTitle = UILabel()
    let listHeaderTitle: [String] = ["Pessoas", "Carnes", "Bebidas", "Outros", "Gastos"]
    
    var fullList: ((Int, Int, Int, Int), [Meat], [Beverages], [Others], (Int, Int, Int, Int)) = ((0, 0, 0, 0), [], [], [], (1, 1, 0, 1))
    
    var returnFullList: [ListOpt] = []
    
    var meatWeight = 0
    var totalLiterQnt = 0
    
    var peopleCell: PeopleGetInfosCell?
    var meatCell: MeatGetInfosCell?
    var beveragesCell: BeveragesGetInfosCell?
    var othersCell: OthersGetInfosCell?
    var spendingsCell: SpendingsGetInfosCell?
    
    private let colView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(PeopleGetInfosCell.self, forCellWithReuseIdentifier: "peopleCell")
        cv.register(MeatGetInfosCell.self, forCellWithReuseIdentifier: "meatCell")
        cv.register(BeveragesGetInfosCell.self, forCellWithReuseIdentifier: "beverageCell")
        cv.register(OthersGetInfosCell.self, forCellWithReuseIdentifier: "othersCell")
        cv.register(SpendingsGetInfosCell.self, forCellWithReuseIdentifier: "spendingsCell")
        cv.showsHorizontalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.isScrollEnabled = false
        return cv
    }()
    
    let controlButtonsStack = UIStackView()
    let buttonBack = UIButton(type: .system)
    let buttonNext = UIButton().buttonWithShadow(buttonTitle: "Próximo", buttonColor: .brown)

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-1544049467353622/1917879847"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }

    //MARK: - Selector
    @objc private func handleButtonNext(){
        
        let nextIndex = (colView.contentOffset.x / colView.frame.size.width) + 1
        buttonBack.isHidden = false
        
        if nextIndex == 1{
            fullList.0.0 = Int((peopleCell?.mansPicker.slider.value)!)
            fullList.0.1 = Int((peopleCell?.womansPicker.slider.value)!)
            fullList.0.2 = Int((peopleCell?.kidsPicker.slider.value)!)
            fullList.0.3 = Int((peopleCell?.barbecueDurationPicker.slider.value)!)
        }else if nextIndex == 2{
            fullList.1 = meatCell!.meatSelected
        }else if nextIndex == 3{
            fullList.2 = beveragesCell!.beveragesSelected
        }else if nextIndex == 4{
            fullList.3 = othersCell!.othersSelected
            buttonNext.removeTarget(self, action: #selector(handleButtonNext), for: .touchUpInside)
            buttonNext.addTarget(self, action: #selector(handlePresentList), for: .touchUpInside)
            buttonNext.setTitle("Lista", for: .normal)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.headerTitle.alpha = 0
            self.headerTitle.text = self.listHeaderTitle[Int(nextIndex)]
            self.headerTitle.alpha = 1
        } completion: { (_) in
            
        }
        
        print(nextIndex)
        let indexPath = IndexPath(item: Int(nextIndex), section: 0)
        
        colView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    @objc private func handleButtonBack(){
        let prevIndex = (colView.contentOffset.x / colView.frame.size.width) - 1
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.headerTitle.alpha = 0
            self.headerTitle.text = self.listHeaderTitle[Int(prevIndex)]
            self.headerTitle.alpha = 1
        } completion: { (_) in
            
        }
        
        if Int(prevIndex) == 0{
            buttonBack.isHidden = true
        }else if Int(prevIndex) == 3{
            buttonNext.removeTarget(self, action: #selector(handlePresentList), for: .touchUpInside)
            buttonNext.setTitle("Próximo", for: .normal)
            buttonNext.addTarget(self, action: #selector(handleButtonNext), for: .touchUpInside)
        }
        
        let indexPath = IndexPath(item: Int(prevIndex), section: 0)
        colView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
    }
    
    @objc private func handlePresentList(){
        fullList.4.0 = (spendingsCell?.meatSpending.segController!.selectedSegmentIndex)!
        fullList.4.1 = (spendingsCell?.beveragesSpending.segController!.selectedSegmentIndex)!
        fullList.4.2 = (spendingsCell?.othersSpending.segController!.selectedSegmentIndex)!
        fullList.4.3 = (spendingsCell?.addExtraSpending.segController!.selectedSegmentIndex)!

        calculateValues()
        
        
        let listVC = ListViewController()
        listVC.modalPresentationStyle = .fullScreen
        listVC.listData = returnFullList
        self.present(listVC, animated: true, completion: nil)
        
        returnFullList = []
        
    }

    //MARK: - Helper functions
    private func configure(){
        view.backgroundColor = .white
        configureHeader()
        configureCollectionView()
    }
    
    private func configureHeader(){
        view.addSubview(headerHolder)
        headerHolder.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, left: view.leftAnchor, paddingTop: 16, paddingRight: 16, paddingLeft: 16)
        
        headerTitle.text = "Pessoas"
        headerTitle.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        
        headerHolder.addSubview(headerTitle)
        headerTitle.anchor(top: headerHolder.topAnchor, bottom: headerHolder.bottomAnchor, left: headerHolder.leftAnchor)
        
        
        controlButtonsStack.axis = .horizontal
        headerHolder.addSubview(controlButtonsStack)
        controlButtonsStack.anchor(top: headerHolder.topAnchor, right: headerHolder.rightAnchor, bottom: headerHolder.bottomAnchor)
        
        buttonBack.isHidden = true
        buttonBack.setTitle("Voltar", for: .normal)
        buttonBack.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        buttonBack.setTitleColor(.black, for: .normal)
        buttonBack.setDimensions(width: 80, height: 46)
        buttonBack.addTarget(self, action: #selector(handleButtonBack), for: .touchUpInside)
        controlButtonsStack.addArrangedSubview(buttonBack)
        
        
        buttonNext.setDimensions(width: 100, height: 46)
        buttonNext.addTarget(self, action: #selector(handleButtonNext), for: .touchUpInside)
        controlButtonsStack.addArrangedSubview(buttonNext)
    }
    
}

//MARK: - UICollectionView

extension FullGetInfosViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    private func configureCollectionView(){
        colView.delegate = self
        colView.dataSource = self
        colView.backgroundColor = .green
        view.addSubview(colView)
        colView.anchor(top: headerHolder.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: colView.frame.size.width, height: colView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0{
            peopleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "peopleCell", for: indexPath) as? PeopleGetInfosCell
            peopleCell!.contentView.isUserInteractionEnabled = false
            return peopleCell!
        }else if indexPath.item == 1{
            meatCell = collectionView.dequeueReusableCell(withReuseIdentifier: "meatCell", for: indexPath) as? MeatGetInfosCell
            meatCell!.contentView.isUserInteractionEnabled = false
            return meatCell!
        }else if indexPath.item == 2{
            beveragesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "beverageCell", for: indexPath) as? BeveragesGetInfosCell
            beveragesCell!.contentView.isUserInteractionEnabled = false
            return beveragesCell!
        }else if indexPath.item == 3{
            othersCell = collectionView.dequeueReusableCell(withReuseIdentifier: "othersCell", for: indexPath) as? OthersGetInfosCell
            othersCell!.contentView.isUserInteractionEnabled = false
            return othersCell!
        }else{
            spendingsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "spendingsCell", for: indexPath) as? SpendingsGetInfosCell
            spendingsCell!.contentView.isUserInteractionEnabled = false
            return spendingsCell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


//MARK: - Calculate values

extension FullGetInfosViewController{
    private func calculateValues(){
        calculateMeat(mens: fullList.0.0, womans: fullList.0.1, kids: fullList.0.2, duration: fullList.0.3, spendsMult: fullList.4.0, meats: fullList.1, addExtra: fullList.4.3)
        
        calculateBeverages(mens: fullList.0.0, womans: fullList.0.1, kids: fullList.0.2, duration: fullList.0.3, spendsMult: fullList.4.0, beverages: fullList.2, addExtra: fullList.4.3)
        
        calculateOther(mens: fullList.0.0, womans: fullList.0.1, kids: fullList.0.2, duration: fullList.0.3, spendsMult: fullList.4.0, others: fullList.3, addExtra: fullList.4.3, meatWeight: meatWeight, literQnt: totalLiterQnt)
    }
    
    private func calculateMeat(mens: Int, womans: Int, kids: Int, duration: Int, spendsMult: Int, meats: [Meat], addExtra: Int){
        let mensMeatWeight = mens * 400//Mans meat average weight
        let womansMeatWeight = womans * 300//Womans meat average weight
        let kidsMeatWeight = kids * 200 //kids meat average weight
        
        var noMeatCow = false
        var noMeatPig = false
        var noMeatChicken = false
        
        var totalWeight: Double = Double(mensMeatWeight + womansMeatWeight + kidsMeatWeight)
        var durationChange = 1.0
        if duration > 5{
            durationChange = durationChange + (Double(duration) - 5.0) / 15.0
        }else if duration < 5{
            durationChange = durationChange - (5.0 - Double(duration)) / 15.0
        }
        
        
        if addExtra == 1{
            totalWeight = totalWeight * durationChange
        }else{
            totalWeight = totalWeight * durationChange * 1.15
        }
        
        
        
        var cowMeat = 0.0
        var pigMeat = 0.0
        var chickenMeat = 0.0
        
        var lvl1MeatCow: [Meat] = []
        var lvl2MeatCow: [Meat] = []
        var lvl3MeatCow: [Meat] = []
        
        var lvl1MeatPig: [Meat] = []
        var lvl2MeatPig: [Meat] = []
        var lvl3MeatPig: [Meat] = []
        
        var lvl1MeatChicken: [Meat] = []
        
        for sMeat in meats{
            if sMeat.price == 1{
                if sMeat.type == 0{
                    lvl1MeatCow.append(sMeat)
                }else if sMeat.type == 1{
                    lvl1MeatPig.append(sMeat)
                }else{
                    lvl1MeatChicken.append(sMeat)
                }
            }else if sMeat.price == 2{
                if sMeat.type == 0{
                    lvl2MeatCow.append(sMeat)
                }else if sMeat.type == 1{
                    lvl2MeatPig.append(sMeat)
                }else{
                    lvl1MeatChicken.append(sMeat)
                }
            }else if sMeat.price == 3{
                if sMeat.type == 0{
                    lvl3MeatCow.append(sMeat)
                }else if sMeat.type == 1{
                    lvl3MeatPig.append(sMeat)
                }else{
                    lvl1MeatChicken.append(sMeat)
                }
            }
        }
        
        var lvl1WeightCowQnt = 0.0
        var lvl2WeightCowQnt = 0.0
        var lvl3WeightCowQnt = 0.0
        
        var lvl1WeightPigQnt = 0.0
        var lvl2WeightPigQnt = 0.0
        var lvl3WeightPigQnt = 0.0
        
        var lvl1WeightChickenQnt = 0.0
        
        let cowMeatQuantityMult = calculateWeightByPrice(lvl1Meat: lvl1MeatCow, lvl2Meat: lvl2MeatCow, lvl3Meat: lvl3MeatCow, priceMult: spendsMult)
        
        let pigMeatQuantityMult = calculateWeightByPrice(lvl1Meat: lvl1MeatPig, lvl2Meat: lvl2MeatPig, lvl3Meat: lvl3MeatPig, priceMult: spendsMult)
        
        if cowMeatQuantityMult.0 == 0 && cowMeatQuantityMult.1 == 0 && cowMeatQuantityMult.2 == 0{
            noMeatCow = true
        }
        
        if pigMeatQuantityMult.0 == 0 && pigMeatQuantityMult.1 == 0 && pigMeatQuantityMult.2 == 0{
            noMeatPig = true
        }
        
        if lvl1MeatChicken.isEmpty{
            noMeatChicken = true
        }
        
        if noMeatCow == true && noMeatPig == true && noMeatChicken == true{
            return
            
        }else if noMeatCow == true && noMeatPig == false && noMeatChicken == false{
            
            cowMeat = totalWeight * 0.0
            pigMeat = totalWeight * 0.7
            chickenMeat = totalWeight * 0.3
            
        }else if noMeatCow == true && noMeatPig == false && noMeatChicken == true{
            
            cowMeat = totalWeight * 0.0
            pigMeat = totalWeight * 1.0
            chickenMeat = totalWeight * 0.0
            
        }else if noMeatCow == false && noMeatPig == true && noMeatChicken == true{
            
            cowMeat = totalWeight * 1.0
            pigMeat = totalWeight * 0.0
            chickenMeat = totalWeight * 0.0
            
        }else if noMeatCow == false && noMeatPig == true && noMeatChicken == false{
            
            cowMeat = totalWeight * 0.7
            pigMeat = totalWeight * 0.0
            chickenMeat = totalWeight * 0.3
            
        }else if noMeatCow == false && noMeatPig == false && noMeatChicken == true{
            
            cowMeat = totalWeight * 0.7
            pigMeat = totalWeight * 0.3
            chickenMeat = totalWeight * 0.0
            
        }else{
            cowMeat = totalWeight * 0.6
            pigMeat = totalWeight * 0.2
            chickenMeat = totalWeight * 0.2
        }
        
        if lvl1MeatCow.count == 0{
            lvl1WeightCowQnt = 0.0
        }else{
            lvl1WeightCowQnt = (cowMeat * cowMeatQuantityMult.0) / Double(lvl1MeatCow.count)
        }
        
        if lvl2MeatCow.count == 0{
            lvl2WeightCowQnt = 0.0
        }else{
            lvl2WeightCowQnt = (cowMeat * cowMeatQuantityMult.1) / Double(lvl2MeatCow.count)
        }

        if lvl3MeatCow.count == 0{
            lvl3WeightCowQnt = 0.0
        }else{
            lvl3WeightCowQnt = (cowMeat * cowMeatQuantityMult.2) / Double(lvl3MeatCow.count)
        }
        
        if lvl1MeatPig.count == 0{
            lvl1WeightPigQnt = 0.0
        }else{
            lvl1WeightPigQnt = (pigMeat * pigMeatQuantityMult.0) / Double(lvl1MeatPig.count)
        }
        
        if lvl2MeatPig.count == 0{
            lvl2WeightPigQnt = 0.0
        }else{
            lvl2WeightPigQnt = (pigMeat * pigMeatQuantityMult.1) / Double(lvl2MeatPig.count)
        }
        
        if lvl3MeatPig.count == 0{
            lvl3WeightPigQnt = 0.0
        }else{
            lvl3WeightPigQnt = (pigMeat * pigMeatQuantityMult.2) / Double(lvl3MeatPig.count)
        }
        
        lvl1WeightChickenQnt = chickenMeat / Double(lvl1MeatChicken.count)
        
        if totalWeight != 0.0{
            totalWeight = totalWeight / 1000
            lvl1WeightCowQnt = lvl1WeightCowQnt / 1000
            lvl2WeightCowQnt = lvl2WeightCowQnt / 1000
            lvl3WeightCowQnt = lvl3WeightCowQnt / 1000
            lvl1WeightPigQnt = lvl1WeightPigQnt / 1000
            lvl2WeightPigQnt = lvl2WeightPigQnt / 1000
            lvl3WeightPigQnt = lvl3WeightPigQnt / 1000
            lvl1WeightChickenQnt = lvl1WeightChickenQnt / 1000
            
            let weightFormatter = NumberFormatter()
            weightFormatter.numberStyle = .decimal
            weightFormatter.roundingMode = .up
            weightFormatter.maximumFractionDigits = 2
            
            
            var finalWeight = weightFormatter.string(from: NSNumber(value: totalWeight))
            finalWeight = finalWeight?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
            
            var lvl1WeightCowQntSt = weightFormatter.string(from: NSNumber(value: lvl1WeightCowQnt))
            lvl1WeightCowQntSt = lvl1WeightCowQntSt?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
            
            var lvl2WeightCowQntSt = weightFormatter.string(from: NSNumber(value: lvl2WeightCowQnt))
            lvl2WeightCowQntSt = lvl2WeightCowQntSt?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
            
            var lvl3WeightCowQntSt = weightFormatter.string(from: NSNumber(value: lvl3WeightCowQnt))
            lvl3WeightCowQntSt = lvl3WeightCowQntSt?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
            
            
            
            var lvl1WeightPigQntSt = weightFormatter.string(from: NSNumber(value: lvl1WeightPigQnt))
            lvl1WeightPigQntSt = lvl1WeightPigQntSt?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
            
            var lvl2WeightPigQntSt = weightFormatter.string(from: NSNumber(value: lvl2WeightPigQnt))
            lvl2WeightPigQntSt = lvl2WeightPigQntSt?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
            
            var lvl3WeightPigQntSt = weightFormatter.string(from: NSNumber(value: lvl3WeightPigQnt))
            lvl3WeightPigQntSt = lvl1WeightPigQntSt?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
            
            
            var lvl1WeightChickenQntSt = weightFormatter.string(from: NSNumber(value: lvl1WeightChickenQnt))
            lvl1WeightChickenQntSt = lvl1WeightChickenQntSt?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
            
            var auxDetailInfos: [(String, String)] = []
            
            for mtCow in lvl1MeatCow{
                auxDetailInfos.append((mtCow.name, lvl1WeightCowQntSt! + "Kg"))
            }
            
            for mtCow in lvl2MeatCow{
                auxDetailInfos.append((mtCow.name, lvl2WeightCowQntSt! + "Kg"))
            }
            
            for mtCow in lvl3MeatCow{
                auxDetailInfos.append((mtCow.name, lvl3WeightCowQntSt! + "Kg"))
            }
            
            for mtPig in lvl1MeatPig{
                auxDetailInfos.append((mtPig.name, lvl1WeightPigQntSt! + "Kg"))
            }
            
            for mtPig in lvl2MeatPig{
                auxDetailInfos.append((mtPig.name, lvl2WeightPigQntSt! + "Kg"))
            }
            
            for mtPig in lvl3MeatPig{
                auxDetailInfos.append((mtPig.name, lvl3WeightPigQntSt! + "Kg"))
            }
            
            for mtChk in lvl1MeatChicken{
                auxDetailInfos.append((mtChk.name, lvl1WeightChickenQntSt! + "Kg"))
            }
            
            meatWeight = Int(totalWeight)
            
            returnFullList.append(ListOpt(name: "Carnes", image: #imageLiteral(resourceName: "logoIcon"), mainValue: finalWeight! + "Kg", detailInfos: auxDetailInfos, shouldPresendMoreInfo: true))
        }
    }
    
    private func calculateWeightByPrice(lvl1Meat: [Meat], lvl2Meat: [Meat], lvl3Meat: [Meat], priceMult: Int) -> (Double, Double, Double){
        
        var lvl3Price = 0.30
        var lvl2Price = 0.50
        var lvl1Price = 0.20
        
        
        if lvl1Meat.isEmpty && lvl2Meat.isEmpty && lvl3Meat.isEmpty{
            return (0.0, 0.0, 0.0)
            
        }else if !lvl1Meat.isEmpty && lvl2Meat.isEmpty && lvl3Meat.isEmpty{
            
            lvl1Price = 1.0
            lvl2Price = 0.0
            lvl3Price = 0.0
            
            return (lvl1Price, lvl2Price, lvl3Price)
            
        }else if lvl1Meat.isEmpty && !lvl2Meat.isEmpty && lvl3Meat.isEmpty{
            lvl1Price = 0.0
            lvl2Price = 1.0
            lvl3Price = 0.0
            
            return (lvl1Price, lvl2Price, lvl3Price)
        }else if lvl1Meat.isEmpty && lvl2Meat.isEmpty && !lvl3Meat.isEmpty{
            lvl1Price = 0.0
            lvl2Price = 0.0
            lvl3Price = 1.0
            
            return (lvl1Price, lvl2Price, lvl3Price)
        }else if !lvl1Meat.isEmpty && !lvl2Meat.isEmpty && lvl3Meat.isEmpty{
            
            lvl1Price = 0.6
            lvl2Price = 0.4
            lvl3Price = 0.0
            
            if priceMult == 0{
                lvl1Price = 0.7
                lvl2Price = 0.3
                lvl3Price = 0.0
            }else if priceMult == 2{
                lvl1Price = 0.3
                lvl2Price = 0.7
                lvl3Price = 0.0
            }
            
            return (lvl1Price, lvl2Price, lvl3Price)
        }else if !lvl1Meat.isEmpty && lvl2Meat.isEmpty && !lvl3Meat.isEmpty{
            
            lvl1Price = 0.6
            lvl2Price = 0.0
            lvl3Price = 0.4
            
            if priceMult == 0{
                lvl1Price = 0.7
                lvl2Price = 0.0
                lvl3Price = 0.3
            }else if priceMult == 2{
                lvl1Price = 0.3
                lvl2Price = 0.0
                lvl3Price = 0.7
            }
            return (lvl1Price, lvl2Price, lvl3Price)
        }else if lvl1Meat.isEmpty && !lvl2Meat.isEmpty && !lvl3Meat.isEmpty{
            
            lvl1Price = 0.0
            lvl2Price = 0.6
            lvl3Price = 0.4
            
            if priceMult == 0{
                lvl1Price = 0.0
                lvl2Price = 0.7
                lvl3Price = 0.3
            }else if priceMult == 2{
                lvl1Price = 0.0
                lvl2Price = 0.3
                lvl3Price = 0.7
            }
            return (lvl1Price, lvl2Price, lvl3Price)
        }else{
            lvl1Price = 0.3
            lvl2Price = 0.5
            lvl3Price = 0.2
            
            return (lvl1Price, lvl2Price, lvl3Price)
        }
    }
    
    private func calculateBeverages(mens: Int, womans: Int, kids: Int, duration: Int, spendsMult: Int,  beverages: [Beverages], addExtra: Int){
        
        var multSpn = 1.0
        var multExt = 1.0
        
        if spendsMult == 0{
            multSpn = 0.85
        }else if spendsMult == 2{
            multSpn = 1.15
        }
        
        if addExtra == 0{
            multExt = 1.15
        }
        
        
        
        let mensBeveregeBeerQnt = Double(mens) * 1750 * multSpn * multExt
        let womanBeveregeBeerQnt = Double(womans) * 1500 * multSpn * multExt
        let kidsBeveregBeerQnt = Double(kids) * 0 * multSpn * multExt

        
        let mensBeveregeWaterQnt = Double(mens) * 500 * multSpn * multExt
        let womanBeveregeWaterQnt = Double(womans) * 500 * multSpn * multExt
        let kidsBeveregWaterQnt = Double(kids) * 500 * multSpn * multExt
        
        let mensBeveregeJuiceQnt = Double(mens) * 300 * multSpn * multExt
        let womanBeveregeJuiceQnt = Double(womans) * 250 * multSpn * multExt
        let kidsBeveregJuiceQnt = Double(kids) * 250 * multSpn * multExt
        
        let mensBeveregeSodaQnt = Double(mens) * 300 * multSpn * multExt
        let womanBeveregeSodaQnt = Double(womans) * 300 * multSpn * multExt
        let kidsBeveregSodaQnt = Double(kids) * 400 * multSpn * multExt
        
        let mensBeveregeDistillatesQnt = Double(mens) * 100 * multSpn * multExt
        let womanBeveregeDistillatesQnt = Double(womans) * 100 * multSpn * multExt
        let kidsBeveregDistillatesQnt = Double(kids) * 0 * multSpn * multExt
        
        
        let literFormatter = NumberFormatter()
        literFormatter.numberStyle = .decimal
        literFormatter.roundingMode = .up
        literFormatter.maximumFractionDigits = 0
        
        for beverege in beverages{
            if beverege.name == "Cerveja"{
                let totalBeerQnt = (Int(mensBeveregeBeerQnt) + Int(womanBeveregeBeerQnt) + Int(kidsBeveregBeerQnt))
                
                var totalBeerQntString = literFormatter.string(from: NSNumber(value: totalBeerQnt/1000))
                totalBeerQntString = totalBeerQntString?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                totalLiterQnt = totalLiterQnt + totalBeerQnt
                returnFullList.append(ListOpt(name: "Cerveja", image: #imageLiteral(resourceName: "beer"), mainValue: totalBeerQntString! + " litros", detailInfos: [("Lata(350ml)", String(totalBeerQnt/350)), ("Garrafa(2l)", String(totalBeerQnt/2000))], shouldPresendMoreInfo: true))
            }else if beverege.name == "Suco"{
                let totalJuiceQnt = Int(mensBeveregeJuiceQnt) + Int(womanBeveregeJuiceQnt) + Int(kidsBeveregJuiceQnt)
                
                var totalJuiceQntString = literFormatter.string(from: NSNumber(value: totalJuiceQnt/1000))
                totalJuiceQntString = totalJuiceQntString?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                
                totalLiterQnt = totalLiterQnt + totalJuiceQnt
                
                returnFullList.append(ListOpt(name: "Suco", image: #imageLiteral(resourceName: "orange-juice"), mainValue: totalJuiceQntString! + " litros", detailInfos: []))
            }else if beverege.name == "Água"{
                let totalWaterQnt = Int(mensBeveregeWaterQnt) + Int(womanBeveregeWaterQnt) + Int(kidsBeveregWaterQnt)
                
                var totalWaterQntString = literFormatter.string(from: NSNumber(value: totalWaterQnt/1000))
                totalWaterQntString = totalWaterQntString?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                totalLiterQnt = totalLiterQnt + totalWaterQnt
                returnFullList.append(ListOpt(name: "Àgua", image: #imageLiteral(resourceName: "plastic-bottle"), mainValue: totalWaterQntString! + " litros", detailInfos: []))
            }else if beverege.name == "Refrigerante"{
                let totalSodaQnt = Int(mensBeveregeSodaQnt) + Int(womanBeveregeSodaQnt) + Int(kidsBeveregSodaQnt)
                
                var totalSodaQntString = literFormatter.string(from: NSNumber(value: totalSodaQnt/1000))
                totalSodaQntString = totalSodaQntString?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                totalLiterQnt = totalLiterQnt + totalSodaQnt
                returnFullList.append(ListOpt(name: "Refrigerante", image: #imageLiteral(resourceName: "soda"), mainValue: totalSodaQntString! + " litros", detailInfos: [("Lata(350ml)", String(totalSodaQnt/350)), ("Garrafa(2l)", String(totalSodaQnt/2000))], shouldPresendMoreInfo: true))
            }else if beverege.name == "Destilado"{
                let totalDistillatesQnt = Int(mensBeveregeDistillatesQnt) + Int(womanBeveregeDistillatesQnt) + Int(kidsBeveregDistillatesQnt)
                
                var totalDistillatesQntString = literFormatter.string(from: NSNumber(value: totalDistillatesQnt/1000))
                totalDistillatesQntString = totalDistillatesQntString?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                
                returnFullList.append(ListOpt(name: "Destilado", image: #imageLiteral(resourceName: "vodka"), mainValue: totalDistillatesQntString! + " litros", detailInfos: []))
            }
        }
        
        
    }
    
    private func calculateOther(mens: Int, womans: Int, kids: Int, duration: Int, spendsMult: Int, others: [Others], addExtra: Int, meatWeight: Int, literQnt: Int){
        
        let qntFormatter = NumberFormatter()
        qntFormatter.numberStyle = .decimal
        qntFormatter.roundingMode = .up
        qntFormatter.maximumFractionDigits = 0
        
        for other in others{
            if other.name == "Carvão"{
                let totalCoalWeight = meatWeight
                
                returnFullList.append(ListOpt(name: "Carvão", image: #imageLiteral(resourceName: "charcoal"), mainValue: String(totalCoalWeight) + "Kg", detailInfos: []))
            }else if other.name == "Talheres"{
                let totalCutleryQnt = Double(mens + womans + kids) * 0.75
                
                var totalCutleryQntString = qntFormatter.string(from: NSNumber(value: totalCutleryQnt))
                totalCutleryQntString = totalCutleryQntString?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                
                returnFullList.append(ListOpt(name: "Talheres", image: #imageLiteral(resourceName: "food"), mainValue: totalCutleryQntString!, detailInfos: []))
            }else if other.name == "Pão"{
                let totalBreadQnt = Double(mens + womans) + (Double(kids) * 0.75)
                
                var totalBreadQntString = qntFormatter.string(from: NSNumber(value: totalBreadQnt))
                totalBreadQntString = totalBreadQntString?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                
                returnFullList.append(ListOpt(name: "Pão", image: #imageLiteral(resourceName: "bread"), mainValue: totalBreadQntString!, detailInfos: []))
            }else if other.name == "Copos"{
                let totalCupQnt = Double(mens + womans + kids) * 1.25
                
                var totalCupQntString = qntFormatter.string(from: NSNumber(value: totalCupQnt))
                totalCupQntString = totalCupQntString?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                
                returnFullList.append(ListOpt(name: "Copos", image: #imageLiteral(resourceName: "water-glass"), mainValue: totalCupQntString!, detailInfos: []))
            }else if other.name == "Pão de alho"{
                let totalGarlicBrQnt = Double(mens + womans + kids) * 0.75
                
                var totalGarlicBrQntString = qntFormatter.string(from: NSNumber(value: totalGarlicBrQnt))
                totalGarlicBrQntString = totalGarlicBrQntString?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                
                returnFullList.append(ListOpt(name: "Pão de alho", image: #imageLiteral(resourceName: "garlic"), mainValue: totalGarlicBrQntString!, detailInfos: []))
            }else if other.name == "Gelo"{
                let totalIceWeight = totalLiterQnt / 3
                
                var totalIceWeightString = qntFormatter.string(from: NSNumber(value: totalIceWeight / 1000))
                totalIceWeightString = totalIceWeightString?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                
                returnFullList.append(ListOpt(name: "Gelo", image: #imageLiteral(resourceName: "ice-cube"), mainValue: totalIceWeightString! + "Kg", detailInfos: []))
            }else if other.name == "Sal grosso"{
                let totalSaltWeight = (meatWeight / 8) + 1
                print("AQUI\(totalSaltWeight)")
                var totalSaltWeightString = qntFormatter.string(from: NSNumber(value: totalSaltWeight))
                totalSaltWeightString = totalSaltWeightString?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                
                returnFullList.append(ListOpt(name: "Sal grosso", image: #imageLiteral(resourceName: "salt"), mainValue: totalSaltWeightString! + "Kg", detailInfos: []))
            }else if other.name == "Vinagrete"{
                let totalVinaigretteWeight = Double(mens + womans + kids) * 100
                
                var totalVinaigretteWeightString = qntFormatter.string(from: NSNumber(value: totalVinaigretteWeight / 1000))
                totalVinaigretteWeightString = totalVinaigretteWeightString?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                
                returnFullList.append(ListOpt(name: "Vinagrete", image: #imageLiteral(resourceName: "tomato"), mainValue: totalVinaigretteWeightString! + "Kg", detailInfos: []))
            }else if other.name == "Queijo"{
                let totalCheeseWeight = Double(mens + womans + kids) * 100
                
                var totalCheeseWeightString = qntFormatter.string(from: NSNumber(value: totalCheeseWeight / 1000))
                totalCheeseWeightString = totalCheeseWeightString?.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
                
                returnFullList.append(ListOpt(name: "Queijo", image: #imageLiteral(resourceName: "cheese"), mainValue: totalCheeseWeightString! + "Kg", detailInfos: []))
            }
        }
    }
}


//MARK: - Ads

extension FullGetInfosViewController{
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
