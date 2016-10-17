//
//  CharViewController.swift
//  SocketChat
//
//  Created by user on 14/10/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit
import ActionCableClient

class ChatViewController:UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    var userID:String?
    var UUID:String?
    var messages = [AnyObject]()
    var roomChannel:Channel?
    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var isTypingLabel: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.initialiseChat()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.roomChannel?.unsubscribe()
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
    
        if self.messageTextField.text?.isEmpty == false {
            if let _ = roomChannel {
                
                roomChannel!.action("speak", params:["message":self.messageTextField.text!,"room_id":self.UUID!])
                self.messageTextField.text = ""
            }
            
        }
    }
    
    func initialiseChat() {
        
        var params = NSDictionary()
        params = ["is_group_chat":"false","user_id":userID!,"room_uuid":""]
        
        APIClient.startChatRooms(params, successCallBack: { (response) -> () in
            
            if let _ = response , uuid = response!["uuid"] as? String {
                
                self.UUID = uuid
                if let messages = response!["messages"] as? [
                    AnyObject] {
                        
                        self.messages = messages
                        self.messagesTableView.reloadData()
                        if self.messages.count > 0 {
                            self.messagesTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.messages.count-1, inSection: 0), atScrollPosition: .Bottom, animated: true)
                        }
                }
                self.establishChannelConnection()
            }
            else {
                print("failed UUID")
            }
            }) { (failureMessage) -> () in
                
                print("failed UUID")
        }
        
    }
    
    func establishChannelConnection() {
        roomChannel = SocketIOManager.sharedInstance.rubySocket.create("MessagesChannel",identifier: ["roomId":self.UUID!])
        roomChannel!.onSubscribed = {
            
            print("succesfully subscribed")
        }
       
        roomChannel!.onUnsubscribed = {
            print("unsubscribed channel")
        }
        
        roomChannel!.onRejected = {
            print("channel rejected by server")
        }
        
        roomChannel?.onReceive = {(response,error) in
            print("server is ommunicationg....\(response)")
            self.processServerResponse(response)
        }
        
    }
    
    func processServerResponse(response:AnyObject?) {
        if let _ = response, type = response!["type"] as? String {
            
            if type == "status" {
                self.isTypingLabel.text = "\(response!["user"] as! String) is typing..."
                NSObject.cancelPreviousPerformRequestsWithTarget(self, selector: "clearLabel", object: nil)
                self.performSelector("clearLabel", withObject: nil, afterDelay: 0.5)
            }
            else if type == "message" {
                let dict = ["content": (response!["message"] as! String), "user": (response!["user"] as! String)]
                self.messages.append(dict)
                self.messagesTableView.reloadData()
                self.messagesTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.messages.count-1, inSection: 0), atScrollPosition: .Bottom, animated: true)
             
            }
            
        }
        
    }
    
    func clearLabel() {
        
        self.isTypingLabel.text = ""
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let _ = roomChannel {
            
            roomChannel!.action("typing?", params: ["room_id":self.UUID!])
        }
        
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell") as! ChatCell
        cell.messageLabel.text = messages[indexPath.row]["content"] as? String
        cell.messageDateLabel.text = ""
        if let userId = messages[indexPath.row]["user_id"] as?  Int {
            cell.messageDateLabel.text = "USER ID: \(userId)"
        }
        cell.messageLabel.textAlignment = .Left
        
        return cell
    }
    
    
}
