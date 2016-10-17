//
//  MobomoAPIClient.swift
//  PockitShip
//
//  Created by Adarsh M on 01/02/16.
//  Copyright © 2015 Mobomo LLC. All rights reserved.
//

import Foundation
import Alamofire

typealias APIClientResponseCallBack = (statusCode: Int?, response : AnyObject?, error : NSError?) -> ()


public class MobomoAPIClient {
    
    static let client = MobomoAPIClient()
    
    struct HTTPStatusCode {
        
        static let Success = 200
        static let Failure = 400
        static let NotFound = 404
        static let InternalServerError = 500
    }
    
    private let baseUrl = "http://10.2.0.116:3000/"
    
    func requestHeader() -> [String : String] {
        
        var headers : [String : String] = [String : String]()
        
        headers["Accept-Version"] = "1.0"
        headers["Content-Type"] = "application/json"
        
        if let token = (UIApplication.sharedApplication().delegate as! AppDelegate).userToken where token != ""{
            headers["Authorization"] = "Token token=\(token)"
           
        }
        /*
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if(appDelegate.isLoggedIn) {
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            
            let token = userDefaults.objectForKey(PSConstants.Authentication.Token) as? String ?? String()
            let email = userDefaults.objectForKey(PSConstants.Authentication.Email) as? String ?? String()
            
            headers["Authorization"] = "Token token=" + token + ", email=" + email
        }
        */
        
        return headers;
    }
    
    func urlStringWithService (service : String!) -> String {
        
        return "\(baseUrl)\(service)"
    }
    
    func makePOSTRequest (service : String!, parameters : [String: AnyObject]? = nil,  responseCallBack : APIClientResponseCallBack!) {
        
        self.sendRequest(.POST, service: service, parameters: parameters, encoding:.JSON, responseCallBack: responseCallBack);
    }
    
    func makePUTRequest(service : String!, parameters : [String: AnyObject]? = nil, headers: [String: String]? = nil, responseCallBack: APIClientResponseCallBack!) {
        
        self.sendRequest(.PUT, service: service, parameters: parameters, encoding:.JSON, responseCallBack: responseCallBack);
    }
    
    func makeGETRequest (service : String!, parameters : [String: AnyObject]? = nil,  responseCallBack : APIClientResponseCallBack!) {
        
        self.sendRequest(.GET, service: service, parameters: parameters, encoding:.URLEncodedInURL, responseCallBack: responseCallBack);
    }
    
    func makeDELETERequest(service : String!, parameters : [String: AnyObject]? = nil, headers: [String: String]? = nil, responseCallBack: APIClientResponseCallBack!) {
        
        self.sendRequest(.DELETE, service: service, parameters: parameters, encoding:.JSON, responseCallBack: responseCallBack);
    }
    
    private func sendRequest (method: Alamofire.Method, service : String!, parameters : [String: AnyObject]? = nil, encoding: ParameterEncoding, responseCallBack : APIClientResponseCallBack!) {
        
        let headers = self.requestHeader();
        let urlString = self.urlStringWithService(service)

        Alamofire.request(method, urlString, parameters: parameters, encoding: encoding, headers: headers)
            .responseJSON { (responseObj) -> Void in
                responseCallBack(statusCode: responseObj.response?.statusCode, response: responseObj.result.value, error: responseObj.result.error)
        }
    }
    
    func makePostRequestForUploadingImage (service : String!, imageData : NSData?, itemID:String  ,orderBy : Int,responseCallBack : APIClientResponseCallBack!) {
        
        let headers = self.requestHeader();
        
        let urlString = self.urlStringWithService(service)
        let order_by = String(orderBy)
        
        Alamofire.upload(
            .POST,urlString , headers : headers ,
            multipartFormData: { multipartFormData in
                
                if let _  = imageData  {
                    multipartFormData.appendBodyPart(
                        data: imageData!,
                        name: "image[image]",
                        fileName: "avatar.png",
                        mimeType: "image/jpg"
                    )
                    multipartFormData.appendBodyPart(
                        data: itemID.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!,
                        name: "image[line_item_unique_id]"
                    )
                    multipartFormData.appendBodyPart(
                        data: order_by.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!,
                        name: "image[order_by]"
                    )
                    
                }
            },
            encodingCompletion: { encodingResult in
                
                switch encodingResult {
                    
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        responseCallBack(statusCode: response.response?.statusCode,response: response.result.value , error: response.result.error)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
    
    func responseErrorMessage(statusCode: Int?, response : AnyObject?, error : NSError?) -> String? {
        
        if(error != nil) {
            return error?.localizedDescription;
        }
        else {
            return "Error"
        }
    }    
}