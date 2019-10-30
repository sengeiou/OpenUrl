//
//  SendMessageView.swift
//  cameraman
//
//  Created by haozhiyu on 2019/4/7.
//  Copyright © 2019 haozhiyu. All rights reserved.
//

import UIKit

class SendMessageView: UIView {
    var contentInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) {
        didSet {
            upDateContent()
        }
    }
    var lineFragmentPadding: CGFloat! {
        didSet {
            upDateContent()
        }
    }
    var editorColor: UIColor! {
        didSet {
            upDateContent()
        }
    }
    var font: UIFont! {
        didSet {
            upDateContent()
        }
    }
    var textColor: UIColor! {
        didSet {
            upDateContent()
        }
    }
    var showNumberOfLines: Int = 5
    var placeholder: String? {
        didSet {
            upDateContent()
        }
    }
    
    private var contentView: UIView!
    private var textView: UITextView!
    private var placeholderLabel: UILabel!
    private var cacheText: String = ""
    private var sendClick: ((String)->())!
    
    init(_ iFrame: CGRect) {
        super.init(frame: iFrame)
        if UIDevice.current.isX() {
            frame.size.height += 34
        } 
        
        backgroundColor = UIColor.white
        contentView = UIView()
        contentView.backgroundColor = RGB(234, 234, 234)
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
        addSubview(contentView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        contentView.addGestureRecognizer(tap)
        
        if UIDevice.current.isX() {
            contentView.frame = CGRect(x: contentInset.left, y: contentInset.top, width: frame.width-contentInset.left-contentInset.right, height: frame.height-contentInset.top-contentInset.bottom-34)
        } else {
            contentView.frame = CGRect(x: contentInset.left, y: contentInset.top, width: frame.width-contentInset.left-contentInset.right, height: frame.height-contentInset.top-contentInset.bottom)
        }
        
        textView = UITextView()
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColor.black
        textView.tintColor = UIColor.blue
        textView.returnKeyType = .send
        textView.isUserInteractionEnabled = false
        textView.delegate = self
        contentView.addSubview(textView)
        
        lineFragmentPadding = textView.textContainer.lineFragmentPadding
        editorColor = textView.tintColor
        font = textView.font
        textColor = textView.textColor
        
        textView.textContainerInset = UIEdgeInsets.zero
        
        textView.frame = CGRect(x: 0, y: (contentView.frame.height-font.lineHeight)/2, width: contentView.frame.width, height: font.lineHeight)
        
        placeholderLabel = UILabel()
        placeholderLabel.font = font
        placeholderLabel.textColor = UIColor.gray.withAlphaComponent(0.7)
        contentView.addSubview(placeholderLabel)
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 0.5))
        line.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        addSubview(line)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func tapAction() {
        textView.becomeFirstResponder()
    }
    
    private func upDateContent() {
        if UIDevice.current.isX() {
            contentView.frame = CGRect(x: contentInset.left, y: contentInset.top, width: frame.width-contentInset.left-contentInset.right, height: frame.height-contentInset.top-contentInset.bottom-34)
        } else {
            contentView.frame = CGRect(x: contentInset.left, y: contentInset.top, width: frame.width-contentInset.left-contentInset.right, height: frame.height-contentInset.top-contentInset.bottom)
        }
        
        textView.frame = CGRect(x: 0, y: (contentView.frame.height-font.lineHeight)/2, width: contentView.frame.width, height: font.lineHeight)
        textView.textContainer.lineFragmentPadding = lineFragmentPadding

        textView.tintColor = editorColor
        textView.font = font
        textView.textColor = textColor
        textView.enablesReturnKeyAutomatically = true

        placeholderLabel.text = placeholder
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin.x = textView.textContainer.lineFragmentPadding
        placeholderLabel.center.y = textView.frame.midY
    }
    
    private func upDateHeight(_ height: CGFloat) {
        let changH = height-textView.frame.height
        frame.origin.y -= changH
        frame.size.height += changH
        contentView.frame.size.height += changH
        textView.frame.size.height += changH
    }
    
    private func updateHeight(with text: String) {
        if let iText = text as NSString? {   
            let width = textView.frame.width-2*textView.textContainer.lineFragmentPadding
            let size = iText.boundingRect(with: CGSize(width: width, height: 0), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font : font!], context: nil)
            let numberOfLines = size.height/font.lineHeight
            if numberOfLines > CGFloat(showNumberOfLines) {
                textView.isScrollEnabled = true
                upDateHeight(font.lineHeight*CGFloat(showNumberOfLines)+10)
            } else {
                textView.isScrollEnabled = false
                upDateHeight(size.height)
            }
        }
    }
    
    func endEditing(_ clickSend: @escaping (String)->()) {
        sendClick = clickSend
    }
    
    @objc private func keyboardWillChangeFrame(_ notifi: Notification) {
        guard let info = notifi.userInfo as? [String : Any] else { return }
        guard let rect = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let animationDuration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let animationCurve = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else { return }
        guard let sup = self.superview else { return }                

        if let curve = UIView.AnimationCurve(rawValue: animationCurve) {            
            UIView.setAnimationCurve(curve)
        }
        if KEYSCREEN_H == rect.maxY {
            UIView.animate(withDuration: animationDuration) { 
                if UIDevice.current.isX() {
                    self.frame.origin.y = sup.bounds.height-rect.height-self.frame.height+34
                } else {
                    self.frame.origin.y = sup.bounds.height-rect.height-self.frame.height
                }
            }
        } else {
            UIView.animate(withDuration: animationDuration) { 
                self.frame.origin.y = sup.bounds.height-self.frame.height
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension SendMessageView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.text.count > 0 ? true : false
        cacheText = textView.text
        updateHeight(with: textView.text)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.isUserInteractionEnabled = true
        textView.text = cacheText
        updateHeight(with: textView.text)
        placeholderLabel.isHidden = textView.text.count > 0 ? true : false
        textView.selectedRange = NSRange(location: (textView.text as NSString).length, length: 0)
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.isUserInteractionEnabled = false
        textView.text = ""
        updateHeight(with: textView.text)
        placeholderLabel.isHidden = textView.text.count > 0 ? true : false
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            sendClick(textView.text)
            cacheText = ""
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
