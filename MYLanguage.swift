//
//  LanguageClass.swift
//  Lc
//
//  Created by Luciano Calderano on 09/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import Foundation

func Lng(_ key: String) -> String {
    if LanguageConfig.dict.count == 0 {
        LanguageClass.open()
    }
    if LanguageConfig.dict[key] == nil {
        return "[Key:" + key + "?]"
    }
    return LanguageConfig.dict[key]!
}

struct LanguageConfig {
    static var dict = [String: String]()
    static let count = 2
    static let defaultLanguage = LanguageType.it
    static var currentLanguage = LanguageConfig.defaultLanguage
}

enum LanguageType: String {
    case en
    case it
}

@objc class ClsLang : NSObject { // Kanito
    @objc class func key (key: String) -> String {
        return Lng(key)
    }
    @objc class func langId () -> String {
        return ClsLang.getKey("id")
    }
    @objc class func langCode () -> String {
        return ClsLang.getKey("code")
    }

    @objc class func getKey (_ key: String) -> String {
        let key = "Language"
        let dict = UserDefaults.standard.value(forKey: key) as? JsonDict
        if dict == nil {
            return ""
        }
        return dict!.string(key)
    }

    @objc class func saveLanguageList (_ array: [JsonDict]) {
        let key = "Language"
        UserDefaults.standard.set(array, forKey: "LanguagesArray")
        for dict in array {
            let langDict = dict.dictionary(key)
            if langDict.string("iso") == LanguageConfig.currentLanguage.rawValue {
                UserDefaults.standard.set(langDict, forKey: key)
                break
            }
        }
    }
}

class LanguageClass {
    class func open () {
        LanguageClass().selectLanguage()
    }
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: Selector(("selectLanguage")),
                                               name: UserDefaults.didChangeNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func selectLanguage() {
        switch UserDefaults.standard.string(forKey: "settings.langId") ?? "" {
        case LanguageType.en.rawValue:
            LanguageConfig.currentLanguage =  LanguageType.en
        case LanguageType.it.rawValue:
            LanguageConfig.currentLanguage =  LanguageType.it
        default:
            LanguageConfig.currentLanguage = self.selectLanguageFromDevice()
        }
        LanguageConfig.dict = self.loadLanguage(languageType: LanguageConfig.currentLanguage)
    }
    
    private func loadLanguage(languageType language: LanguageType) -> Dictionary<String, String> {
        let filePath = Bundle.main.path(forResource: "Lang", ofType: "txt")
        let str = try? String(contentsOfFile: filePath!, encoding: String.Encoding.utf8) as String
        let array = (str?.components(separatedBy: "\n"))! as [String]
        var dic = [String: String]()

        for s in array {
            let riga = s.components(separatedBy: "=")
            guard riga.count == 2 else {
                continue
            }
            let valuesArray = riga[1].components(separatedBy: "|") as [String]
            guard valuesArray.count == LanguageConfig.count else {
                continue
            }
            dic[riga[0]] = valuesArray[language.hashValue]
        }
        return dic
    }
    
    private func selectLanguageFromDevice() -> LanguageType {
        var strIso = Locale.current.identifier
        if (strIso.characters.count < 2) {
            strIso = Bundle.main.preferredLocalizations.first!
        }
        else if (strIso.characters.count > 2) {
            strIso = strIso.left(2)
        }
        if (strIso.isEmpty == false) {
            switch strIso.lowercased() {
            case LanguageType.en.rawValue:
                return LanguageType.en
            case LanguageType.it.rawValue:
                return LanguageType.it
            default:
                break
            }
        }
        return LanguageConfig.defaultLanguage
    }
}
