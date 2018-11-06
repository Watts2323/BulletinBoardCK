//
//  Message.swift
//  BulletinBoardCloudKit
//
//  Created by Xavier on 11/5/18.
//  Copyright © 2018 Xavier ios dev. All rights reserved.
//

import Foundation
import CloudKit

//Model Object, CloudKit would't understand or recognize our message class so we have to turn it into something that cloudkit can understand which is a CKRecord
class Message {
    
    //Constants
    let text: String
    let timestamp: Date
    
    //Made it static so we can call it directly on the type
    static let messageTypeKey = "Message"
    fileprivate static let textKey = "Text"
    fileprivate static let timestampKey = "Timestamp"
    
    var timestampAsString: String {
        return DateFormatter.localizedString(from: timestamp, dateStyle: .short, timeStyle: .short)
    }
    
    //This will get called when the user actually saves a post
    init(text: String) {
        self.text = text
        self.timestamp = Date()
    }
    
    //Creating a model Object from a cKRecord -- fetch
    init?(ckRecord:CKRecord) {
        //UNpack the values that I want from the CKRecord, pulling the values out, essentially the same thing we do with dictionaries because a CKRecord is just a glorified dictionary. Also they lose their type so we have to cast them to w.e they are.
        guard let text = ckRecord[Message.textKey] as? String,
            let timestamp = ckRecord[Message.timestampKey] as? Date else { return nil}
        
        //Set those values as my intial values for my new instance
        self.text = text
        self.timestamp = timestamp
        
    }
}

//Here we are turning it into a CKRecord that will eventually be turned into a dictionary that gets sent to the server.
//Create a CKRecord using our model Object -- Push
extension CKRecord {
    
    convenience init(message: Message) {
        //Creating an Instance of CKRecord.
        self.init(recordType: Message.messageTypeKey)
        self.setValue(message.text, forKey: Message.textKey)
        self.setValue(message.timestamp, forKey: Message.timestampKey)
        
    }
}
