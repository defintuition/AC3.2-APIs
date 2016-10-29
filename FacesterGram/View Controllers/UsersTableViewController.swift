//
//  UsersTableViewController.swift
//  FacesterGram
//
//  Created by Louis Tur on 10/21/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    // Describe what these three keywords indicate about UserTableViewCellIdentifier
    private static let UserTableViewCellIdentifier: String = "UserTableViewCellIdentifier"
    
    internal var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadUsers()
        self.refreshControl?.addTarget(self, action: #selector(refreshRequested(_:)), for: .valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func loadUsers() {
        // using our "Advanced" solution to get users
        APIRequestManager.manager.getUsers(count: SettingsManager.manager.results,
                                           gender: SettingsManager.manager.gender,
                                           nationality: SettingsManager.manager.nationality) { (data: Data?) in
                                            if data != nil {
                                                
                                                if let users = User.users(from: data!) {
                                                    print("We've got users! \(users)")
                                                    
                                                    self.users = users
                                                    
                                                    
                                                    DispatchQueue.main.async {
                                                        self.tableView.reloadData()
                                                    }
                                                }
                                            }
                                            self.refreshControl?.endRefreshing()
                                            
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UsersTableViewController.UserTableViewCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = "\(self.users[indexPath.row].firstName) \(self.users[indexPath.row].lastName)"
        cell.detailTextLabel?.text = self.users[indexPath.row].username
        
        return cell
    }
    
    // MARK: - Refresh Control
    func refreshRequested(_ sender: UIRefreshControl) {
        self.loadUsers()
    }
    
}
