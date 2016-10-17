//
//  APIClient.swift
//  PockitShip
//
//  Created by Adarsh M on 01/02/16.
//  Copyright © 2015 Mobomo LLC. All rights reserved.
//

import Foundation

typealias APISuccessCallBack = (response:AnyObject?) -> ()
typealias APIFailureCallBack = (failureMessage : String?) -> ()

class APIClient: MobomoAPIClient {
    
    static let login = "users/sign_in.json"
    static let getUsers = "api/v1/users.json"
    static let userChat = "api/v1/chat_rooms.json"
    
    struct ResponseStatusCode {
        
        static let Success = 200
        static let Failure = 400
    }
    
    static func loginAPI (parameters: NSDictionary,successCallBack: APISuccessCallBack?, failureCallBack: APIFailureCallBack) {
        
        client.makePOSTRequest(login, parameters: (parameters as! [String : AnyObject])) { (statusCode, response, error) -> () in
            
            if statusCode == MobomoAPIClient.HTTPStatusCode.Success {
                
                successCallBack?(response: response)
            }
            else {
                failureCallBack(failureMessage: client.responseErrorMessage(statusCode, response: response, error: error))
            }
        }
    }
    
    static func getUsersList(successCallBack: APISuccessCallBack?, failureCallBack: APIFailureCallBack) {
        
        
        client.makeGETRequest(getUsers) { (statusCode, response, error) -> () in
            
            if statusCode == MobomoAPIClient.HTTPStatusCode.Success {
                
                successCallBack?(response: response)
            }
            else {
                failureCallBack(failureMessage: client.responseErrorMessage(statusCode, response: response, error: error))
            }
        }
    }
    
    static func startChatRooms(parameters: NSDictionary,successCallBack: APISuccessCallBack?, failureCallBack: APIFailureCallBack) {
        
        client.makePOSTRequest(userChat, parameters: (parameters as! [String : AnyObject])) { (statusCode, response, error) -> () in
            
            if statusCode == MobomoAPIClient.HTTPStatusCode.Success {
                
                successCallBack?(response: response)
            }
            else {
                failureCallBack(failureMessage: client.responseErrorMessage(statusCode, response: response, error: error))
            }
        }
    }
}
