
import UIKit

class GestureTableViewController: UITableViewController {
    
    var previousRowValue:String!
    var selectedRowValue:String!
    
    var gestures = ["1. Previous Page (Horizontal)", "2. Next Page (Horizontal)", "3. Move down in hierarchy (Vertical)", "4. Move up in hierarchy (Vertical)" ,
                        "5. Go to Home Screen", "6. Zoom In", "7. Zoom Out", "8. Select" , "9. Cancel", "10. Cut", "11. Copy", "12. Paste" , "13. Dismiss Notification", "14. View notification"]

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
        return gestures.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = gestures[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRowValue = gestures[indexPath.row]
        performSegue(withIdentifier: "countSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "countSegue") {
            let vc = segue.destination as! CountTableViewController
            vc.previousRowValue = previousRowValue+"|"+selectedRowValue;
        }
    }

}
