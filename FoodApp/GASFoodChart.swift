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
    public var returnValue : ((APIFood) -> NSNumber)?
    public var maxValue : Double = 1000.0
    public var maxWidth : CGFloat = 80.0
    
    var colors : [UIColor] = [UIColor.red]
    
    public func updateMeasurements() {

        if data.count > 0 {
            let marginShare : CGFloat = self.frame.width / 4.0
            marginBar = marginShare / CGFloat(Double(data.count + 1))
            barWidth = min(maxWidth,(self.frame.width - marginShare) / CGFloat(data.count))
        } else {
            marginBar = 1.0
            barWidth = 1.0
        }
        
        if let parent = self.superview {
            self.center = CGPoint(x: parent.frame.width / 2, y: parent.frame.height / 2 - 5.0)
        } else {
            self.center = CGPoint(x: self.frame.width / 2 + marginBar, y: self.frame.height / 2)
        }
        
        let labelHeight : CGFloat = 20.0
        barHeight = self.frame.height - (labelHeight * 2)
        
    }
    
    public override func draw() {
        updateMeasurements()
        super.draw()
    }
    
    public func numberOfBars() -> Int {
        return data.count
    }
    
    public func valueForBar(at index: Int) -> NSNumber! {
        
        if let action = returnValue {
            let value = action(data[index])
            let scale = value.doubleValue / maxValue
            return NSNumber(floatLiteral: 100.0 * scale)
        } else {
            return 0.0
        }
        
    }
    
    public func colorForBar(at index: Int) -> UIColor! {
        return colors[index % colors.count]
    }
    
    public func colorForBarBackground(at index: Int) -> UIColor! {
        return UIColor.lightGray
    }
    
    public func animationDurationForBar(at index: Int) -> CFTimeInterval {
        return 0.0
    }

    public func titleForBar(at index: Int) -> String! {
        let name = data[index].name
        let len = min(3, name.characters.count)
        return name.substring(to: name.index(name.startIndex, offsetBy: len))
    }

    
}
