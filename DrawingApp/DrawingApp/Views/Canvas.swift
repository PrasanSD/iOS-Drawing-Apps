//
//  Canvas.swift
//  DrawingApp
//
//  Created by Prasan Dhareshwar on 1/9/21.
//

import UIKit


class Canvas: UIView {
    
    fileprivate var lines = [Line]()
    fileprivate var strokeColor = UIColor.black
    fileprivate var strokeWidth: Float = 1
    
    func setStrokeColor(color: UIColor) {
        self.strokeColor = color
    }
    
    func setStrokeWidth(value: Float) {
        self.strokeWidth = value
    }
    
    func undo() {
        _ = lines.popLast()
        setNeedsDisplay()
    }
    
    func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else
            { return }
        
//        let startPoint = CGPoint(x: 0, y: 0)
//        let endPoint = CGPoint(x: 100, y: 100)
//
//        context.move(to: startPoint)
//        context.addLine(to: endPoint)
        
        lines.forEach { (line) in
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(CGFloat(line.strokeWidth))
            context.setLineCap(.round)
            for (i, p) in line.points.enumerated() {
                if i == 0 {
                    context.move(to: p)
                }
                else {
                    context.addLine(to: p)
                }
            }
            context.strokePath()
        }
        
    }
    
//    var line = [CGPoint]()

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(Line.init(strokeWidth: strokeWidth, color: strokeColor, points: []))
    }
    //track the finger as we move across screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else  {
            return
        }
        print(point)
        
        guard var lastLine = lines.popLast() else { return }
        lastLine.points.append(point)
        lines.append(lastLine)
        
//        var lastLine = lines.last
//
//        lastLine?.append(point)
        
//        line.append(point)
        
        setNeedsDisplay()
    }
}
