//
//  Extension.swift
//  Test
//
//  Created by Deepak on 29/06/23.
//

import Foundation
import UIKit

extension NSMutableAttributedString {

    func setFontForText(textForAttribute: String, withColor color: UIColor, withFont customFont: UIFont) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.addAttribute(NSAttributedString.Key.font, value: customFont, range: range)
    }
    
    //MARK: Method for create one attributed string using product title and product description

    class func setAttributedTextwithSubTitle(_ title:String, withSubTitle text:String, withTextFont font:UIFont, withSubTextFont textFont:UIFont, withTextColor color:UIColor, withSubTextColor textColor:UIColor ,withTextAlignment textAlignmentType:NSTextAlignment) -> NSMutableAttributedString
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignmentType
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let attributed = NSMutableAttributedString(string: String(title))
        attributed.append(NSAttributedString(string: "   "))
        attributed.append(NSAttributedString(string: text))

        let text_range = NSMakeRange(0, String(attributed.string).unicodeScalars.count)
        attributed.setFontForText(textForAttribute: title, withColor: color, withFont: font)
        attributed.setFontForText(textForAttribute: text, withColor: textColor, withFont: textFont)
        attributed.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: text_range)
        return attributed
    }
    
    class func setAttributedText(_ title:String, withTextFont font:UIFont, withTextColor color:UIColor,withTextAlignment textAlignmentType:NSTextAlignment) -> NSMutableAttributedString
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignmentType
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        let attributed = NSMutableAttributedString(string: String(title))

        let text_range = NSMakeRange(0, String(attributed.string).unicodeScalars.count)
        attributed.setFontForText(textForAttribute: title, withColor: color, withFont: font)
        attributed.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: text_range)
        return attributed
    }
}

extension UIViewController {
    
    //MARK: Method for display alert
    
    func showAlert(title:String , message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        if !(self.navigationController?.visibleViewController?.isKind(of: UIAlertController.self))! {
            present(alertController, animated: true, completion: nil)
        }
    }
}
