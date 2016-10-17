//
//  ViewController.swift
//  SocketChat
//
//  Created by user on 12/10/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var nickName = ""
    var users = [[String:AnyObject]]()

    @IBOutlet weak var usersTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.getUsersList()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
       
    }

    @IBAction func logoutUser(sender: AnyObject) {
       
           
        SocketIOManager.sharedInstance.closeConnection()
       
        
    }
    func getUsersList() {
       
       APIClient.getUsersList({ (response) -> () in
        
        if let _ = response {
            
            if let usersArray = response!["users"] as? [[String:
            AnyObject]]{
                
                self.users = usersArray
                self.usersTableView.reloadData()
            }
            
        }
        
        }) { (failureMessage) -> () in
            
            print("error fetching users")
          
        }
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellUser", forIndexPath: indexPath) as! UserCell
        
        cell.nameLabel?.text = String(indexPath.row + 1)
        cell.statusTextLabel?.text = users[indexPath.row]["email"] as? String
        
        cell.selectionStyle = .None
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("chatVC", sender: indexPath.row)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "chatVC" {
            if let chatVC = segue.destinationViewController as? ChatViewController {
                
                chatVC.userID = String(self.users[sender as! Int]["id"] as! Int)
                
                
            }
            
            
        }
    }
    
}

