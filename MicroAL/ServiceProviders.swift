//
//  ServiceProviders.swift
//  MicroAL
//
//  Created by Christopher Prince on 5/5/16.
//  Copyright © 2016 Spastic Muffin, LLC. All rights reserved.
//

// Download Service Providers from the server API.

import Foundation
import SMCoreLib

class ServiceProviders : NSObject {
    static let session = ServiceProviders()
    
    private let manager = AFHTTPSessionManager()
    private let serverURL = NSURL(string: "http://private-f9668b-ioscoding.apiary-mock.com/angieslist/codingChallenge/serviceproviders")!
    
    private override init() {
        // http://stackoverflow.com/questions/26604911/afnetworking-2-0-parameter-encoding
        self.manager.responseSerializer = AFJSONResponseSerializer()
    }
    
    // Uses AFNetworking to get the Service Providers from the server. On successful completion, creates ServiceProvider NSManagedObjects as appropriate.
    func download(completion:(NSError?)->()) {
        
        self.manager.GET(self.serverURL.absoluteString, parameters: nil, progress: nil,
            success: { (request:NSURLSessionDataTask, response:AnyObject?) in
                var errorMessage:String?
                
                if let mainDict = response as? [String:AnyObject] {
                    if let responseDicts = mainDict["serviceproviders"] as? [[String:AnyObject]] {
                        for responseDict in responseDicts {
                            //Log.msg("AFNetworking Success: \(responseDict)")
                            if let newServiceProvider = ServiceProvider.newObjectFromDictionary(responseDict) {
                                Log.msg("\(newServiceProvider)")
                            }
                            else {
                                errorMessage = "Failed creating ServiceProvider object"
                                break
                            }
                        }
                    }
                    else {
                        errorMessage = "No nested array of dictionaries given in response"
                    }
                }
                else {
                    errorMessage = "No dictionary given in response"
                }
                
                var error:NSError?
                if nil == errorMessage {
                    
                }
                else {
                    error = NSError(domain:"", code: 0, userInfo: [NSLocalizedDescriptionKey:errorMessage!])
                }
                
                completion(error)
            },
            failure: { (request:NSURLSessionDataTask?, error:NSError) in
                NSLog("**** AFNetworking FAILURE: \(error)")
                completion(error)
            })    
    }
}
