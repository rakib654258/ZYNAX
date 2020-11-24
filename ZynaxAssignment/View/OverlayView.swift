//
//  OverlayView.swift
//  SlideOverTutorial
//
//  Created by Aivars Meijers on 09/09/2020.
//

import UIKit
import DropDown

class OverlayView: UIViewController {
    
    @IBOutlet weak var shippingBtnLbl: UIButton!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    
    @IBOutlet weak var rightSliderBtnLbl: CustomButton!
    @IBOutlet weak var leftSliderBtnLbl: CustomButton!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    let shippingDropDown = DropDown()
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    var counter = 0
    var quantity = 1
    var sizeArr = ["S","M","L","XL","XXL"]
    var imageArr = ["Image3","image4","Image3","image5","Image3"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        registerNIB()
        if counter == 0{
            leftSliderBtnLbl.isHidden = true
        }
    }
    private func registerNIB(){
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        let sliderCollectionViewNIB = UINib(nibName: "SliderCollectionCell", bundle: nil)
        sliderCollectionView.register(sliderCollectionViewNIB, forCellWithReuseIdentifier: "SliderCollectionCell")
        
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        let colorCollectionViewNIB = UINib(nibName: "ColorCollectionViewCell", bundle: nil)
        colorCollectionView.register(colorCollectionViewNIB, forCellWithReuseIdentifier: "ColorCollectionViewCell")
        sizeCollectionView.delegate = self
        sizeCollectionView.dataSource = self
        let sizeCollectionViewNIB = UINib(nibName: "SizeColletionCell", bundle: nil)
        sizeCollectionView.register(sizeCollectionViewNIB, forCellWithReuseIdentifier: "SizeColletionCell")
    }
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
    @IBAction func closeOverlayView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeImage(_ sender: UIButton) {
        if sender.tag == 1{
            rightSliderBtnLbl.isHidden = false
            if counter > 0 {
                counter -= 1
                let index = IndexPath.init(item: counter, section: 0)
                self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                if counter == 0{
                    leftSliderBtnLbl.isHidden = true
                }
            }
        }
        else if sender.tag == 2{
            leftSliderBtnLbl.isHidden = false
            if counter < imageArr.count{
                counter += 1
                let index = IndexPath.init(item: counter, section: 0)
                self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                if counter == imageArr.count - 1 {
                    rightSliderBtnLbl.isHidden = true
                }
            }
        }
    }
    
    @IBAction func quantityBtn(_ sender: UIButton) {
        if sender.tag == 1{
            if quantity > 1{
                quantity -= 1
                quantityLbl.text = "\(quantity)"
            }
        }
        else if sender.tag == 2{
            quantity += 1
            quantityLbl.text = "\(quantity)"
        }
    }
    func configureShipping(button: UIButton){
        shippingDropDown.anchorView = shippingBtnLbl
        shippingDropDown.dataSource = ["zDrop Premium Shipping    Cost: BDT. 4000", "DHL    Cost: BDT. 3200", "Fredex    Cost: BDT. 3650"]
        shippingDropDown.width = button.layer.frame.width
        shippingDropDown.bottomOffset = CGPoint(x: 0, y: 0)//CGPoint(x: 16, y:48)
        
        shippingDropDown.backgroundColor = .white
        shippingDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            button.setTitle(item, for: .normal)
        }
    }
    @IBAction func shipping(_ sender: UIButton) {
        configureShipping(button: shippingBtnLbl)
        shippingDropDown.show()
    }
}

extension OverlayView: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfRows = 0
        switch collectionView {
        case sliderCollectionView:
            numberOfRows = imageArr.count
        case colorCollectionView:
            numberOfRows = imageArr.count
        case sizeCollectionView:
            numberOfRows = sizeArr.count
        default:
            print("Something wrong!!")
        }
        return numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        switch collectionView {
        case sliderCollectionView:
            let sliderCell = sliderCollectionView.dequeueReusableCell(withReuseIdentifier: "SliderCollectionCell", for: indexPath) as! SliderCollectionCell
            sliderCell.imageLbl.image = UIImage(named: imageArr[indexPath.row])
            cell = sliderCell
        case colorCollectionView:
            let colorCell = colorCollectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
            colorCell.imageLbl.image = UIImage(named: imageArr[indexPath.row])
            cell = colorCell
        case sizeCollectionView:
            let sizeCell = sizeCollectionView.dequeueReusableCell(withReuseIdentifier: "SizeColletionCell", for: indexPath) as! SizeColletionCell
            sizeCell.sizeLbl.text = sizeArr[indexPath.row]
            cell = sizeCell
        default:
            print("Something wrong!!")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //addToList.append(objectsArray[indexPath.row])
        switch collectionView {
        case colorCollectionView:
            let cell = colorCollectionView.cellForItem(at: indexPath)
            cell?.layer.borderWidth = 2.0
            cell?.layer.borderColor = UIColor.systemGreen.cgColor
            
            let index = IndexPath.init(item: indexPath.row, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            self.counter = index.row
            
        case sizeCollectionView:
            let cell = sizeCollectionView.cellForItem(at: indexPath)
            cell?.layer.borderWidth = 2.0
            cell?.layer.borderColor = UIColor.systemGreen.cgColor
        default:
            print("Something wrong!!")
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView {
        case colorCollectionView:
            let cell = colorCollectionView.cellForItem(at: indexPath)
            cell?.layer.borderWidth = 0.0
        //cell?.layer.borderColor = UIColor.green.cgColor
        case sizeCollectionView:
            let cell = sizeCollectionView.cellForItem(at: indexPath)
            cell?.layer.borderWidth = 0.0
        //cell?.layer.borderColor = UIColor.green.cgColor
        default:
            print("Something wrong!!")
        }
    }
    
}
