//
//  mouseEvents.swift
//  virtual-mouse
//
//  Created by 今野暁 on 2017/05/22.
//  Copyright © 2017年 今野暁. All rights reserved.
//

import Foundation

class MouseController:NSObject {
    
    let kDelayUsec : useconds_t = 500000
    var isDown = false
    
    func Move (point: CGPoint){
        let mouseMove = CGEvent.init(mouseEventSource:nil, mouseType:.leftMouseDragged, mouseCursorPosition:point, mouseButton:CGMouseButton.left)
        mouseMove!.post(tap:.cghidEventTap)
        usleep(self.kDelayUsec)
    }
    
    func Down (point: CGPoint){
        let mouseDown = CGEvent.init(mouseEventSource:nil, mouseType:.leftMouseDown, mouseCursorPosition:point, mouseButton:CGMouseButton.left)
        mouseDown!.post(tap:.cghidEventTap)
        usleep(self.kDelayUsec)
        self.isDown = true;
    }
    
    func Up (point: CGPoint){
        let mouseUp = CGEvent.init(mouseEventSource:nil, mouseType:.leftMouseUp, mouseCursorPosition:point, mouseButton:CGMouseButton.left)
        mouseUp!.post(tap:.cghidEventTap)
        usleep(self.kDelayUsec)
        self.isDown = false;
    }

}

