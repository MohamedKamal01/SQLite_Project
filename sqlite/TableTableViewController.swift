//
//  TableTableViewController.swift
//  sqlite
//
//  Created by Mohamed Kamal on 13/02/2022.
//

import UIKit
import SQLite3
class TableTableViewController: UITableViewController,MyProtocol {

    
    var addView = AddData()
    let db = DBManger.sharedObject
    
    override func viewWillAppear(_ animated: Bool) {
        db.readQuery()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return db.names.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel!.text = db.names[indexPath.row]
        print(db.images[indexPath.row])
        print(db.images[indexPath.row].count)
        let imageData = NSData(contentsOfFile: db.images[indexPath.row])!
        cell.imageView!.image = UIImage(data: imageData as Data)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let showView = storyBoard.instantiateViewController(withIdentifier: "showData") as! ShowData
        self.navigationController?.pushViewController(showView, animated: true)
        showView.nameFriend = db.names[indexPath.row]
        showView.ageFriend = db.ages[indexPath.row]
        showView.phoneFriend = db.phones[indexPath.row]
        let imageData = NSData(contentsOfFile: db.images[indexPath.row])!
        showView.imageViewFriend = UIImage(data: imageData as Data)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        print("Deleted")

          db.deleteQuery(phone: db.phones[indexPath.row])
          db.names.remove(at: indexPath.row)
          db.readQuery()
          
          self.tableView.beginUpdates()
          self.tableView.deleteRows(at: [indexPath], with: .automatic)
          self.tableView.endUpdates()
      }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    @IBAction func addFriend(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        addView = storyBoard.instantiateViewController(withIdentifier: "addData") as! AddData
        self.navigationController?.pushViewController(addView, animated: true)
        addView.p=self
    }
    func add()
    {
        db.insertQuery(name: addView.friendName.text!, phone: addView.friendPhone.text!, image: addView.imagePath!, age: addView.friendAge.text!)
        db.readQuery()
        tableView.reloadData()
        addView.p=self
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
