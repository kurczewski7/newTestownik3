//
//  AppDelegate.swift
//  Testownik
//
//  Created by Slawek Kurczewski on 14/02/2020.
//  Copyright © 2020 Slawomir Kurczewski. All rights reserved.
//

import UIKit
import CoreData
import CoreMedia

// FIXME: comment here
// TODO:  comment here
// MARK:  do zrobienia

let coreData       = CoreDataStack()
let database       = Database(context: coreData.persistentContainer.viewContext)

let testownik      = Testownik()
let ratings        = Ratings()
let speech         = Speech()
let pictureLibrary = PictureLibrary()

//let allLanguages = ["en", "pl", "de", "fr", "es" ]
// let langDict


//let coreData = CoreDataStack()
//let database = Database(context: coreData.persistentContainer.viewContext)

@UIApplicationMain
   class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("S T A R T\n")
        let languages = Locale.preferredLanguages
        if  let languagePrefix = languages.first?.components(separatedBy: "-").first?.lowercased(){
            print(languagePrefix)
            Setup.initValue()
            Settings.shared.readCurrentLanguae()
            //Settings.readCurrentLanguae()
            //print("xx: '\(xx)")
        }
//        let newVal = Settings.CodePageEnum.iso9
//        let listen = Settings.shared.getValue(boolForKey: .listening_key)
//        let _ = Settings.shared.getValue(boolForKey: .dark_thema_key)
//        let _ = Settings.shared.getValue(boolForKey:  .listening_key)
//        let _ = Settings.shared.getValue(stringForKey: .language_key)
//
//        Settings.shared.setValue(forKey: .listening_key, newBoolValue:  !listen)
//        Settings.shared.setValue(forKey: .code_page_key, newStringValue: newVal.rawValue)
//        Settings.shared.setValue(forKey: .dark_thema_key, newBoolValue: true)
//        Settings.shared.setValue(forKey: .repeating_key, newStringValue: Settings.RepeatingEnum.repeating_c.rawValue)

        //testownik = Testownik()
        
        testownik.xcts_random(size: 3, forCount: 500)
        var answerList: [Testownik.Answer] = [Testownik.Answer]()
        answerList.append(Testownik.Answer(isOK: true, answerOption: "1"))
        answerList.append(Testownik.Answer(isOK: true, answerOption: "2"))
        answerList.append(Testownik.Answer(isOK: true, answerOption: "3"))
        let wyn1 = testownik.changeOrder(forAnswerOptions: answerList)
        let wyn2 = testownik.changeOrder(forAnswerOptions: answerList)
        let wyn3 = testownik.changeOrder(forAnswerOptions: answerList)
        let wyn4 = testownik.changeOrder(forAnswerOptions: answerList)
        print(wyn1)
        print(wyn2)
        print(wyn3)
        print(wyn4)
        
        var xxList: [Int] = [Int]()
        for i in 0..<32 {
            xxList.append(i+1)
        }
        
        if let path0 = Bundle.main.path(forResource: "543", ofType: "txt") {
            let aa0 = testownik.giveCodepaeText(contentsOfFile: path0, encoding: String.Encoding(rawValue: UInt(15)))
            print("aa0=\(aa0)")
            let aa1 = testownik.giveCodepaeText(contentsOfFile: path0, encoding: String.Encoding(rawValue: UInt(4)))
            print("aa1=\(aa1)")
            var val: String.Encoding.RawValue = 0
            let aa3 = testownik.giveCodepaeText(contentsOfFile: path0, encoding: String.Encoding(rawValue: val))
            print("aa3=\(aa3)")
            val = 1
            let bb = testownik.giveCodepaeText(contentsOfFile: path0, encoding: String.Encoding(rawValue: val))
            print("bb=\(bb)")
            val = 14
            let cc = testownik.giveCodepaeText(contentsOfFile: path0, encoding: String.Encoding(rawValue: val))
            print("cc=\(cc)")
        }
        // TODO: test ratings
        ratings.xxxxxx()
        let rr = ratings[2]
        rr?.correctionsToDo = 1963
        
        print("rr:\(String(describing: rr))")
        ratings.printf()
        ratings[1] = rr
        ratings[2] = rr
        ratings.editRating(forIndex: 0) {
            $0.repetitionsToDo = 2021
            $0.lastAnswer = false
            $0.correctionsToDo = 1410
            return $0
        }
        ratings.editRating(forIndex: 1) { result in
            result.repetitionsToDo = 4440
            return result
        }
        
        ratings.editRating(forIndex: 3) { result in
            result.repetitionsToDo = 5550
            return result
        }

        ratings.editRating(forIndex: 11) { result in
            result.repetitionsToDo = 6660
            return result
        }
        
