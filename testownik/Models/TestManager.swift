//
//  TestManager.swift
//  testownik
//
//  Created by Sławek K on 16/09/2023.
//  Copyright © 2023 Slawomir Kurczewski. All rights reserved.
//

import Foundation

protocol TestManagerDataSource {
//    var count: Int { get }
//    var groups: Int { get }
//    var groupSize: Int { get }
//    var reapeadTest: Int { get }
//    var currentPosition: Int { get }
//    func save()
//    func restore()
}
protocol TestManagerDelegate {
    func allTestDone()
    func progress(forCurrentPosition currentPosition: Int, totalCount count:Int)
    func refreshContent(forFileNumber fileNumber: Int)
    func refreshButtonUI(forFilePosition filePosition: TestToDo.FilePosition)
}
class TestManager: TestManagerDataSource {
    struct TestInfo {
        let fileNumber: Int
        let lifeValue: Int
        
        //        let groupNr: Int
        //        let errorReapad: Int
        //        let reapadNr: Int
        //        let checked: Bool
        //        let extra: String // ???
    }
    struct RawTest {
        let fileNumber: Int
        var isExtraTest: Bool
        var checked: Bool = false
        var errorCorrect: Bool = false
    }
    let groupSize = 5  //Setup.defaultMainGroupSize
    let maxValueLive: Int
    var rawTestListCount: Int
    var rawTestList = [Int]()
    
    var allTestPull: [TestInfo] = [TestInfo]()
    var loteryTestBasket: [TestInfo] = [TestInfo]()
    let wrongAnswersTest: [TestInfo] = [TestInfo]()
    let finishedTest: [TestInfo] = [TestInfo]()
    init(_ rawTestListCount: Int, maxValueLive: Int = 3) {
        self.rawTestListCount = rawTestListCount
        self.maxValueLive = maxValueLive
        createTestManager(forRawListCout: rawTestListCount)
        //self.rawTestList = rawTestList
    }
    func createTestManager(forRawListCout rawListCount: Int) {
        for i in 0..<rawTestListCount {
            let tmpElem = TestInfo(fileNumber: i, lifeValue: 0)
            self.allTestPull.append(tmpElem)
        }
        loteryQueue()
        getNextTest()
        
//        let number = database.testDescriptionTable.count
//        var  rawTestList = [Int]()
//        for i in 0..<number  { // self.testList.count
//            rawTestList.append(i)
//        }
//        self.rawTestList = rawTestList
//        self.testToDo = TestToDo(rawTestList: self.rawTestList)
    }
    func loteryQueue() {
        var tmpTestPull = [TestInfo]()
        let totalGroups = (self.allTestPull.count / self.groupSize) + (self.allTestPull.count % self.groupSize == 0 ? 0 : 1 )
        for i in 0..<totalGroups {
            let oneGroup = Setup.changeArryyOrder(forArray: self.allTestPull, fromPosition: i * self.groupSize, count: self.groupSize)
            tmpTestPull.append(contentsOf: oneGroup)
        }
        print("new Pull: \(tmpTestPull)")
        self.allTestPull = tmpTestPull
    }
    func getNextTest() {
        if self.loteryTestBasket.isEmpty {
            let moreTests = self.allTestPull[0..<self.groupSize]
            self.loteryTestBasket.append(contentsOf: moreTests)
        }
        else    {
            if let oneTest = self.allTestPull.first {
                self.loteryTestBasket.append(oneTest)
                self.allTestPull.remove(at: 0)
            }
        }
    }
    func changeQueue(forRow row: inout [RawTest], fileNumber number: Int, errorCorrect: Bool = true) {
        var newRow: [RawTest] = [RawTest]()
        guard row.count > 0 else {   return   }
        for i in 0..<row.count {
            if row[i].fileNumber != number {
                newRow.append(row[i])
                row.remove(at: i)
                break
            }
        }
        insertAtEnd(fromRow: &row ,toRow: &newRow)
        insertBetween(fromRow: &row, toRow: &newRow, fileNumber: number)
        if row.count > 0 {
            for _ in 0..<5 {
                let oldCount = row.count
                insertBetween(fromRow: &row, toRow: &newRow, fileNumber: number)
                if row.count == oldCount || row.count == 0 {
                    break
                }
            }
        }
        if  row.count > 0 {
            newRow.append(contentsOf: row)
            row.removeAll()
        }
        row = newRow
    }
    private func insertAtEnd(fromRow row: inout [TestManager.RawTest], toRow newRow: inout [TestManager.RawTest]) {
        var setToDelete = Set([Int]())
        let couuntRec = row.count
        for pos in 0..<couuntRec {
            if newRow[newRow.count-1].fileNumber != row[pos].fileNumber {
                newRow.append(row[pos])
                setToDelete.insert(pos)
            }
        }
        let tabToDelete = setToDelete.sorted {$0 > $1}
        for pos in tabToDelete {
            row.remove(at: pos)
        }
    }
    private func insertBetween(fromRow row: inout [TestManager.RawTest], toRow newRow: inout [TestManager.RawTest], fileNumber number: Int) {
        var setToDelete = Set([Int]())
        for pos in 0..<row.count {
            let tmp = row[pos]
            for j in 0..<newRow.count {
                guard row.count > 0 && newRow.count > j else {    continue    }
                if j == newRow.count - 1 {
                    if newRow[j].fileNumber != tmp.fileNumber {
                        newRow.append(tmp)
                        setToDelete.insert(pos)
                    }
                    break
                }
                if j == 0  &&  tmp.fileNumber != number  &&  newRow[j].fileNumber != tmp.fileNumber {
                    newRow.insert(tmp, at: j)
                    setToDelete.insert(pos)
                    break
                }
                if  newRow[j].fileNumber != tmp.fileNumber && newRow[j+1].fileNumber != tmp.fileNumber {
                    newRow.insert(tmp, at: j+1)
                    setToDelete.insert(pos)
                    break
                }
            }
        }
        let tabToDelete = setToDelete.sorted {$0 > $1}
        for poz in tabToDelete {
            row.remove(at: poz)
        }
    }


}
