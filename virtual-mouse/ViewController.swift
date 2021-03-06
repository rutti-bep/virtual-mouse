//
//  ViewController.swift
//  virtual-mouse
//
//  Created by 今野暁 on 2017/05/22.
//  Copyright © 2017年 今野暁. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var mouseLocation: CGPoint = .zero;
    let screenSize = NSScreen.main()!.frame;
    let isCatchMouseEvent = false;
    
    override func viewDidAppear() {
        super.viewDidLoad()
        if(isCatchMouseEvent){
            NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
                let mousePoint = NSEvent.mouseLocation();
                self.mouseLocation = CGPoint(x:self.screenSize.maxX-mousePoint.x,y:self.screenSize.maxX-mousePoint.y)
                print(String(format: "%.0f, %.0f", self.mouseLocation.x, self.mouseLocation.y))
                return $0
            }
            NSEvent.addGlobalMonitorForEvents(matching: [.mouseMoved]) { _ in
                self.mouseLocation = NSEvent.mouseLocation()
                print(String(format: "%.0f, %.0f", self.mouseLocation.x, self.mouseLocation.y))
            }
        }
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

