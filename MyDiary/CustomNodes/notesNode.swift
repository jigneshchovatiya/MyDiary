//
//  notesNode.swift
//  MyDiary
//
//  Created by Apple on 02/11/20.
//

import UIKit
import AsyncDisplayKit
import RealmSwift
import SVProgressHUD

let constantLeftInset: CGFloat = 10.0
let constantRightInset: CGFloat = 3.0
var constantTopInset: CGFloat = 2.0
let constantBottomInset: CGFloat = 3.0


class notesNode: ASCellNode
{
    var displayNode = ASDisplayNode()
    var timeLabel = ASTextNode()
    var titleLable = ASTextNode()
    var desclable = ASTextNode()
    var editButton = ASButtonNode()
    var closebutton = ASButtonNode()
    var arrowImage = ASImageNode()
    var watchIcon = ASImageNode()
    var headerTimeLable = ASTextNode()
    var isHederRequired = true
    var rootController : ViewController?
    var mainObject : objNotes?
    
    init(rootViewController : ViewController ,notesObject: objNotes, previousObj: objNotes? = nil, indexPathRow: IndexPath, token: NotificationToken?)
    {
        super.init()
        
        rootController = rootViewController
        mainObject = notesObject
        self.backgroundColor = CommonClass.AppColor.appWhiteColor
        self.titleLable.attributedText = notesObject.title.generateAttributedString(withFont: CommonClass.AppFonts.SFMedium, withSize: 15.0, withColor: CommonClass.AppColor.appBlackColor)
        self.desclable.attributedText = notesObject.desc.generateAttributedString(withFont: CommonClass.AppFonts.SFMedium, withSize: 14.0, withColor: CommonClass.AppColor.appGreyColor)
        self.editButton.setAttributedTitle("EDIT".generateAttributedString(withAlignment: .right,withFont: CommonClass.AppFonts.SFMedium, withSize: 14.0, withColor: CommonClass.AppColor.appTheamColor), for: .normal)
        self.editButton.addTarget(self, action: #selector(clickOnEditButton), forControlEvents: .touchUpInside)
        let date = CommonClass.convertEpochDateToLocal(timeInterval: notesObject.updatedat)
        self.timeLabel.attributedText = date.toStringWithRelativeTime().generateAttributedString(withFont: CommonClass.AppFonts.SFMedium, withSize: 12.0, withColor: CommonClass.AppColor.appGreyLigColor)
        
        self.arrowImage.image = UIImage.init(named: "seprator_icon")
        self.watchIcon.image = UIImage.init(named: "iconTimer")
        displayNode.backgroundColor = CommonClass.AppColor.appWhiteColor
        self.headerTimeLable.attributedText = date.toStringWithRelativeTimeHeadLines().generateAttributedString(withFont: CommonClass.AppFonts.SFMedium, withSize: 12.0, withColor: CommonClass.AppColor.appGreyColor)
        
        if previousObj != nil
        {
            let date1 = CommonClass.convertEpochDateToLocal(timeInterval: previousObj!.updatedat)
            if date.compare(.isSameDay(as: date1))
            {
                isHederRequired = false
            }
        }
        
        self.closebutton.setImage(UIImage.init(named: "deleteBtn"), for: .normal)
        self.closebutton.addTarget(self, action: #selector(clickOnClose), forControlEvents: .touchUpInside)
        self.closebutton.backgroundColor = CommonClass.AppColor.appExtraLightGreyColor
        self.automaticallyManagesSubnodes = true
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec
    {
        watchIcon.styled { (style) in
            style.width = ASDimensionMake(15)
            style.height = ASDimensionMake(15)
        }
        
        closebutton.styled { (style) in
            style.width = ASDimensionMake(20)
            style.height = ASDimensionMake(20)
        }
        
        editButton.styled { (style) in
            style.width = ASDimensionMake(50)
        }
        
        titleLable.styled { (style) in
            style.flexShrink = 1
            style.width = ASDimensionMake(UIScreen.main.bounds.size.width - 60 - 50)
        }
        
        displayNode.styled { (style) in
            style.width = ASDimensionMake(UIScreen.main.bounds.size.width - 40.0)
        }
        
        editButton.styled { (style) in
            style.alignSelf = .start
        }
        
        let horizontalStack1 = ASStackLayoutSpec.init(direction: .horizontal, spacing: 10.0, justifyContent: .start, alignItems: .center, children: [watchIcon,headerTimeLable,ASLayoutSpec().styled({(_ style: ASLayoutElementStyle) -> Void in
            style.flexGrow = 1.0
            style.flexShrink = 1.0
        })])
        let horizontalStack2 = ASStackLayoutSpec.init(direction: .horizontal, spacing: 10.0, justifyContent: .spaceBetween, alignItems: .stretch, children: [titleLable,editButton])
        
        let verticalStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 10.0, justifyContent: .start, alignItems: .start, children: [horizontalStack2,desclable,timeLabel])
        
        let asbackgroundNode = ASBackgroundLayoutSpec.init(child: ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 20, left: 10, bottom: 10, right: 10), child: verticalStack), background: displayNode)
        
        let newDisplayNode = ASDisplayNode.init()
        newDisplayNode.backgroundColor = CommonClass.AppColor.appWhiteColor
        let asbackgroundNode1 = ASBackgroundLayoutSpec.init(child: ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0), child: asbackgroundNode), background: newDisplayNode)
        
        let overlayout = ASOverlayLayoutSpec.init(child: asbackgroundNode1, overlay: ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 3, left:10 , bottom: CGFloat.infinity, right: CGFloat.infinity), child: arrowImage))
        let overlayout1 = ASOverlayLayoutSpec.init(child: overlayout, overlay: ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 10, left:CGFloat.infinity , bottom: CGFloat.infinity, right: -10), child: closebutton))
        
        if isHederRequired == true
        {
            let finalVerticalStack = ASStackLayoutSpec.init(direction: .vertical, spacing: 2.0, justifyContent: .start, alignItems: .start, children: [ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 10, left: 7, bottom: 2, right: 20), child:horizontalStack1),overlayout1])
            return  ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 1, left: 20, bottom: 1, right: 20), child: finalVerticalStack)
        }
        else
        {
            return  ASInsetLayoutSpec.init(insets: UIEdgeInsets.init(top: 1, left: 20, bottom: 1, right: 20), child: overlayout1)
        }
        
        
    }
    
    @objc func clickOnEditButton()
    {
        let editVC = self.rootController!.storyboard?.instantiateViewController(withIdentifier: "EditVC") as! EditVC
        editVC.rootVC = self.rootController!
        editVC.objectNotes = self.mainObject!
        self.rootController!.navigationController?.pushViewController(editVC, animated: true)
    }
    
    override func layout()
    {
        super.layout()
        self.closebutton.layer.cornerRadius = 10.0
        self.displayNode.view.layer.cornerRadius = 5.0
        self.displayNode.clipsToBounds = true
        self.displayNode.view.dropShadow(color: UIColor.black.withAlphaComponent(0.08), opacity: 1, offSet: CGSize(width: -2, height: 2), radius: 5.0, scale: true)
        
    }
    
    @objc func clickOnClose()
    {
        let alertController = UIAlertController(title: "Delete Notes!", message: "Are you sure you want to delete this notes?", preferredStyle: .alert)

        let actionOk = UIAlertAction(title: "Delete", style: .destructive, handler: { [self](_ action: UIAlertAction) -> Void in
            alertController.dismiss(animated: true, completion: nil)
            if let deleteObject = self.rootController?.mainRealm.fetchObjects(type: objNotes.self, predicate: NSPredicate.init(format: "notesID = '\(mainObject!.notesID)'"), order: nil)?.first
            {
                self.rootController?.mainRealm.updateObject
                {
                    self.rootController?.mainRealm.delete(deleteObject)
                }
                DispatchQueue.main.async {
                    SVProgressHUD.showSuccess(withStatus: "Notes Deleted successfully!")
                }
            }
        })
        let actionNo = UIAlertAction(title: "No", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(actionOk)
        alertController.addAction(actionNo)
        DispatchQueue.main.async(execute: {() -> Void in
            self.rootController!.present(alertController, animated: true, completion: nil)
        })
        
        
        
    }
}

