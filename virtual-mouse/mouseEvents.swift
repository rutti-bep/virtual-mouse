//
//  mouseEvents.swift
//  virtual-mouse
//
//  Created by 今野暁 on 2017/05/22.
//  Copyright © 2017年 今野暁. All rights reserved.
//

import Foundation

class MouseController:NSObject {
    
    let kDelayUsec : useconds_t = 10000
    var isDown = false
    
    func Move (frame: NSRect){
        let movedPointX = frame.minX+(frame.maxX-frame.minX) * CGFloat(arc4random()%100)/100;
        let movedPointY = frame.minY+(frame.maxY-frame.minY) * CGFloat(arc4random()%100)/100;
        let movedPoint = NSPoint(x:movedPointX,y:movedPointY);
        Swift.print(movedPoint);
        
        let mouseMove = CGEvent(mouseEventSource:nil, mouseType:.leftMouseDragged, mouseCursorPosition:movedPoint, mouseButton:CGMouseButton.left)
        mouseMove!.post(tap:.cghidEventTap)
        usleep(self.kDelayUsec)
    }
    
    func Down (point: CGPoint){
        let mouseDown = CGEvent(mouseEventSource:nil, mouseType:.leftMouseDown, mouseCursorPosition:point, mouseButton:CGMouseButton.left)
        mouseDown!.post(tap:.cghidEventTap)
        self.isDown = true;
    }
    
    func Up (point: CGPoint){
        let mouseUp = CGEvent(mouseEventSource:nil, mouseType:.leftMouseUp, mouseCursorPosition:point, mouseButton:CGMouseButton.left)
        mouseUp!.post(tap:.cghidEventTap)
        self.isDown = false;
    }
    
    func click(point: CGPoint){
        self.Down(point: point);
        usleep(self.kDelayUsec)
        self.Up(point: point);
    }
    
    func doubleClick(point: CGPoint){
        self.click(point: point);
        self.click(point: point);
    }
}

