//
//  ViewController.swift
//  custom-ui-ios
//
//  Created by Anastasi Bakolias on 2018-01-17.
//  Copyright © 2018 Anastasi Bakolias. All rights reserved.
//

import UIKit
import Smooch

class ViewController: UIViewController, UITableViewDataSource, SKTConversationDelegate {
    @IBOutlet weak var conversationHistory: UITableView!
    @IBOutlet weak var messageInput: UITextField!
    
    @objc func endOfInput(){
        messageInput.resignFirstResponder()
        let text = messageInput.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.count > 0 {
            Smooch.conversation()?.sendMessage(SKTMessage(text: text))
        }
        messageInput.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageInput.addTarget(self, action: #selector(endOfInput), for: .editingDidEndOnExit)
        conversationHistory.tableFooterView = UIView()
        conversationHistory.dataSource = self
        conversationHistory.register(UITableViewCell.self, forCellReuseIdentifier: "MessageCell")
        if let messages = Smooch.conversation()?.messages {
            self.items = messages
        }
        Smooch.conversation()?.delegate = self
    }
    
    var items: [Any] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        
        let message = items[indexPath.row] as! SKTMessage
        let text = message.role == "appMaker" ? "\(message.name!) says \(message.text!)" : message.text!

        cell.textLabel!.text = text
        return cell
    }
    
    func conversation(_ conversation: SKTConversation, willSend message: SKTMessage) -> SKTMessage {
        self.items.append(message)
        conversationHistory.reloadData()
        return message
    }
    
    func conversation(_ conversation: SKTConversation, didReceiveMessages messages: [Any]) {
        if let allMessages = Smooch.conversation()?.messages {
            self.items = allMessages
        }
        
        conversationHistory.reloadData()
    }
}

