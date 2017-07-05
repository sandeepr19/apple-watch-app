

import UIKit

class MotorImpairmentTableViewController: UITableViewController {
    
    var motorImpairmentOptions = ["With MI", "Not MI", "Test"]
    var selectedRowValue:String!

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
        return motorImpairmentOptions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        let optionName = motorImpairmentOptions[indexPath.row]
        cell.textLabel?.text = optionName                
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowValue = motorImpairmentOptions[indexPath.row]
        performSegue(withIdentifier: "participantSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "participantSegue") {
            let vc = segue.destination as! ParticipantTableViewController            
            vc.previousRowValue = selectedRowValue;
        }
    }


}
