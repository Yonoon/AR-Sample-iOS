//
//  PlusMenuViewController.swift
//  ARFoodFinal
//
//  Created by 박용훈 on 23/09/2019.
//  Copyright © 2019 Koushan Korouei. All rights reserved.
//

import UIKit

protocol CollectionViewCellDelegte {
    func collectionViewCellDelegte(didClickButtonAt index: Int)
}

class PlusMenuViewController: UIViewController {
    @IBOutlet weak var plusView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    var vm: PlusMenuViewModel!
    var delegate: SelectObjDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setCornorRadius()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "FurnitureItemCell", bundle: Bundle.main), forCellWithReuseIdentifier: "FurnitureItemCell")

        vm.printVM()

    }
    
    func setCornorRadius() {
        plusView.layer.cornerRadius = 30
        plusView.layer.masksToBounds = true
    }

    @IBAction func popToARScene(_ sender: Any) {
        popVC()
    }

    func popVC() {
       self.dismiss(animated: true, completion: nil)
    }

}

extension PlusMenuViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return vm.categoryList.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let collectionViewHeader = (collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PlusMenuCollectionHeader", for: indexPath) as? PlusMenuCollectionHeader) else {
            print("CAN NO FIND COLLECTION VIEW HEADER")
            return UICollectionReusableView()
        }
        collectionViewHeader.headerTitle.text = vm.categoryList[indexPath.section]
        return collectionViewHeader
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.appliances.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FurnitureItemCell", for: indexPath) as? FurnitureItemCell else {
            print("CAN NOT FIND FURNITURE CELL")
            return UICollectionViewCell()
        }
        cell.delegte = self
        cell.index = indexPath.row
        cell.configure(vm.appliances[indexPath.row])
        //cell.collectionViewTest.label = collectionItems[indexPath.row]
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.setSelectedObj(vm.appliances[indexPath.row])
        popVC()
    }
    
    
}

extension PlusMenuViewController: CollectionViewCellDelegte{
    func collectionViewCellDelegte(didClickButtonAt index: Int) {
        print("button Pressed")
        let storyboard = UIStoryboard(name: "ViewDetail", bundle: nil)
        let ViewDetailsViewController = storyboard.instantiateViewController(withIdentifier: "ViewDetailsViewController") as? ViewDetailsViewController

        ViewDetailsViewController?.modalPresentationStyle = .overCurrentContext
        ViewDetailsViewController?.selectedItem = vm.appliances[index]
        if let ViewDetailsViewController = ViewDetailsViewController {

            self.present(ViewDetailsViewController, animated: true, completion: nil)
        }
        print("index\(index), item\(vm.appliances[index]) btn is pressed!!")
    }


}
