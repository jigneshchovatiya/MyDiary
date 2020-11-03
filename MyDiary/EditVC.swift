//
//  EditVC.swift
//  MyDiary
//
//  Created by Apple on 03/11/20.
//

import UIKit
import SVProgressHUD

class EditVC: UIViewController {

    
    var objectNotes : objNotes?
    var rootVC : ViewController?
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var lblDescri: UILabel!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var descrHeight: NSLayoutConstraint!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.title = "\(objectNotes!.title)"
        
        
        let btnClose = UIButton(type: .custom)
        btnClose.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(30), height: CGFloat(30))
        btnClose.contentVerticalAlignment = .center
        btnClose.tintColor = UIColor.black
        btnClose.setImage(UIImage.init(named: "backBtn"), for: .normal)
        btnClose.addTarget(self, action: #selector(clickOnLeftBarButton), for: .touchUpInside)
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -5
        let barButtonItem = UIBarButtonItem(customView: btnClose)
        navigationItem.setLeftBarButtonItems([negativeSpacer, barButtonItem], animated: false)
        
        btnSave.layer.cornerRadius = 5.0
        btnSave.clipsToBounds = true
        btnSave.backgroundColor = CommonClass.AppColor.appTheamColor
        btnSave.setAttributedTitle("SAVE".generateAttributedString(withAlignment: .right,withFont: CommonClass.AppFonts.SFMedium, withSize: 14.0, withColor: CommonClass.AppColor.appWhiteColor), for: .normal)
        
        setAllLable()
        
        // Do any additional setup after loading the view.
    }
    
    @objc func clickOnLeftBarButton()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setAllLable()
    {
        self.lblTitle.text = "Diary Title"
        self.lblTitle.font = CommonClass.appRegularFont(withSize: 12.0)
        self.lblTitle.textColor = CommonClass.AppColor.appGreyColor
        self.lblDescri.text = "Diary Content"
        self.lblDescri.font = CommonClass.appRegularFont(withSize: 12.0)
        self.lblDescri.textColor = CommonClass.AppColor.appGreyColor
        
        self.txtTitle.text = "\(objectNotes!.title)"
        self.txtTitle.font = CommonClass.appRegularFont(withSize: 15.0)
        self.txtTitle.textColor = CommonClass.AppColor.appBlackColor
        self.txtDescription.text = "\(objectNotes!.desc)"
        self.txtDescription.font = CommonClass.appRegularFont(withSize: 15.0)
        self.txtDescription.textColor = CommonClass.AppColor.appBlackColor
        
        setContentHeight()
    }
    
    private func setContentHeight()
    {
        txtTitle.sizeToFit()
        let newSize = txtDescription.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width - 48 , height: CGFloat.greatestFiniteMagnitude))
        descrHeight.constant = newSize.height
    }
    
    @IBAction func saveButtonTapped(sender: UIButton)
    {
        self.view.endEditing(true)
        if (self.txtTitle.text?.trimString().isEmpty)!
        {
            SVProgressHUD.showError(withStatus: "Please Enter title")
        }
        
        else if (self.txtDescription.text?.trimString().isEmpty)!{
            SVProgressHUD.showError(withStatus: "Please Enter description")
        }
        else
        {
            if let updateObject = self.rootVC?.mainRealm.fetchObjects(type: objNotes.self, predicate: NSPredicate.init(format: "notesID = '\(objectNotes!.notesID)'"), order: nil)?.first
            {
                self.rootVC!.mainRealm.updateObject
                {
                    updateObject.title = self.txtTitle.text!
                    updateObject.desc = self.txtDescription.text!
                }
                
                DispatchQueue.main.async
                {
                    SVProgressHUD.showSuccess(withStatus: "Notes Updated successfully!")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EditVC : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView)
    {
        setContentHeight()
    }
}
