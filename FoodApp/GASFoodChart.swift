//
//  GASChart.swift
//  FoodApp
//
//  Created by Christian Blomqvist on 2017-03-02.
//  Copyright © 2017 Christian Blomqvist. All rights reserved.
//

import GraphKit

class GASFoodChart : GKBarGraph, GKBarGraphDataSource {
    
    private var _data : [APIFood] = []
    public var data : [APIFood] {
        get {
            return _data
        }
        set(value) {
            _data = value
        }
    }
    
    public var valueScale : Double = 10.0
    
    /*
    init(frame: CGRect,data:[APIFood]) {
        super.init(frame: frame)
        self.data = data
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)?
    }*/
    
    public func numberOfBars() -> Int {
        return data.count
    }
    
    public func valueForBar(at index: Int) -> NSNumber! {
        print("Bar \(index) value: \(NSNumber(floatLiteral: Double(data[index].healthyness)))")
        return NSNumber(floatLiteral: Double(data[index].healthyness))
    }
    
    public func colorForBar(at index: Int) -> UIColor! {
        return UIColor.yellow
    }
    
    /*public func colorForBarBackground(at index: Int) -> UIColor! {
        
    }*/
    
    public func animationDurationForBar(at index: Int) -> CFTimeInterval {
        return 0.0
    }
    
    public func titleForBar(at index: Int) -> String! {
        return data[index].name
    }

    
}
