//
//  LTLocalLanguage.swift
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
//  Created by LonTe on 2019/8/7.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTLocalLanguage {
    enum Identifiy: String {
        case auto = "auto"
        case en = "en"
        case zh = "zh-Hans"
    }
    
    static let shared = LTLocalLanguage()
    private var _currentLanguage: Identifiy = .auto
    var currentLanguage: Identifiy {
        return _currentLanguage
    }
    
    private init() {
        getCurrentLanguage()
    }
    
    private func getCurrentLanguage() {
        guard let language = UserDefaults.standard.string(forKey: LOCALLANGUAGE) else {
            _currentLanguage = .auto
            return
        }
        analyticLanguage(language: language)
    }
    
    private func analyticLanguage(language: String) {
        if language.hasPrefix("zh") {
            _currentLanguage = .zh
        } else if language.hasPrefix("auto") {
            _currentLanguage = .auto
        } else {
            _currentLanguage = .en
        }
    }
    
    func changCurrentLanguage(idendifiy: Identifiy) {
        UserDefaults.standard.set(idendifiy.rawValue, forKey: LOCALLANGUAGE)
        UserDefaults.standard.synchronize()
        
        analyticLanguage(language: idendifiy.rawValue)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LANGUAGESCHANGED), object: nil)
    }
}

extension String {
    var localString: String {
        var resource = LTLocalLanguage.shared.currentLanguage.rawValue
        if LTLocalLanguage.shared.currentLanguage == .auto {
            if let language = Locale.preferredLanguages.first {
                if language.hasPrefix("zh") {
                    resource = LTLocalLanguage.Identifiy.zh.rawValue
                } else {
                    resource = LTLocalLanguage.Identifiy.en.rawValue
                }
            }
        }
        if let path = Bundle.main.path(forResource: resource, ofType: "lproj") {
            if let bundle = Bundle(path: path) {
                return bundle.localizedString(forKey: self, value: nil, table: nil)
            }
        }
        return Bundle.main.localizedString(forKey: self, value: self, table: nil)
    }
}
