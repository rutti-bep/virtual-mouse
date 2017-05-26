//
//  AppDelegate.swift
//  virtual-mouse
//
//  Created by 今野暁 on 2017/05/22.
//  Copyright © 2017年 今野暁. All rights reserved.
//

import Cocoa
import AppKit
import AVFoundation
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window:NSWindow?;
    
    let viewController = ViewController()
    var InputFieldX = NSTextField();
    var InputFieldY = NSTextField();
    var InputFieldRandomX = NSTextField();
    var InputFieldRandomY = NSTextField();
    var clickButton = SuperButton();
    var doubleClickButton = SuperButton();
    var moveButton = SuperButton();
    
    let mouseController = MouseController();
    
    func move(){
        guard let x = Int(InputFieldX.stringValue) else {
            return;
        }
        guard let y = Int(InputFieldY.stringValue) else {
            return;
        }
        guard let randomX = Int(InputFieldRandomX.stringValue) else {
            return;
        }
        guard let randomY = Int(InputFieldRandomY.stringValue) else {
            return;
        }
        mouseController.Move(frame: NSRect(x:x,y:y,width:randomX,height:randomY));
        
        if(doubleClickButton.state == 1){
            mouseController.doubleClick(point: CGPoint(x:x,y:y));
        }else if(clickButton.state == 1){
            mouseController.click(point: CGPoint(x:x,y:y));
        }
        
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        window = NSWindow(contentRect: NSRect(x:NSScreen.main()!.frame.midX,y:NSScreen.main()!.frame.midY,width:400,height:400), styleMask: [.closable,.titled], backing: NSBackingStoreType.buffered, defer:false)
        window!.acceptsMouseMovedEvents = true
        window!.title = "virtual-mouse"
        //window!.isOpaque = false
        //window!.styleMask.insert(.fullSizeContentView)
        window!.center()
        window!.isMovableByWindowBackground = true
        //window!.backgroundColor = NSColor(calibratedHue: 0, saturation: 1.0, brightness: 0.5, alpha: 0.7)
        window!.makeKeyAndOrderFront(nil)
        
        viewController.view = NSView(frame: NSMakeRect(0, 0, window!.frame.size.width, window!.frame.size.height));
        viewController.view.wantsLayer = true
        viewController.view.layer?.backgroundColor = NSColor.red.cgColor
        window!.contentView?.addSubview(viewController.view);
        
        InputFieldX.frame = NSRect(x:10,y:window!.frame.minY,width:50,height:20);
        InputFieldX.placeholderString = "x";
        viewController.view.addSubview(InputFieldX);
        
        InputFieldY.frame = NSRect(x:70,y:window!.frame.minY,width:50,height:20);
        InputFieldY.placeholderString = "y"
        viewController.view.addSubview(InputFieldY);
        
        InputFieldRandomX.frame = NSRect(x:10,y:window!.frame.minY-20,width:50,height:20);
        InputFieldRandomX.placeholderString = "randomX";
        viewController.view.addSubview(InputFieldRandomX);
        
        InputFieldRandomY.frame = NSRect(x:70,y:window!.frame.minY-20,width:50,height:20);
        InputFieldRandomY.placeholderString = "randomY";
        viewController.view.addSubview(InputFieldRandomY);
        
        clickButton.create(title: "click?",x:130,y:window!.frame.minY,width: 50,height: 20);
        clickButton.setButtonType(NSSwitchButton)
        viewController.view.addSubview(clickButton)
        
        doubleClickButton.create(title: "double?",x:190,y:window!.frame.minY,width: 50,height: 20);
        doubleClickButton.setButtonType(NSSwitchButton)
        viewController.view.addSubview(doubleClickButton)
        
        moveButton.create(title: "move", x: 250, y:window!.frame.minY, width: 50, height: 20, action: #selector(AppDelegate.move))
        viewController.view.addSubview(moveButton)
        
        
        //window!.contentView?.addSubview(viewController.viewController.view)
        
        //mouseController.Move(point: CGPoint(x:0,y:100))
       
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // MARK: - Core Data stack

    var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "virtual_mouse")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving and Undo support

    @IBAction func saveAction(_ sender: AnyObject?) {
        // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
        let context = persistentContainer.viewContext

        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
        }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Customize this code block to include application-specific recovery steps.
                let nserror = error as NSError
                NSApplication.shared().presentError(nserror)
            }
        }
    }

    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
        return persistentContainer.viewContext.undoManager
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplicationTerminateReply {
        // Save changes in the application's managed object context before the application terminates.
        let context = persistentContainer.viewContext
        
        if !context.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }
        
        if !context.hasChanges {
            return .terminateNow
        }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError

            // Customize this code block to include application-specific recovery steps.
            let result = sender.presentError(nserror)
            if (result) {
                return .terminateCancel
            }
            
            let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
            let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
            let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
            let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
            let alert = NSAlert()
            alert.messageText = question
            alert.informativeText = info
            alert.addButton(withTitle: quitButton)
            alert.addButton(withTitle: cancelButton)
            
            let answer = alert.runModal()
            if answer == NSAlertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }

}

