

import UIKit

class CountTableViewController: UITableViewController {
    
    var previousRowValue:String!
    var selectedRowValue:String!
    
    var iterations = ["Trial 1", "Trial 2", "Trial 3"]

    var buttonData = ["US","China","London","Canada","Japan"];

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iterations.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = iterations[indexPath.row]
        
        let startButton = UIButton(frame: CGRect(x: 200, y: 5, width: 40, height: 30))
        startButton.backgroundColor = UIColor.black
        startButton.setTitleColor(UIColor.white, for: .normal)
        startButton.setTitle("Start", for: UIControlState.normal)
        startButton.titleLabel!.font =  UIFont(name: "HelveticaNeue-Thin", size: 15)
        cell.contentView.addSubview(startButton)
        
        
        
        let stopButton = UIButton(frame: CGRect(x: 250, y: 5, width: 40, height: 30))
        stopButton.backgroundColor = UIColor.black
        stopButton.setTitleColor(UIColor.white, for: .normal)
        stopButton.setTitle("Stop", for: UIControlState.normal);
        stopButton.titleLabel!.font =  UIFont(name: "HelveticaNeue-Thin", size: 15)
        cell.contentView.addSubview(stopButton)

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowValue = iterations[indexPath.row]
        let vc = LandingPageViewController(data: previousRowValue+"|"+selectedRowValue);
        self.navigationController?.pushViewController(vc, animated: true);
    }

    
}
