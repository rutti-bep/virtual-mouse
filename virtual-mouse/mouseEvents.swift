//
//  mouseEvents.swift
//  virtual-mouse
//
//  Created by 今野暁 on 2017/05/22.
//  Copyright © 2017年 今野暁. All rights reserved.
//
import Cocoa
import Foundation

class MouseController:NSObject {
    let moveDelayUsec : useconds_t = 4000;
    let clickDelayUsec : useconds_t = 10000;
    var isDown = false
    let screenSize = NSScreen.main()!.frame;
    
    func Move (frame: NSRect){
        let mousePoint = NSEvent.mouseLocation();
        let nowMousePoint = NSPoint(x:mousePoint.x,y:screenSize.maxY-mousePoint.y)
        
        let movedPointX = frame.minX+(frame.maxX-frame.minX) * CGFloat(arc4random()%100)/100;
        let movedPointY = frame.minY+(frame.maxY-frame.minY) * CGFloat(arc4random()%100)/100;
        let movedPoint = NSPoint(x:movedPointX,y:movedPointY);
        
        let marginX = (movedPoint.x-nowMousePoint.x)/CGFloat(1+CGFloat(arc4random()%100)/100*2)
        let midPointX = nowMousePoint.x+marginX
        
        let marginY = (nowMousePoint.y-movedPoint.y)/CGFloat(1+CGFloat(arc4random()%100)/100*2)
        let midPointY = movedPoint.y+marginY
        
        let midPoint = NSPoint(x:midPointX,y:midPointY)
        
        let moveLength = fabs(nowMousePoint.x-movedPoint.y)+fabs(nowMousePoint.y-movedPoint.y)
        let moveTime = Int(moveLength)/10;
        
        Swift.print(nowMousePoint);
        Swift.print(midPoint);
        Swift.print(movedPoint);
        Swift.print(moveLength);
        Swift.print(moveTime);
        
        for i in 0...moveTime {
            let ratio:CGFloat = 100.0/CGFloat(moveTime)*CGFloat(i)/100;
            Swift.print(ratio);
            
            let pointX = CGFloat(1-ratio)*(1-ratio)*nowMousePoint.x + 2*(1-ratio)*ratio*midPoint.x + ratio*ratio*movedPoint.x;
            let pointY = CGFloat(1-ratio)*(1-ratio)*nowMousePoint.y + 2*(1-ratio)*ratio*midPoint.y + ratio*ratio*movedPoint.y;
            let point = NSPoint(x:pointX,y:pointY);
            
            Swift.print(point)
            
            let mouseMove = CGEvent(mouseEventSource:nil, mouseType:.leftMouseDragged, mouseCursorPosition:point, mouseButton:CGMouseButton.left)
            mouseMove!.post(tap:.cghidEventTap)
            usleep(self.moveDelayUsec)
        }
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
        usleep(self.clickDelayUsec)
        self.Up(point: point);
        usleep(self.clickDelayUsec);
    }
    
    func doubleClick(point: CGPoint){
        self.click(point: point);
        self.click(point: point);
    }
}

