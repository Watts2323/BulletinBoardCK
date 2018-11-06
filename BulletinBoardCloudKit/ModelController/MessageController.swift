//
//  MessageController.swift
//  BulletinBoardCloudKit
//
//  Created by Xavier on 11/5/18.
//  Copyright © 2018 Xavier ios dev. All rights reserved.
//

import Foundation
import CloudKit
import UserNotifications

class MessageController {
    
    //Shared instance
    static let shared = MessageController()
    
    //Source Of Truth
    var messages: [Message] = []
    
    //Creating an instance of Public database
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
    //Create a function to save a new message
    func saveNewMessageWith(text: String, completion: @escaping (Bool) -> Void) {
        
        //Create a new instance of message
        let newMessage = Message(text: text)
        
        //Bundle up our message so that we can save it to the database
        //Cr3ating a ckrecord based off of line 23, Apples server with cloudkit accepts CKRecords
        let messageAsRecord = CKRecord(message: newMessage)
        
        publicDatabase.save(messageAsRecord) { (_, error) in
            if let error = error {
                print("There was an error in \(#function) ; \(error) ; \(error.localizedDescription) ")
                completion(false);return
            }
            self.messages.append(newMessage)
            completion(true)
        }
    }
    
    func fetchAllMessages(completion: @escaping (Bool) -> Void) {
        
        //Used to pull every record, or every message from the database
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: Message.messageTypeKey, predicate: predicate)
        
        
        publicDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("There was an error in \(#function) ; \(error) ; \(error.localizedDescription) ")
                completion(false);return
            }
            guard let records = records else { completion(false) ; return }
            
            var messagesFromFetch: [Message] = []
            
            for record in records {
                guard let message = Message(ckRecord: record) else { completion(false) ; return}
                messagesFromFetch.append(message)
            }
            
            //setting the source of truth the array that we just created from our fetch
            self.messages = messagesFromFetch
            completion(true)
        }
        
    }
    
}
