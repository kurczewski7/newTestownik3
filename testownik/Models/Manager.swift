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
    func sortFullArrayIntoGroups(forGroupLenth lenth: Int) -> [Element] {
        // FIXME: not last group
        let emptyArr = [Element]()
        var retValue = [Element]()
        guard lenth > 0 else { return emptyArr }
        //let groups = Int(self.count / lenth)
        let totalGroups = (self.count / lenth) + (self.count % lenth == 0 ? 0 : 1 )
        retValue.removeAll()
        for i in 0..<totalGroups {
            let tmpArr = sortArrayByFragment(fromStartIndex: i * lenth, count: lenth)
            retValue.append(contentsOf: tmpArr)
        }
        // TODO: fill it
        return retValue
    }
    func sortArrayByFragment(fromStartIndex start: Int, count: Int)  -> [Element]  {
        let emptyArr = [Element]()
        guard self.isInRange(start) else { return emptyArr }
        let end = start + count - 1
        guard self.isInRange(end) else { return emptyArr }
        var tmpArr = Array(self[start...end])
        tmpArr = self.changeSubArryyOrder(fromPosition: 0, count: tmpArr.count)
        return tmpArr
    }
    // MARKT : Method randomOrder: for toMax = 10 get from 0 to 9
    func randomOrder(toMax: Int) -> Int {
        return Int(arc4random_uniform(UInt32(toMax)))
    }
    mutating func removeRandomElement() -> Element? {
        var retVal: Element        
        guard self.count > 0 else { return nil }
        guard self.count == 1 else {
            retVal = self[0]
            self.remove(at: 0)
            return retVal
        }
        let idx = randomOrder(toMax: self.count)
        retVal = self[idx]
        self.remove(at: idx)
        return retVal
    }
    func changeSubArryyOrder(fromPosition start: Int, count: Int) -> [Element] {
        let array = self
        var position = 0
        var sortedArray = [Element]()
        let len = array.count
        let end = array.index(start, offsetBy: count, limitedBy: len) ?? len
        //array.index(start, offsetBy: count)
        guard start < len, end <= len else {   return sortedArray      }
        var tmpArray = Array(array[start..<end])
        guard tmpArray.count > 0 else {   return sortedArray      }
        for _ in 1...tmpArray.count {
            position = self.randomOrder(toMax: tmpArray.count)
            sortedArray.append(tmpArray[position])
            tmpArray.remove(at: position)
        }
        return sortedArray
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
    
    // MARK: init
    init(_ testListCount: Int, maxValueLive: Int, groupSize: Int ) {
        //  _ testList: inout [Test])
        let lifeValue = 1
        let groupSize = 5
        //self.testList = testList
        self.fillAllTestPull(testListCount: testListCount, forLiveValue: maxValueLive, groupSize: groupSize)
        print("\(allTestPull)")
    }
    // MARK: methods
    func fillAllTestPull(testListCount: Int, forLiveValue lifeValue: Int, groupSize: Int = 5) {
        for i in 0..<testListCount {
            let el = TestData(fileNumber: i, lifeValue: lifeValue)
            allTestPull.append(el)
        }
        allTestPull = allTestPull.sortFullArrayIntoGroups(forGroupLenth: groupSize)
    }
    //        let sortKey = allTestPull.createSortKey()
    //        allTestPull = allTestPull.sortArray(forUserKey: sortKey)
    
//    func loteryQueue() {
//        var tmpTestPull = [TestInfo]()
//        let totalGroups = (self.allTestPull.count / self.groupSize) + (self.allTestPull.count % self.groupSize == 0 ? 0 : 1 )
//        for i in 0..<totalGroups {
//            let oneGroup = Setup.changeArryyOrder(forArray: self.allTestPull, fromPosition: i * self.groupSize, count: self.groupSize)
//            tmpTestPull.append(contentsOf: oneGroup)
//        }
//        print("new Pull: \(tmpTestPull)")
//        self.allTestPull = tmpTestPull
//    }

    func fillLoteryBasket() {
        
    }
    func fillHistorycal() {
        
    }
    func fillFinished() {
        allTestPull.sortArray(forUserKey: [2, 0, 1])
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

