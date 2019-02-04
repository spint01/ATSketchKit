//
//  ATSketchView+Events.swift
//  ATSketchKit
//
//  Created by Arnaud Thiercelin on 11/26/15.
//  Copyright © 2015 Arnaud Thiercelin. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software
//  and associated documentation files (the "Software"), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
//  NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation

extension ATSketchView {
	
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard touches.count != 0 else {
			NSLog("No touches")
			return
		}

    self.flushRedoHistory()
		
		if event != nil {
		}
		
		let touchPoint = touches.first!.preciseLocation(in: self)
		
		self.touchDownPoint = touchPoint
		self.lastKnownTouchPoint = touchPoint
		if self.currentTool == .pencil || self.currentTool == .eraser || self.currentTool == .smartPencil {
			self.pointsBuffer.append(touchPoint)
			self.updateTopLayer()
			self.setNeedsDisplay()
		}
	}
	
	public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard touches.count != 0 else {
			NSLog("No touches")
			return
		}
		
		
		if event != nil {
		}
		
		let touchPoint = touches.first!.preciseLocation(in: self)
		let rawPoint = touches.first!.preciseLocation(in: self.superview!)
		
		if !self.frame.contains(rawPoint){
			touchesEnded(touches, with: event)
			return
		}
		self.touchDownPoint = touchPoint
		self.lastKnownTouchPoint = touchPoint
		if self.currentTool == .pencil || self.currentTool == .eraser || self.currentTool == .smartPencil {
			self.pointsBuffer.append(touchPoint)
			self.updateTopLayer()
			self.setNeedsDisplay()
		}
	}
	
	public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if self.currentTool == .pencil || self.currentTool == .eraser || self.currentTool == .smartPencil {
			
			self.printTemplateSource(self.pointsBuffer)
			
			let smartPath = ATSmartBezierPath(withPoints: self.pointsBuffer)
			var pathAppended = false
			
			if self.currentTool == .smartPencil {
				let recognizedPathInfo = smartPath.recognizedPath()
				
				if recognizedPathInfo != nil {
					
					var recognizedPathIsAccepted = false
					if self.delegate != nil && self.delegate!.sketchView(self, shouldAccepterRecognizedPathWithScore: recognizedPathInfo!.score) == true {
						recognizedPathIsAccepted = true
					} else if recognizedPathInfo!.score >= 50.0 {
						recognizedPathIsAccepted = true
					}
					
					if recognizedPathIsAccepted {
						var finalPath = recognizedPathInfo!.path
						
						if let overridenPath = self.delegate?.sketchViewOverridingRecognizedPathDrawing(self) {
							finalPath = overridenPath
						}
						
						self.addShapeLayer(finalPath!, lineWidth: self.currentLineWidth, color: self.currentColor)
						self.delegate?.sketchView(self, didRecognizePathWithName: recognizedPathInfo!.template.name)
						pathAppended = true
					}
				}
			}
			
			if pathAppended == false {
				let smoothPath = smartPath.smoothPath(20)
				let finalColor = self.currentTool == .eraser ? self.eraserColor : self.currentColor
				
				self.addShapeLayer(smoothPath, lineWidth: self.currentLineWidth, color: finalColor)
			}
			self.pointsBuffer.removeAll()
			self.clearTopLayer()
			self.setNeedsDisplay()
			self.layer.setNeedsDisplay()
		}
	}
	
	func printTemplateSource(_ points: [CGPoint]) {
		var minX = CGFloat(HUGE)
		var minY = CGFloat(HUGE)
		
		for point in points {
			if point.x < minX {
				minX = point.x
			}
			if point.y < minY {
				minY = point.y
			}
		}
		
		print("Copy paste the source below:")
		var sourceCode = "\nnewTemplate.points = ["
		for point in self.pointsBuffer {
			sourceCode += "CGPoint(x: \(point.x - minX), y: \(point.y - minY)),\n"
		}
		sourceCode += "]"
		
		print("\(sourceCode)")
	}
	
	public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		if self.currentTool == .pencil || self.currentTool == .eraser || self.currentTool == .smartPencil {
			self.pointsBuffer.removeAll()
		}
	}
}
