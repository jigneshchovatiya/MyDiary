//
//  CommonClass.swift
//  iRepost
//
//  Created by jignesh on 19/06/20.
//  Copyright © 2020 IPost. All rights reserved.
//

import UIKit
import SystemConfiguration
import PINCache
import AVFoundation




class CommonClass: NSObject
{
    public struct AppFonts
    {
        public static let SFLight = "SFUIText-Light"
        public static let SFRegular = "SFUIText-Regular"
        public static let SFMedium = "SFUIText-Medium"
        public static let SFbold = "SFUIText-Bold"
    }
    
    class func appLightFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: CommonClass.AppFonts.SFLight, size: size)!
    }
    
    class func appRegularFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: CommonClass.AppFonts.SFRegular, size: size)!
    }
    
    class func appMediumFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: CommonClass.AppFonts.SFMedium, size: size)!
    }
    
    class func appSemiboldFont(withSize size: CGFloat) -> UIFont {
        return UIFont(name: CommonClass.AppFonts.SFbold, size: size)!
    }
    
    public struct AppColor
    {
        public static let appBlackColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        public static let appWhiteColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        public static let appTheamColor = UIColor(red: 68.0/255.0, green: 33.0/255.0, blue: 164.0/255.0, alpha: 1.0)
        public static let appGreyColor = UIColor(red: 116.0/255.0, green: 121.0/255.0, blue: 130.0/255.0, alpha: 1.0)
        public static let appGreyLigColor = UIColor(red: 192.0/255.0, green: 193.0/255.0, blue: 195.0/255.0, alpha: 1.0)
        public static let appLightGreyColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        public static let appExtraLightGreyColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        
        
    }
    
    struct AppConstantValues {
        static let constAppName = "MyDairyDB"
        static let constAppDBName = "MyDairyDB"
    }
    
    class func convertEpochDateToLocal(timeInterval: Double) -> Date
    {
        return Date(timeIntervalSince1970: TimeInterval(timeInterval))
    }
    
    class func currentepochTime() -> Double
    {
        let result = (Date().timeIntervalSince1970 * 1000)
        return result.rounded()
    }
    
    class func diffranceEpoch(epoch : Double) -> Double
    {
        let result = (Date().timeIntervalSince1970 * 1000)
        return result.rounded() - epoch.rounded()
    }
    
    class func safeAreaTopInsets() -> CGFloat
    {
        var bottom: CGFloat = 0
        if #available(iOS 11.0, *)
        {
            bottom = (UIApplication.shared.keyWindow?.safeAreaInsets.top)!
        }
        return bottom
    }

   
    class func safeAreaBottomInsets() -> CGFloat
    {
        var bottom: CGFloat = 0
        if #available(iOS 11.0, *)
        {
            bottom = (UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!
        }
        return bottom
    }
    
    class func IsiPhoneX() -> Bool
    {
        
        if UIDevice().userInterfaceIdiom == .phone {
            
            if UIScreen.main.bounds.height >= 812.0 || UIScreen.main.bounds.width >= 812 {
                return true
            }
        }
        return false
    }
    
    class func hexStringToUIColor (hex: String) -> UIColor
    {
        
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

func IBPrint(_ items: Any..., separator: String = " ", terminator: String = "\n")
{
    
    #if DEBUG
    var idx = items.startIndex
    let endIdx = items.endIndex
    
    repeat {
        //Swift.print(items[idx], separator: separator, terminator: idx == (endIdx - 1) ? terminator : separator)
        idx += 1
    } while idx < endIdx
    #endif
}

var pTouchAreaEdgeInsets: UIEdgeInsets = .zero

extension UIButton {
    
    var touchAreaEdgeInsets: UIEdgeInsets {
        
        get {
            if let value = objc_getAssociatedObject(self, &pTouchAreaEdgeInsets) as? NSValue {
                var edgeInsets: UIEdgeInsets = .zero
                value.getValue(&edgeInsets)
                return edgeInsets
            }
            else {
                return .zero
            }
        }
        set(newValue) {
            var newValueCopy = newValue
            let objCType = NSValue(uiEdgeInsets: .zero).objCType
            let value = NSValue(&newValueCopy, withObjCType: objCType)
            objc_setAssociatedObject(self, &pTouchAreaEdgeInsets, value, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        if UIEdgeInsetsEqualToEdgeInsets(self.touchAreaEdgeInsets, .zero) || !self.isEnabled || self.isHidden {
            return super.point(inside: point, with: event)
        }
        
        let relativeFrame = self.bounds
        let hitFrame = relativeFrame.inset(by: self.touchAreaEdgeInsets)
        
        return hitFrame.contains(point)
    }
}

extension Double {
    
    /// Rounds the double to decimal places value
    mutating func roundToPlaces(places: Int) -> Int64 {
        
        let divisor = pow(10.0, Double(places))
        return Int64(Darwin.round(self * divisor) / divisor)
    }
    
    func timeString() -> String {
        
        let remaining = floor(self)
        let hours = Int(remaining / 3600)
        let minutes = Int(remaining / 60) - hours * 60
        let seconds = Int(remaining) - hours * 3600 - minutes * 60
        
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 2
        
        let secondsString = String(format: "%02d", seconds)
        
        if hours > 0 {
            
            let hoursString = formatter.string(from: NSNumber(value: hours))
            if let hoursString = hoursString {
                let minutesString = String(format: "%02d", minutes)
                return "\(hoursString):\(minutesString):\(secondsString)"
            }
        }
        else {
            if let minutesString = formatter.string(from: NSNumber(value: minutes)) {
                return "\(minutesString):\(secondsString)"
            }
        }
        
        return ""
    }
}

extension CGRect {
    
    var center: CGPoint {
        get {
            return CGPoint(x: midX, y: midY)
        }
    }
}





