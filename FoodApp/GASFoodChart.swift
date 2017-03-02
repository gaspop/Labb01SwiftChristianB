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
    
    public var maxValue : Double = 1000.0
    
    public func updateMeasurements() {
        if let parent = self.superview {
            self.center = CGPoint(x: parent.frame.width / 2, y: parent.frame.height / 2)
        } else {
            self.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        }
        
        if data.count > 0 {
            let marginShare : CGFloat = self.frame.width / 4.0
            marginBar = marginShare / CGFloat(Double(data.count + 1))
            barWidth = (self.frame.width - marginShare) / CGFloat(data.count)
        } else {
            marginBar = 1.0
            barWidth = 1.0
        }
        
        let labelHeight : CGFloat = 20.0
        barHeight = self.frame.height - labelHeight
        
    }
    
    public override func draw() {
        updateMeasurements()
        super.draw()
    }
    
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
        //print("Bar \(index) value: \(NSNumber(floatLiteral: Double(data[index].healthyness)))")
        let value = NSNumber(floatLiteral: Double(data[index].energy))
        let scale = value.doubleValue / maxValue
        return NSNumber(floatLiteral: Double(barHeight) * scale)
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
