//
//  MessageTableViewController.swift
//  BulletinBoardCloudKit
//
//  Created by Xavier on 11/5/18.
//  Copyright © 2018 Xavier ios dev. All rights reserved.
//

import UIKit

class MessageTableViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add ourself as an obsrver of the remoteNotificationRecieved notification
        //The selcetor is what gets called when we recieve the notification
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMessages), name: AppDelegate.remoteNotificationReceived, object: nil)
        refreshMessages()
    }
    
     @objc func refreshMessages() {
        MessageController.shared.fetchAllMessages { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    //MARK: - Actions
    @IBAction func postButtonTapped(_ sender: UIButton) {
        guard let messageText = messageTextField.text, !messageText.isEmpty else { return }
        
        messageTextField.resignFirstResponder()
        messageTextField.text = ""
        
        MessageController.shared.saveNewMessageWith(text: messageText) { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MessageController.shared.messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        
        //Grab the message from the messageController and get the specific index for w.e cell the user taps on.
        let message = MessageController.shared.messages[indexPath.row]
        cell.textLabel?.text = message.text
        cell.detailTextLabel?.text = message.timestampAsString
        

        // Configure the cell...

        return cell
    }

}
