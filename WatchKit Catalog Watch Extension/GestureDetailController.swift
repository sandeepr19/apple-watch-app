/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This controller demonstrates the various gesture types available in watchOS
 */
import WatchKit
import WatchConnectivity

class GestureDetailController : WKInterfaceController, WCSessionDelegate {
    
    fileprivate let session : WCSession? = WCSession.isSupported() ? WCSession.default() : nil
    @IBOutlet var tapGroup: WKInterfaceGroup!
    @IBOutlet var longPressGroup: WKInterfaceGroup!
    @IBOutlet var swipeGroup: WKInterfaceGroup!
    @IBOutlet var panGroup: WKInterfaceGroup!
    @IBOutlet var tapLabel: WKInterfaceLabel!
    @IBOutlet var longPressLabel: WKInterfaceLabel!
    @IBOutlet var swipeLabel: WKInterfaceLabel!
    @IBOutlet var panLabel: WKInterfaceLabel!
    var timer :Timer!
    var gestureData = ""
    var isLoggingRequired = true

    
    override init() {
        super.init()
        session?.delegate = self
        session?.activate()
    }
    
    @available(watchOS 3.0, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //Dummy Implementation
    }
    
    // Check if message received from iphone app
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        DispatchQueue.main.async {
            if let action = message["action"] as? String {
                // if start button is clicked, initialize the gesture data
                if(action == "start") {
                    if(self.isLoggingRequired){
                        print("Start button clicked by user")
                    }
                    self.gestureData="Start button clicked by user" + "\n"
                }
                // else send the gesture data back to IOS app
                else if (action == "stop"){
                    if(self.isLoggingRequired){
                        print(self.gestureData)
                        print("Stop button clicked by user")
                    }
                    self.gestureData+="Stop button clicked by user" + "\n"
                    // On receiving a stop action, send back gesture data
                    let applicationData = ["gestureData" : self.gestureData]
                    session.sendMessage(applicationData,
                                        replyHandler: { replyData in
                                            print(replyData)
                    }, errorHandler: { error in
                        print(error)
                    })
                }
                
            }
        }
    }
    

    
    @IBAction func tapRecognized(_ sender: AnyObject) {
        //tapGroup.setBackgroundColor(UIColor.black)
        if(isLoggingRequired){
            print("Tap Press")
        }
        gestureData+="TAP Start:"
        appendTimeStamp()
        scheduleReset()
    }
    
    @IBAction func longPressRecognized(_ sender: AnyObject) {
        //longPressGroup.setBackgroundColor(UIColor.black)
        if(isLoggingRequired){
            print("Long Press")
        }
        gestureData+="Long Press Start:"
        appendTimeStamp()
        scheduleReset()
    }
   
    @IBAction func swipeRecognized(_ sender: AnyObject) {
        //swipeGroup.setBackgroundColor(black)
        scheduleReset()
    }
    
    @IBAction func panRecognized(_ sender: AnyObject) {
        if let panGesture = sender as? WKPanGestureRecognizer {
            //panGroup.setBackgroundColor(UIColor.black)
            panLabel.setText("offset: \(NSStringFromCGPoint(panGesture.translationInObject()))")
            if(isLoggingRequired){
                print("Pan Gesture")
            }
            gestureData+="PAN start:"
            appendTimeStamp()
            gestureData+="PAN offset:"+(NSStringFromCGPoint(panGesture.translationInObject())) + "\n"
            scheduleReset()
        }
    }
    
    func scheduleReset() {
        if timer != nil {
            timer.invalidate()
        }
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(resetAllGroups), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: .commonModes)
    }
    
    // rest all individual groups
    func resetAllGroups() {
        gestureData += "End of gesture:"
        if(isLoggingRequired){
            print("Gesture End")
        }
        appendTimeStamp()
        tapGroup.setBackgroundColor(UIColor.clear)
        longPressGroup.setBackgroundColor(UIColor.clear)
        swipeGroup.setBackgroundColor(UIColor.clear)
        panGroup.setBackgroundColor(UIColor.clear)
    }
    
    // append the time stamp to the log statement
    func appendTimeStamp() {
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "y-MM-dd H:m:ss.SSSS"
        gestureData+=df.string(from: d)
        gestureData+="\n"
        //print(df.string(from: d))
    }
    
}
