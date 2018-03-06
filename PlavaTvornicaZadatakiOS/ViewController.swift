//
//  ViewController.swift
//  PlavaTvornicaZadatakiOS
//
//  Created by Borut on 13/02/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

import UIKit
import GameplayKit

var USERS_NUMBER = ""
var USERS_GENDER = ""

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var btnSortOffRec: UIButton!
    @IBOutlet weak var btnSortAgeRef: UIButton!
    @IBOutlet weak var btnSortAbcRef: UIButton!
    @IBOutlet weak var sortMenu: NSLayoutConstraint!
    @IBOutlet weak var btnOpenViewForSort: UIButton!
    @IBOutlet weak var layoutSort: NSLayoutConstraint!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var collectionViewOfUsers: UICollectionView!
    @IBOutlet weak var btnGenderAny: UIButton!
    @IBOutlet weak var btnGenderFemale: UIButton!
    @IBOutlet weak var btnGenderMale: UIButton!
    @IBOutlet weak var txtFieldSearch: UITextField!
    lazy var listLayout: ListLayout = {
        var listLayout = ListLayout(itemHeight: 80)
        return listLayout
    }()
    var gridLayout: GridLayout!
    var sortMenuBar = false
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var listOfUsers = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.light)]
        collectionViewOfUsers.delegate = self
        collectionViewOfUsers.dataSource = self
        gridLayout = GridLayout(numberOfColumns: 2)
        collectionViewOfUsers.collectionViewLayout = gridLayout
        
        //search indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        // Shaping Buttons
        btnGenderAny.layer.cornerRadius = btnGenderAny.frame.size.width/7
        btnGenderAny.clipsToBounds = true
        btnGenderFemale.layer.cornerRadius = btnGenderFemale.frame.size.width/7
        btnGenderFemale.clipsToBounds = true
        btnGenderMale.layer.cornerRadius = btnGenderMale.frame.size.width/7
        btnGenderMale.clipsToBounds = true
        btnSearch.roundCorners(corners: [.topRight, .bottomRight], radius: 20)
        sortMenu.constant = 80
        let blueColor = hexStringToUIColor(hex: "#007AFF")
        let grayColor = hexStringToUIColor(hex: "#f1f1f2")
        btnGenderAny.backgroundColor = blueColor
        btnGenderMale.backgroundColor = grayColor
        btnGenderFemale.backgroundColor = grayColor
        btnSearch.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        btnGenderAny.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        btnGenderFemale.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        btnGenderMale.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        
        //customize textField for searching
        txtFieldSearch.layer.cornerRadius = btnGenderAny.frame.size.width/6
        txtFieldSearch.clipsToBounds = true
        txtFieldSearch.backgroundColor = grayColor
        let envelopeView = UIImageView(frame: CGRect(x: 5, y: 3, width: 14, height: 14))
        let image = UIImage(named: "Search")
        envelopeView.image = image
        let viewLeft: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        viewLeft.addSubview(envelopeView)
        txtFieldSearch.leftView = viewLeft
        txtFieldSearch.leftViewMode = UITextFieldViewMode.always
        
        self.hideKeyboardWhenTappedAround()
        //registering nib file
        self.collectionViewOfUsers.register(UINib(nibName:"ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCell")
    }
    
    //customize collectionView
    //////////////////////////
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfUsers.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.collectionViewLayout == gridLayout {
            if let cell = collectionViewOfUsers.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath as IndexPath) as? UserCollectionCellGrid {
                let users = listOfUsers[indexPath.row]
                cell.configureCell(randomUsers: users)
                return cell
            }
        }else if collectionView.collectionViewLayout == listLayout {
            if let cell = collectionViewOfUsers.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath as IndexPath) as? ListCollectionViewCell {
                let users = listOfUsers[indexPath.row]
                cell.configureCell(randomUsers: users)
                return cell
            }
        }
        return ListCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.collectionViewLayout == listLayout {
            if let cell = collectionView.cellForItem(at: indexPath) {
                performSegue(withIdentifier: "listSegue", sender: cell)
            }
        }
    }
    //////////////////////////////
    
    // switch between grid and list
    @IBAction func btnGridLayout(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.collectionViewOfUsers.collectionViewLayout.invalidateLayout()
            self.collectionViewOfUsers.setCollectionViewLayout(self.gridLayout, animated: false)
            self.collectionViewOfUsers.reloadData()
        })
        
    }
    @IBAction func btnListLayout(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.collectionViewOfUsers.collectionViewLayout.invalidateLayout()
            self.collectionViewOfUsers.setCollectionViewLayout(self.listLayout, animated: false)
            self.collectionViewOfUsers.reloadData()
        })
        
    }
    
    // button for number of users
    @IBAction func btnSearch(_ sender: Any) {
        activityIndicator.startAnimating()
        USERS_NUMBER = txtFieldSearch.text!
        dowloadDataForCollectionView()
        USERS_NUMBER = ""
        txtFieldSearch.text = ""
    }
    
    // options in sorting menu
    @IBAction func btnSortAbc(_ sender: Any) {
        btnSortAbcRef.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.regular)
        btnSortAgeRef.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        btnSortOffRec.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        listOfUsers.sort(by: {$0.name.first < $1.name.first})
        collectionViewOfUsers.reloadData()
    }
    
    @IBAction func sortByAge(_ sender: Any) {
        btnSortAbcRef.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        btnSortAgeRef.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.regular)
        btnSortOffRec.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        listOfUsers.sort(by: {$0.dob < $1.dob})
        collectionViewOfUsers.reloadData()
    }
    @IBAction func sortOff(_ sender: Any) {
        btnSortAbcRef.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        btnSortAgeRef.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        btnSortOffRec.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.regular)
        listOfUsers.shuffle()
        collectionViewOfUsers.reloadData()
    }
    
    
    // buttons for picking genders
    @IBAction func btnPickGender(_ sender: UIButton){
        let blueColor = hexStringToUIColor(hex: "#007AFF")
        let grayColor = hexStringToUIColor(hex: "#f1f1f2")
        let darkGray = hexStringToUIColor(hex: "363636")
        if sender.tag == 1 {
            USERS_GENDER = "any"
            btnGenderAny.backgroundColor = blueColor
            btnGenderMale.backgroundColor = grayColor
            btnGenderFemale.backgroundColor = grayColor
            btnGenderAny.setTitleColor(.white, for: .normal)
            btnGenderMale.setTitleColor(darkGray, for: .normal)
            btnGenderFemale.setTitleColor(darkGray, for: .normal)
            btnGenderFemale.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
            btnGenderMale.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        } else if sender.tag == 2 {
            USERS_GENDER = "female"
            btnGenderAny.backgroundColor = grayColor
            btnGenderMale.backgroundColor = grayColor
            btnGenderFemale.backgroundColor = blueColor
            btnGenderFemale.setTitleColor(.white, for: .normal)
            btnGenderAny.setTitleColor(darkGray, for: .normal)
            btnGenderMale.setTitleColor(darkGray, for: .normal)
            btnGenderAny.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
            btnGenderMale.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        } else if sender.tag == 3 {
            USERS_GENDER = "male"
            btnGenderAny.backgroundColor = grayColor
            btnGenderMale.backgroundColor = blueColor
            btnGenderFemale.backgroundColor = grayColor
            btnGenderMale.setTitleColor(.white, for: .normal)
            btnGenderAny.setTitleColor(darkGray, for: .normal)
            btnGenderFemale.setTitleColor(darkGray, for: .normal)
            btnGenderAny.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
            btnGenderMale.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        }
        
    }
    // dowloading data for collectionView
    func dowloadDataForCollectionView() {
        let jsonURL = "https://randomuser.me/api/?results=\(USERS_NUMBER)&gender=\(USERS_GENDER)"
        let url = URL(string:jsonURL)
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let usersDowload = try decoder.decode(Results.self, from: data)
                for myData in usersDowload.results {
                    self.listOfUsers.append(myData)
                }
                DispatchQueue.main.async {
                    self.collectionViewOfUsers.reloadData()
                    self.activityIndicator.stopAnimating()
                }
                
            } catch  {
                print(" there is some error: \(error)" )
            }
            
            }.resume()
    }
    
    // button for opening menu with sort options
    @IBAction func btnShowSort(_ sender: Any) {
        if(sortMenuBar) {
            sortMenu.constant = 80
            btnOpenViewForSort.setTitle("Sort", for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }else {
            btnOpenViewForSort.setTitle("Ok", for: .normal)
            sortMenu.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
        sortMenuBar = !sortMenuBar
    }
    
    // open DetailVC and send data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigaton =  segue.destination as! DetailVC
        if segue.identifier == "gridSegue" {
            if let indexPath = self.collectionViewOfUsers.indexPath(for: sender as! UserCollectionCellGrid ) {
                let selectedRow = listOfUsers[indexPath.row]
                navigaton.currentUser = selectedRow
            }
        }
        if segue.identifier == "listSegue"  {
            if let indexPath = self.collectionViewOfUsers.indexPath(for: sender as! ListCollectionViewCell ) {
                let selectedRow = listOfUsers[indexPath.row]
                navigaton.currentUser = selectedRow
            }
        }
        let backImage = UIImage(named: "back_icon")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
}




