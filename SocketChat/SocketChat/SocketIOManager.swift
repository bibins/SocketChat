//
//  SocketIOManager.swift
//  SocketChat
//
//  Created by user on 12/10/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation
import ActionCableClient


class SocketIOManager : NSObject {
    static let sharedInstance = SocketIOManager()
    
    var socket = SocketIOClient(socketURL: NSURL(string: "ws://10.2.0.116:3000/cable")!)
    var rubySocket = ActionCableClient(URL: NSURL(string: "ws://10.2.0.116:3000/cable")!)
    
    override init() {
        super.init()
        
        
        rubySocket.origin = "http://10.2.0.116:3000"
        rubySocket.onConnected = {
            
            print("Connected")
        }
        
        
        rubySocket.onDisconnected = {(error) in
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userToken")
            NSUserDefaults.standardUserDefaults().synchronize()
            (UIApplication.sharedApplication().delegate as! AppDelegate).userToken = nil
            (UIApplication.sharedApplication().delegate as! AppDelegate).showLoginScreen()
            
            print("disconnected..error\(error)")
        }

    }
    
    func establishConnection(){
    
        
        rubySocket.headers = ["AuthenticationToken": (UIApplication.sharedApplication().delegate as! AppDelegate).userToken!]
        rubySocket.connect()
        
    
    }
    
    func closeConnection() {
//        socket.disconnect()
        rubySocket.disconnect()
        
    }
    
    func connectToServerWithNickname(nickname: String, completionHandler: (userList: [[String: AnyObject]]!) -> Void) {
        
//        socket.emit("connectUser", nickname)
//        socket.on("userList") { ( dataArray, ack) -> Void in
//            completionHandler(userList: dataArray[0] as! [[String: AnyObject]])
//        }
        
    }
    
    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
//        socket.emit("exitUser", nickname)
        completionHandler()
    }
    
    func sendMessage(message: String, withNickname nickname: String) {
//        socket.emit("chatMessage", nickname, message)
    }
    
    func getChatMessage(completionHandler: (messageInfo: [String: AnyObject]) -> Void) {
//        socket.on("newChatMessage") { (dataArray, socketAck) -> Void in
//            var messageDictionary = [String: AnyObject]()
//            messageDictionary["nickname"] = dataArray[0] as! String
//            messageDictionary["message"] = dataArray[1] as! String
//            messageDictionary["date"] = dataArray[2] as! String
//            
//            completionHandler(messageInfo: messageDictionary)
//        }
    }
}
