//
//  LTTextView.swift
//  langTao
//
//  **********************************************
//  *     _    _        _ˍ_ˍ_        _    _      *
//  *    | |  | |      |__   |      \ \  / /     *
//  *    | |__| |        /  /        \ \/ /      *
//  *    |  __  |       /  /          \  /       *
//  *    | |  | |      /  /__       __/ /        *
//  *    |_|  |_|      |_ˍ_ˍ_|     |_ˍ_/         *
//  *                                            *
//  **********************************************
//
//  Created by LonTe on 2019/8/16.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTTextView: UITextView {
    var placeholder: String?
    private var textDidChanged: ((String)->())?
    
    init(frame: CGRect, aFont: UIFont = UIFont.systemFont(ofSize: 15), textDidChange block: ((String)->())? = nil) {
        super.init(frame: frame, textContainer: nil)
        font = aFont
        textDidChanged = block
        enablesReturnKeyAutomatically = true
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        if let placeStr = placeholder as NSString?, text.count == 0 {
            let width = rect.width-textContainer.lineFragmentPadding*2-textContainerInset.left-textContainerInset.right
            let height = rect.height-textContainerInset.top-textContainerInset.bottom
            let iRect = CGRect(x: textContainerInset.left+textContainer.lineFragmentPadding, y: textContainerInset.top, width: width, height: height)
            placeStr.draw(in: iRect, withAttributes: [.font : font!, .foregroundColor : UIColor.gray.withAlphaComponent(0.7)])
        }
    }
}

extension LTTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == self {
            textDidChanged?(text ?? "")
            setNeedsDisplay()
        }
    }
}
