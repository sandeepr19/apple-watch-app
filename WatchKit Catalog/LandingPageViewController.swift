
import UIKit
import WatchConnectivity
import MessageUI
import Foundation

class LandingPageViewController: UIViewController, WCSessionDelegate, MFMailComposeViewControllerDelegate {

    
    fileprivate let session : WCSession? = WCSession.isSupported() ? WCSession.default() : nil
    var participantIdentifier:String!
    
    init(data: String) {
        super.init(nibName: nil, bundle: nil)
        self.participantIdentifier = data
        configureWCSession()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        configureWCSession()
    }
    
    fileprivate func configureWCSession() {
        session?.delegate = self;
        session?.activate()
    }

    // Initialize the "start" and "stop" buttons
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startButton = UIButton(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        startButton.backgroundColor = UIColor.white
        startButton.setTitleColor(UIColor.black, for: .normal)
        startButton.setTitle("Start", for: UIControlState.normal)
        startButton.addTarget(self, action: #selector(startButtonAction), for: UIControlEvents.touchUpInside)
        self.view.addSubview(startButton)
        
        
        let stopButton = UIButton(frame: CGRect(x: 200, y: 100, width: 50, height: 50))
        stopButton.backgroundColor = UIColor.white
        stopButton.setTitleColor(UIColor.black, for: .normal)
        stopButton.setTitle("Stop", for: UIControlState.normal);
        stopButton.addTarget(self, action: #selector(stopButtonAction), for: UIControlEvents.touchUpInside)
        self.view.addSubview(stopButton)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func stopButtonAction(sender: UIButton!) {
        
        // label to indicate which button was clicked
        let label = UILabel(frame: CGRect(x: 100, y: 200, width: 150, height: 50))
        label.center = CGPoint(x: self.view.center.x+12, y: self.view.center.y)
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = "stop clicked"
        self.view.addSubview(label)
        
        /*
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["sgamjee5@gmail.com"])
        composeVC.setSubject("Hello!")
        composeVC.setMessageBody("Hello this is my message body!", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
        */
        
        let fileManager = FileManager.default
        
        do {
            let resourceKeys : [URLResourceKey] = [.creationDateKey, .isDirectoryKey]
            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let enumerator = FileManager.default.enumerator(at: documentsURL,
                                                            includingPropertiesForKeys: resourceKeys,
                                                            options: [.skipsHiddenFiles], errorHandler: { (url, error) -> Bool in
                                                                print("directoryEnumerator error at \(url): ", error)
                                                                return true
            })!
            
            for case let fileURL as URL in enumerator {
                _ = try fileURL.resourceValues(forKeys: Set(resourceKeys))
                print(fileURL.path)
                let text = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
                print(text)
            }
        } catch {
            print(error)
        }
        
        // Send action name to the apple watch
        let applicationData = ["action" : "stop"]
        if let session = session, session.isReachable {
            session.sendMessage(applicationData,
                                replyHandler: { replyData in
                                    // handle reply from iPhone app here
            }, errorHandler: { error in
                // catch any errors here
                print(error)
            })
        } else {
            // when the iPhone is not connected via Bluetooth
        }
    }
    
    func startButtonAction(sender: UIButton!) {
        
        // label to indicate which button was clicked
        let label = UILabel(frame: CGRect(x: 100, y: 200, width: 150, height: 50))
        label.center = CGPoint(x: self.view.center.x+12, y: self.view.center.y)
        label.backgroundColor = UIColor.white
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.text = "start clicked"
        self.view.addSubview(label)
        
        // Send action name to the apple watch
        let applicationData = ["action" : "start"]
        if let session = session, session.isReachable {
            session.sendMessage(applicationData,
                                replyHandler: { replyData in                
                                    print(replyData)
            }, errorHandler: { error in
                // catch any errors here
                print(error)
            })
        } else {
            // when the iPhone is not connected via Bluetooth
        }
    }
    
    /** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
    @available(iOS 9.3, *)
    public func sessionDidDeactivate(_ session: WCSession) {
        //Dummy Implementation
    }
    
    /** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed. */
    @available(iOS 9.3, *)
    public func sessionDidBecomeInactive(_ session: WCSession) {
        //Dummy Implementation
    }
    
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(iOS 9.3, *)
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //Dummy Implementation
    }
    
    // Receive Gesture Data
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            if let value = message["gestureData"] as? String {
                self.redirectLogToDocuments()
                NSLog("\n"+self.participantIdentifier+"\n"+value)
            }
        }
    }
    
    // logging =>Note the additional parameter added in Info.pslist
    func redirectLogToDocuments() {
        let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = allPaths.first!
        
        // Creating a file with time stamp and name of the action
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "y-MM-dd H:m"
        //let pathForLog = documentsDirectory + "/log_"+participantIdentifier+"_"+df.string(from: d +".txt"
        let pathForLog = documentsDirectory + "/log.txt"
 
        //let pathForLog = documentsDirectory + "/log_"+participantIdentifier+".txt"
        freopen(pathForLog, "a+", stderr)
        freopen(pathForLog, "a+", stdin)
        freopen(pathForLog, "a+", stdout)
    }

}
