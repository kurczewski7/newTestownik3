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
        var retVal: [Int] = [Int](repeating: 0, count: len)
        for i in 0..<len {
            retVal[i] = i
        }
        return Setup.changeArryyOrder(forArray: retVal, fromPosition: 0, count: retVal.count)
    }
    //            let sortedArr = self.changeSubArryyOrder(forSubArray: retVal, fromPosition: 0, count: retVal.count)
    //            return sortedArr
    func sortFullArrayIntoGroups(forGroupLenth lenth: Int) -> [Element] {
        // FIXME: not last group
        let emptyArr = [Element]()
        var retValue = [Element]()
        var row = [Element]()
        guard lenth > 0 else { return emptyArr }
        //let groups = Int(self.count / lenth)
        let totalGroups = (self.count / lenth) + (self.count % lenth == 0 ? 0 : 1 )
        retValue.removeAll()
        for i in 0..<totalGroups {
            row.removeAll()
            row = sortOneArrayFragment(fromStartIndex: i * lenth, count: lenth)
            retValue.append(contentsOf: row)
        }
        // TODO: fill it
        return retValue
    }
    func sortOneArrayFragment(fromStartIndex start: Int, count: Int)  -> [Element]  {
        let emptyArr = [Element]()
        guard self.isInRange(start) else { return emptyArr }
        let end = Swift.min(start + count - 1, self.endIndex - 1)
        guard self.isInRange(end) else { return emptyArr }
        var tmpArr = Array(self[start...end])
        tmpArr = self.changeSubArryyOrder(forSubArray: tmpArr, fromPosition: 0, count: tmpArr.count)
        return tmpArr
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
protocol ManagerDelegate {
    func allTestDone()
    func progress(forCurrentPosition currentPosition: Int, totalCount count:Int)
    func refreshContent(forFileNumber fileNumber: Int)
//    func refreshButtonUI(forFilePosition filePosition: TestManager.FilePosition)
    
    //func refreshButtonUI(forFilePosition filePosition: TestManager.FilePosition)
}
// MARK: class
class Manager: ManagerDataSource  {    
    // MARK: type
    enum FilePosition {
        case first
        case last
        case other
    }
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
    var delegate: ManagerDelegate?
    var count: Int = 0
    var currentPosition: Int = 0
    var fileNumber: Int = 0
    var groupSize = 0
    
    var testList : [Test] = [Test]()
    var allTestPull: TestDataArr = TestDataArr()
    var loteryTestBasket: TestDataArr = TestDataArr()
    var historycalTest: TestDataArr = TestDataArr()
    var finishedTest: TestDataArr = TestDataArr()
    var finishedAdd = false
    
    var currentTest: Test? {
        get {
            var test: Test?
            // FIXME: empty testList
            guard testList.isInRange(fileNumber) else { return nil }
            test = testList[fileNumber]
            let options = test?.answerOptions
            if let sortKey = options?.createSortKey() {
                let newOptions = options?.sortArray(forUserKey: sortKey)
                print("\n\(newOptions)")
            }
            print("\(options)")
            return test
        }
        set {
            
        }
    }
    var currentHistory: TestData? {
        get {
            return self.historycalTest.first 
        }
    }
    
    // MARK: init
    init(_ testListCount: Int, maxValueLive: Int, groupSize: Int ) {
        self.groupSize = groupSize
        self.fillAllTestPull(testListCount: testListCount, forLiveValue: maxValueLive, groupSize: groupSize)
        _ = self.fillLoteryBasket()
        print("\(allTestPull.map({$0.fileNumber}))")
        print("TEST LIST=\(testList.map({$0.fileNumber}))")
        //let xx = currentTest
    }
    //        _ testList: inout [Test])
    //        let lifeValue = 1
    //        let groupSize = 5
    //         self.testList = testList

    // MARK: methods
    func first() {
        self.currentPosition = 0
        if historycalTest.isEmpty {
            fillHistorycal()
            fillHistorycal()
            fillHistorycal()
        }
        if historycalTest.isNotEmpty() {
            self.fileNumber = historycalTest.first!.fileNumber
        }
    }
    func next() -> Bool  {
        let isNext = historycalTest.isExistNext(currentPosition)
        let finishedAdd = loteryTestBasket.isEmpty
        guard !(finishedAdd && historycalTest.isLast(currentPosition)) else { return false }
        self.currentPosition += 1
        if isNext {
            self.fileNumber = readNext()
        } else {
            self.fileNumber = addNext()
        }
        return true
    }
    func readNext() -> Int {
        guard historycalTest.isInRange(self.currentPosition) else { return 0 }
        return historycalTest[self.currentPosition].fileNumber
    }
    func addNext() -> Int {
        return 0
    }

    func previous() {
        
    }
    func last() {
        self.currentPosition = historycalTest.count - 1
        if let aTest = historycalTest.last {
            self.fileNumber = aTest.fileNumber
        }
    }
    func fillTestList(forTestList testList : inout [Test]) {
        self.testList = testList
        if self.testList.isEmpty {
            print("testList IS EMPTY")
        }
    }
    func fillAllTestPull(testListCount: Int, forLiveValue lifeValue: Int, groupSize: Int = 5) {
        allTestPull.removeAll()
        for i in 0..<testListCount {
            let el = TestData(fileNumber: i, lifeValue: lifeValue)
            allTestPull.append(el)
        }
        allTestPull = allTestPull.sortFullArrayIntoGroups(forGroupLenth: groupSize)
    }
    func fillLoteryBasket() -> Bool {
        guard allTestPull.isNotEmpty() else { return false }
        if self.loteryTestBasket.isEmpty {
            let end = min(groupSize, allTestPull.count)
            guard end > 0 else { return  false }
            let moreTests = allTestPull[0..<end]
            loteryTestBasket.append(contentsOf: moreTests)
            for _ in 0..<moreTests.count {
                allTestPull.remove(at: 0)
            }
        }
         if loteryTestBasket.count < groupSize {  // 3,5,7             !    1,2
            let newLen = groupSize - loteryTestBasket.count
            for _ in 0..<newLen {
                if let oneTest = allTestPull.first {
                    loteryTestBasket.append(oneTest)
                    allTestPull.remove(at: 0)
                }
                else {
                    break
                }
            }
        }
        return true
    }
    func fillHistorycal() {
        if let test = loteryTestBasket.getRandomElement(deleteItAfter: true) {
            self.fileNumber = test.fileNumber
            historycalTest.append(test)
        }
    }
    func getFirst(onlyNewElement onlyNew: Bool = false)  -> TestData? {
        if historycalTest.isEmpty {
            return nil
        }
        else {
            return historycalTest.first
        }
    }

    func moveToFinished(forLoteryBasket index: Int) {
        guard loteryTestBasket.isInRange(index) else { return }
        let oneTest = loteryTestBasket[index]
        finishedTest.append(oneTest)
        loteryTestBasket.remove(at: index)
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

