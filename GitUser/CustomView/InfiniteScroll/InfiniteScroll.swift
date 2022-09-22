//
//  InfiniteScroll.swift
//  GitUser
//
//  Created by Jan Sebastian on 22/09/22.
//

import Foundation
import UIKit

class InfiniteScroll<T> {
    private var tempData: [T] = []
    private var originalData: [T] = []
    private var sliceNumber: Int = 0
    private var indexesToRemove: Set = Set<Int>()
    init(sliceNumber: Int) {
        self.sliceNumber = sliceNumber
        
        for index in 0...(sliceNumber - 1) {
            indexesToRemove.insert(index)
        }
        
    }
    var loadingAnimation: (() -> Void)?
    var endLoadingAnimation: (() -> Void)?
    private var onLoad: Bool = false
    
    func setSliceNumber(sliceNumber: Int) {
        self.sliceNumber = sliceNumber
    }
    
    func setTempData(data: [T]) {
        self.tempData = data
        self.originalData = []
        self.onLoad = false
        
        if sliceNumber == 0 {
            self.originalData = data
            self.tempData = []
            return
        }
        
        self.originalData = Array(tempData.prefix(sliceNumber))
        self.tempData = self.tempData.enumerated().filter { !indexesToRemove.contains($0.offset) }.map { $0.element }
    }
    
    func refetchData(tabel: UITableView) {
        if sliceNumber == 0 || self.tempData.count == 0 {
            return
        }
        
        if onLoad {
            return
        }
        onLoad = true
        loadingAnimation?()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            let slicedData = Array(strongSelf.tempData.prefix(strongSelf.sliceNumber))
            strongSelf.tempData = strongSelf.tempData.enumerated().filter { !strongSelf.indexesToRemove.contains($0.offset) }.map { $0.element }
            
            var listIndex: [IndexPath] = []
            let start = strongSelf.originalData.count
            print("start: \(strongSelf.originalData.count) ")
            let end = (strongSelf.originalData.count + (slicedData.count - 1))
            print("end: \(strongSelf.originalData.count) + \(slicedData.count - 1) = \(end)")
            for index in start...end {
                listIndex.append(IndexPath(row: index, section: 0))
            }
            tabel.beginUpdates()
            strongSelf.originalData += slicedData
            tabel.insertRows(at: listIndex, with: .automatic)
            tabel.endUpdates()
            strongSelf.onLoad = false
            strongSelf.endLoadingAnimation?()
        })
    }
    
    func resetList() {
        self.originalData = []
        self.tempData = []
        onLoad = false
    }
    
    func getOrifinalData() -> [T] {
        return originalData
    }
    
    func nomberOfCurrentData() -> Int {
        return originalData.count
    }
    
}
