//
//  ViewController.swift
//  ZynaxAssignment
//
//  Created by user on 17/11/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var shippingBtnLbl: CustomButton!
    @IBOutlet weak var deliveryCostBtnLbl: UIButton!
    @IBOutlet weak var tableViewHeiCons: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var previousPriceLbl: UILabel!
    @IBOutlet weak var percentLbl: UILabel!
    @IBOutlet weak var badgeLbl: UILabel!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageHeiCons: NSLayoutConstraint!
    
    var overlayView = OverlayView()
    
    var screenWidth : CGFloat = 0
    var navigationBar = NavigationBar()
    var listArr = ["Specifications","Reviews","How to Order","FAQ","Wholesale Inquiry","Descriptions"]
//    override var prefersStatusBarHidden: Bool {
//            return true
//        }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        scrollView.delegate = self
        setupNavigationBar()
        NibRegister()
        setUpView()
        
    }
    
    private func setUpView(){
        let screenSize: CGRect = UIScreen.main.bounds
        screenWidth = screenSize.width
        imageHeiCons.constant = screenWidth
        print(screenWidth)
        badgeLbl.layer.cornerRadius = 7
        badgeLbl.layer.masksToBounds = true
        percentLbl.layer.cornerRadius = 10.5
        percentLbl.layer.masksToBounds = true
        
        let price = 3050
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = "BDT"
        let priceInBDT = currencyFormatter.string(from: price as NSNumber)
        
        let attributedString = NSMutableAttributedString(string: priceInBDT!)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
        previousPriceLbl.attributedText = attributedString
        
//        deliveryCostBtnLbl.semanticContentAttribute = UIApplication.shared
//            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
    }
    
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        //backButton.tintColor = .black
        
        let searchButton = UIButton(type: .system)
        searchButton.setImage(UIImage(named: "menu"), for: .normal)
        //searchButton.tintColor = .black
        
        let menuButton = UIButton(type: .system)
        menuButton.setImage(UIImage(named: "search"), for: .normal)
        //menuButton.tintColor = .black
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: searchButton), UIBarButtonItem(customView: menuButton)]
        //navigationItem.rightBarButtonItem = UIBarButtonItem(customView: NavigationBar)
    }
    private func NibRegister(){
        let collectionViewNIB = UINib(nibName: "ColorCollectionViewCell", bundle: nil)
        colorCollectionView.register(collectionViewNIB, forCellWithReuseIdentifier: "ColorCollectionViewCell")
        
        let tableViewNIB = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(tableViewNIB, forCellReuseIdentifier: "TableViewCell")
        self.tableView.tableFooterView = UIView()
        
        tableViewHeiCons.constant = CGFloat.greatestFiniteMagnitude
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableViewHeiCons.constant = tableView.contentSize.height
    }
    @objc func showOverlayVeiw() {
        let slideVC = OverlayView()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        self.present(slideVC, animated: true, completion: nil)
    }
    
    @IBAction func shipping(_ sender: UIButton) {
        overlayView.configureShipping(button: shippingBtnLbl)
        overlayView.shippingDropDown.show()
    }
    
}
// MARK: CollectionView Delegate Datasource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        //let size = collectionView.frame.size
//        return CGSize(width: 61.0, height: 61.0)
//    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colorCollectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showOverlayVeiw()
    }
}
extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.iconLbl.image = UIImage(named: listArr[indexPath.row])
        cell.textLbl.text = listArr[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

// MARK: sroll to show avigation Bar
extension ViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(scrollView.contentOffset.y)
        
        var offset = scrollView.contentOffset.y / (screenWidth - 88)
        if offset > 1{
            offset = 1
            let color = UIColor(red: 250, green: 250, blue: 250, alpha: offset)
            self.navigationController?.navigationBar.tintColor = UIColor(hue: 0, saturation: offset, brightness: 0, alpha: 1)
           self.navigationController?.navigationBar.backgroundColor = color
//            navigationBar.backgroundColor = color

            if #available(iOS 13, *)
            {
                
                let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
                statusBar.backgroundColor = color
                UIApplication.shared.keyWindow?.addSubview(statusBar)
            } else {
                // ADD THE STATUS BAR AND SET A CUSTOM COLOR
                let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
                if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                    statusBar.backgroundColor = color
                }
                UIApplication.shared.statusBarStyle = .lightContent
            }

        }else{
            let color = UIColor(red: 250, green: 250, blue: 250, alpha: offset)
            self.navigationController?.navigationBar.tintColor = UIColor(hue: 0, saturation: offset, brightness: 100, alpha: 1)
            self.navigationController?.navigationBar.backgroundColor = color
            if #available(iOS 13, *)
            {
                let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
                statusBar.backgroundColor = UIColor(red: 250, green: 250, blue: 250, alpha: offset)
                UIApplication.shared.keyWindow?.addSubview(statusBar)
            } else {
                // ADD THE STATUS BAR AND SET A CUSTOM COLOR
                let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
                if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                    statusBar.backgroundColor = UIColor(red: 250, green: 250, blue: 250, alpha: offset)

                }
                UIApplication.shared.statusBarStyle = .lightContent
            }
        }
    }
}

////
extension ViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}

