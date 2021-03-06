//
//  SMShowingHints.swift
//  Catsy
//
//  Created by Christopher Prince on 7/2/15.
//  Copyright (c) 2015 Spastic Muffin, LLC. All rights reserved.
//

// Need to bridge SMFileData from Objective-C

import Foundation

// In subclass, define your hints like the following:

// To have NSCoding work, you have to have a base class derived from NSObject http://stackoverflow.com/questions/25805599/got-unrecognized-selector-replacementobjectforkeyedarchiver-crash-when-impleme
class SMHint : NSObject {
    var name:String = ""
    
    func show() -> Bool {
        return true
    }
}

// A hint shown until some app defined condition.
class SMBoolHint : SMHint, NSCoding {
    var shown:Bool = true
    private var actual:Bool = true
    
    init(name:String, shown:Bool) {
        super.init()
        self.name = name
        self.shown = shown
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
    }

    func set(toValue:Bool) {
        
    }
    
    // Returns the current value of the hint.
    override func show() -> Bool {
        return true
    }
}

// A hint shown for a certain number of times.
class SMCountHint : SMHint, NSCoding {
    var maxToShow:Int = 0
    private var current:Int = 0
    
    init(name:String, maxToShow:Int) {
        super.init()
        self.name = name
        self.maxToShow = maxToShow
    }
    
    @objc required init?(coder aDecoder: NSCoder) {
        super.init()
        
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.maxToShow = aDecoder.decodeObjectForKey("maxToShow") as! Int
        self.current = aDecoder.decodeObjectForKey("current") as! Int
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.maxToShow, forKey: "maxToShow")
        aCoder.encodeObject(self.current, forKey: "current")
    }
    
    // Just checks the maxToShow to see if it's reached. Doesn't alter the number of hints.
    func maxReached() -> Bool {
        let hint = self.getHintForName(self.name)
        SMShowingHints.session.save()
        return hint.current >= hint.maxToShow
    }
    
    func currentCount() -> Int {
        let hint = self.getHintForName(self.name)
        SMShowingHints.session.save()
        return hint.current
    }
    
    // Increments the number of hints shown for this hint name. Returns true, the first maxToShow times (according to that hints initial definition), and false after that.
    override func show() -> Bool {
        var result:Bool = false
        
        let hint = self.getHintForName(self.name)
        if (hint.current < hint.maxToShow) {
            hint.current++
            result = true
        }
        
        SMShowingHints.session.save()
        return result
    }
    
    private func getHintForName(name:String) -> SMCountHint {
        if (nil == SMShowingHints.session.dataDict![self.name]) {
            // This hint is not in the dictionary yet.
            SMShowingHints.session.dataDict![self.name] = self
        }
        else {
            let hint = SMShowingHints.session.dataDict![self.name]
            Assert.If(!(hint is SMCountHint), thenPrintThisString: "Yikes: Didn't get an SMCountHint")
        }
        
        let hint = SMShowingHints.session.dataDict![self.name] as! SMCountHint
        return hint
    }
}

@objc class SMShowingHints : SMFileData {
    // Singleton class.
    static let session = SMShowingHints()
    
    // Running into Swift compiler bugs, so this proved useful.
    private var dataDict:Dictionary<String, SMHint>?
    
    private override init() {
        super.init(fileName: SMIdentifiers.SHOWING_HINTS_FILE)
        
        if (nil == self.data) {
            self.create()
        }
        else {
            self.dataDict = (self.data as! Dictionary<String, SMHint>)
        }
    }
    
    func reset() {
        self.create()
    }
    
    private func create() {
        self.dataDict = Dictionary<String, SMHint>()
        self.data = self.dataDict
        self.save()
    }
    
    override func save() -> Bool {
        self.data = self.dataDict
        return super.save()
    }
}