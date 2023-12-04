//
//  Manager.swift
//  Pods
//
//  Created by Sławek K on 03/12/2023.
//

import Foundation

protocol ArrayProperty {
    var currentIndex: Int { get }
}

// MARK: extension
typealias TestDataArr = [Manager.TestData]
extension TestDataArr: ArrayProperty {
    var currentIndex: Int {
        get {
            return 99
        }
    }
    //var currentIndex: Int = 0
    func isInRange(_ index: Int) -> Bool {
        return index < self.count
    }
    func isLast(_ index: Int) -> Bool {
        return index == self.count - 1
    }
    func isExistNext(_ index: Int) -> Bool {
        return index < self.count - 1
    }
    func createSortKey() -> [Int] {
        let len = self.count
        guard len > 0 else { return [Int]() }
        var retVal = [Int](repeating: 0, count: len)
        //retVal = Setup.randomOrder(toMax: 555)
        return [0]
    }
}
// MARK: protocol
protocol ManagerDataSource {
    var count: Int { get }
    var currentPosition: Int { get }
    var fileNumber: Int { get set }
    var finishedAdd: Bool { get set }
    func save()
    func restore()

//    var rawTestList : [Int] { get }
//    var allTestPull: [Manager.TestData] { get }
//    var loteryTestBasket: [Manager.TestData] { get }
//    var historycalTest: [Manager.TestData] { get }
    
}
// MARK: class
class Manager: ManagerDataSource  {
    func save() {
        
    }
    
    func restore() {
        
    }
    //DataOperations TestManagerDataSource
    struct AnswerShort {
            let isOK: Bool
            var lastYourCheck: Bool = false
    }
    struct TestData {
        let fileNumber: Int
        let lifeValue: Int
        var answerOptions = [AnswerShort]()
        let oneWasSelected: Bool = false
        var isCorect: Bool = false
        var keySort: [Int] = [Int]()
        
        //        let groupNr: Int
        //        let errorReapad: Int
        //        let reapadNr: Int
        //        let checked: Bool
        //        let extra: String // ???
    }
    var count: Int = 0
    var currentPosition: Int = 0
    var fileNumber: Int = 0
    
    var testList : [Test] = [Test]()
    var allTestPull: TestDataArr = TestDataArr()
    var loteryTestBasket: TestDataArr = TestDataArr()
    var historycalTest: TestDataArr = TestDataArr()
    var finishedTest: TestDataArr = TestDataArr()
    var finishedAdd = false
    init(_ testList: [Test]) {
        self.testList = testList
    }
    
    func next() -> Bool  {
        let isNext = historycalTest.isExistNext(currentPosition)
        let finishedAdd = loteryTestBasket.isEmpty
        guard !(finishedAdd && historycalTest.isLast(currentPosition)) else { return false }
        if isNext {
            readNext()
        } else {
            addNext()
        }
        return true
    }
    func readNext() {
        
    }
    func addNext() {
        
    }
    func createSortedKey() -> [Int] {
        return [0]
    }
    func reverseSortedKey(_ key: [Int]) -> [Int] {
        return [0]
    }
    
}