public extension String {
    
    
    func generateAttributedString(withAlignment align: NSTextAlignment? = NSTextAlignment.left, withFont font: String, withSize size: CGFloat, withColor color: UIColor, withBaselineOffset offset: Double? = 0.0, withLineSpacing space: CGFloat? = 0.0) -> NSAttributedString {
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = align!
        
        if space != 0.0 {
            paragraph.lineSpacing = space!
        }
        
        //Check for - NSBaselineOffsetAttributeName once
        let attr = [
            convertFromNSAttributedStringKey(NSAttributedString.Key.baselineOffset): offset!,
            convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): color,
            convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont(name: font, size: size)!,
            convertFromNSAttributedStringKey(NSAttributedString.Key.paragraphStyle): paragraph
        ] as [String : Any]
        
        return NSAttributedString(string: self, attributes: convertToOptionalNSAttributedStringKeyDictionary(attr))
    }
    
    func trimString() -> String {
        var trimmedStr: String = ""
        let str_Trimmed: String = (self as NSString).replacingCharacters(in: (self as NSString).range(of:"^\\s*", options: .regularExpression), with: "")
        if str_Trimmed.count > 0 {
            trimmedStr = (str_Trimmed as NSString).replacingCharacters(in: (str_Trimmed as NSString).range(of:"\\s*$", options: .regularExpression), with: "")
        }
        return trimmedStr
    }
    var length: Int {
        return (self as NSString).length
    }
}

fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    
    return input.rawValue
}

fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    
    guard let input = input else {
        return nil
    }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

extension UIView {

  // OUTPUT 1
  func dropShadow(scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.5
    layer.shadowOffset = CGSize(width: -1, height: 1)
    layer.shadowRadius = 1

    layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }

  // OUTPUT 2
  func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius

    layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}

