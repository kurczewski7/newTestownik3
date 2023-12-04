//
//  Manager.swift
//  Pods
//
//  Created by Sławek K on 03/12/2023.
//

import Foundation

//protocol ArrayProperty {
//    var currentIndex: Int { get }
//}

// MARK: extension
typealias TestDataArr = [Manager.TestData]
extension TestDataArr {
    func createSortKey() -> [Int] {
        let len = self.count
        guard len > 0 else { return [Int]() }
        var retVal = [Int](repeating: 0, count: len)
        for i in 0..<len {
            retVal[i] = i
        }
        return Setup.changeArryyOrder(forArray: retVal, fromPosition: 0, count: retVal.count)
    }
    func sortArray(forUserKey key: [Int]) -> [Element?] {  // [aa, bb, cc] ->  [bb, cc, aa]
        let len = Swift.min(self.count, key.count)
        var retVal: [Element] = [Element]() // [1, 2, 0]
        for i in 0..<len {
            retVal.append(self[key[i]])
        }
        return retVal
    }
    func reversSortArray(forUserKey key: [Int]) -> [Element] {
        let len = Swift.min(self.count, key.count)
        var retVal: [Element] = [Element]()          // [1, 2, 0]
        for _ in 0..<len {
            retVal.append(self[0])
        }
        for i in 0..<len {                          // [1, 2, 0]        [bb, cc, aa] -> [aa  , bb , cc ]
            retVal[key[i]] = self[i]
        }
        return retVal
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

    var testList : [Test] { get }
    var allTestPull: TestDataArr { get }
    var loteryTestBasket: TestDataArr { get }
    var historycalTest: TestDataArr { get }
    var finishedTest: TestDataArr { get }
}
// MARK: class
class Manager: ManagerDataSource  {
    //DataOperations TestManagerDataSource
    // MARK: type
    enum HistoryArrayType: Int {
        case undefined = 0
        case allPool   = 1
        case basket    = 2
        case history   = 3
        case finished  = 4
    }
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
    }
    //        let groupNr: Int
    //        let errorReapad: Int
    //        let reapadNr: Int
    //        let checked: Bool
    //        let extra: String // ???

    // MARK: variable
    var count: Int = 0
    var currentPosition: Int = 0
    var fileNumber: Int = 0
    
    var testList : [Test] = [Test]()
    var allTestPull: TestDataArr = TestDataArr()
    var loteryTestBasket: TestDataArr = TestDataArr()
    var historycalTest: TestDataArr = TestDataArr()
    var finishedTest: TestDataArr = TestDataArr()
    var finishedAdd = false
    init(_ testList: inout [Test]) {
        self.testList = testList
    }
    // MARK: method
    func fillAllTestPull() {
        
    }
    func fillLoteryBasket() {
        
    }
    func fillHistorycal() {
        
    }
    func fillFinished() {
        
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
    func save() {
        
    }
    
    func restore() {
        
    }
}

