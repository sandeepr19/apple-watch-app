

import UIKit

class ParticipantTableViewController: UITableViewController {
    
    var participants = ["Participant 1", "Participant 2", "Participant 3", "Participant 4" ,
                  "Participant 5", "Participant 6", "Participant 7", "Participant 8" ,
                  "Participant 9", "Participant 10", "Participant 11", "Participant 12" ,
                  "Participant 13", "Participant 14"]
    
    var previousRowValue:String!
    var selectedRowValue:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = participants[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowValue = participants[indexPath.row]
        performSegue(withIdentifier: "gestureSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gestureSegue") {
            let vc = segue.destination as! GestureTableViewController            
            vc.previousRowValue = previousRowValue+"|"+selectedRowValue;
        }
    }

    
    
}
