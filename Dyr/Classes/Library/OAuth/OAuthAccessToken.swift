//
//  OAuthAccessToken.swift
//  Dyr
//
//  Created by Pieter Maene on 12/04/15.
//  Copyright (c) 2015 Student IT vzw. All rights reserved.
//

import Foundation
import Lockbox
import SwiftyJSON

enum TokenType: String {
    case Bearer = "bearer"
}

let OAuthKeychainKey: String = "OAuthAccessToken"

class OAuthAccessToken: CustomStringConvertible {
    var accessToken: String
    var expiresAt: NSDate?
    var tokenType: TokenType?
    var refreshToken: String
    
    var description: String {
        return "<OAuthAccessToken accessToken:\(accessToken) expiresAt:\(expiresAt) tokenType:\(tokenType?.rawValue) refreshToken:\(refreshToken)>"
    }
    
    init(json: JSON) {
        accessToken = json["access_token"].stringValue
        expiresAt = NSDate(timeIntervalSinceNow: json["expires_in"].rawValue as! NSTimeInterval)
        tokenType = TokenType(rawValue: json["token_type"].stringValue)!
        refreshToken = json["refresh_token"].stringValue
    }

    func hasExpired() -> Bool {
        if (expiresAt == nil) {
            return true
        }
        
        return expiresAt!.compare(NSDate()) == NSComparisonResult.OrderedAscending;
    }
    
    // MARK: - Keychain
    
    func save() {
        let data: [String: AnyObject] = [
            "accessToken": accessToken,
            "expiresAt": expiresAt!,
            "tokenType": tokenType!.rawValue,
            "refreshToken": refreshToken
        ]
        
        Lockbox.setDictionary(data, forKey: OAuthKeychainKey)
        
        NSLog("[\(NSStringFromClass(self.dynamicType)), \(__FUNCTION__))] Saved to Keychain")
    }
    
    func remove() {
        Lockbox.setDictionary(nil, forKey: OAuthKeychainKey)
    }
    
    init?() {
        accessToken = ""
        expiresAt = nil
        tokenType = nil
        refreshToken = ""
        
        let data: [String: AnyObject]? = Lockbox.dictionaryForKey(OAuthKeychainKey) as? [String: AnyObject]
        if (data != nil) {
            accessToken = data?["accessToken"] as! String
            
            // TODO: This is an ugly fix for Optionals mangling
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "%Y-%M-%d %H:%m:%s %z"
            expiresAt = dateFormatter.dateFromString((data!["expiresAt"] as? String)!)
            
            tokenType = TokenType(rawValue: data?["tokenType"] as! String)
            refreshToken = data?["refreshToken"] as! String
        } else {
            return nil
        }
    }
}