//        ratings.editRating(forIndex: 3) {
//            let nrFile = ratings
//        }
//        ratings.editRating(forIndex: 3) {
//            let tmp = self.
//            //tstResult.errorMultiple = 7
//            //return tstResult
//        }
      
        
        
        for i in 0..<Locale.preferredLanguages.count {
            print("System lang \(i):\(Locale.preferredLanguages[i])")
        }
        
        Locale.autoupdatingCurrent.languageCode
        print("App languae, Locale.autoupdatingCurrent.languageCode: \(Locale.autoupdatingCurrent.languageCode ?? "brak")")
        print("Settins dev, Locale.current:\(Locale.current.languageCode ?? "brak języka")")
        print("(Bundle.main.preferredLocalizations: \(String(describing: Bundle.main.preferredLocalizations.first))")
        print("Locale.current.identifier: \(Locale.current.identifier)")
       
        
//        extension Locale {
//            static var preferredLanguageCode: String {
//                let defaultLanguage = "en"
//                let preferredLanguage = preferredLanguages.first ?? defaultLanguage
//                return Locale(identifier: preferredLanguage).languageCode ?? defaultLanguage
//            }
//
//            static var preferredLanguageCodes: [String] {
//                return Locale.preferredLanguages.compactMap({Locale(identifier: $0).languageCode})
//            }
//        }
        

        speech.setLanguage(selectedLanguage: 3)
        speech.startSpeak()
        
        let fullHomePath = NSHomeDirectory()
        print("\n=========\nfullHomePath = file:///\(fullHomePath)")
        
        //database.allTestsTable.loadData(fieldName: "user_name", fieldValue: "trzeci")
        
        database.selectedTestTable.loadData()
        if database.selectedTestTable.count > 0 && Int(database.selectedTestTable[0]!.group_size) == 0 {
            database.selectedTestTable[0]?.group_size = 10
            database.selectedTestTable.save()
        }
        if database.selectedTestTable.count > 0 && Int(database.selectedTestTable[0]!.reapead_test) == 0 {
            database.selectedTestTable[0]?.reapead_test = 2
            database.selectedTestTable.save()
        }
        database.allTestsTable.loadData()
        database.testDescriptionTable.loadData()
        database.ratingsTable.loadData()
        database.testListTable.loadData()
        

        
        print("allTestsTable.count:\(database.allTestsTable.count)\n")
        print("selectedTestTable.count:\(database.selectedTestTable.count)\n")
        print("testDescriptionTable.count:\(database.testDescriptionTable.count)\n")
        print("Test name:\(database.selectedTestTable[0]?.toAllRelationship?.user_name ?? "brak")")
        
        
        print("rr2:\(ratings[2]?.fileNumber ?? 0),\(ratings[2]?.correctionsToDo ?? 0)")
        ratings.printf()
        ratings.saveRatings()
        ratings.saveTestList()
        ratings.restoreRatings()
        ratings.restoreTestList()

  
        let newVal = Settings.CodePageEnum.iso9
        let listen = Settings.shared.getValue(boolForKey: .listening_key)
        let _ = Settings.shared.getValue(boolForKey: .dark_thema_key)
        let _ = Settings.shared.getValue(boolForKey:  .listening_key)
        let _ = Settings.shared.getValue(stringForKey: .language_key)
        
        Settings.shared.setValue(forKey: .listening_key, newBoolValue:  !listen)
        Settings.shared.setValue(forKey: .code_page_key, newStringValue: newVal.rawValue)
        Settings.shared.setValue(forKey: .dark_thema_key, newBoolValue: true)
        Settings.shared.setValue(forKey: .repeating_key, newStringValue: Settings.RepeatingEnum.repeating_c.rawValue)
        
//        database.allTestsTable.deleteAll()
//        database.allTestsTable.save()
//        database.testDescriptionTable.deleteAll()
//        database.testDescriptionTable.save()
//        database.selectedTestTable.deleteAll()
//        database.selectedTestTable.save()
//        database.testListTable.deleteAll()
//        database.testListTable.save()
//        database.ratingsTable.deleteAll()
//        database.ratingsTable.save()
        
        if database.selectedTestTable.count == 0 {
            let selTest = SelectedTestEntity(context: database.context)
            selTest.uuId = UUID()
            selTest.group_size = 30
            selTest.reapead_test = 5
            selTest.current_position = 0
            _ = database.selectedTestTable.add(value: selTest)
            database.save()
        }
        return true
        // End finish lanching
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }



}

