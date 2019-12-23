//
//  MoreViewController.swift
//  Shaga3 Web
//
//  Created by Kegham Karsian on 12/23/19.
//  Copyright © 2019 Kegham Karsian. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
    
    let users = [User(name: "sherif", uuid: "346grs", signature: "96482ab7d8ba729c942c30d6b144dd7abd5afd4b13ec03d0e0778f9b1ba03d63"), User(name: "ahmed", uuid: "392802", signature: "172cd9ea627801c6c6a6a2d400bbecb26e735a70848f55d799f546c9d090fbcc"), User(name: "mahmoud", uuid: "223909", signature: "e1f66216d409b96bcb851c4f8b3eab6a603af7a62574aef6047bcb84afb90242"), User(name: "micheal", uuid: "244931", signature: "d8c8cbdef6c80f4e0116f48cd83cc03022b3b9340848b86129aaa7374af985af"), User(name: "zaynoun", uuid: "711023", signature: "d0d667f7af2360e9596418a705bba49d0f578e8caf34bb9d55fb181dda1dda7d"), User(name: "amira", uuid: "110110", signature: "46d5b48cb856dab84e09effb89b29c49487fbac4c22726f826af62afa07c9e62"), User(name: "dalia", uuid: "92231", signature: "f79814444c2d4913eab8471987e09603b2a71d0d1582ea1db8cd48938b209b05"), User(name: "baher", uuid: "141416", signature: "c95c3ea452fa8cf560528be6b6b898f32596985a2d97b4941bcb7b34173254ca"), User(name: "magdi", uuid: "283066", signature: "4a88b5d552d5cdf7583836a2984da89a89f017a99e1e19385dcdb9e21e194799"), User(name: "george", uuid: "44449", signature: "8e1177c88031e56d080fe40f63b90b483d518f40ef1702320d1bf0f3f34a8516"), User(name: "barsoum", uuid: "113669", signature: "d2331194a3cb8f2858ec08db277f38dad9dce2fc94450634533722c32b339672"), User(name: "medhat", uuid: "847833", signature: "e8181512d86f9719acdb063cd75185b87723e630a380a08756ade080485be8e9"), User(name: "yassin", uuid: "444999", signature: "96b4db31164b470e7b5f81a88ffb93f2782172f1b1735474e936cce7622912cd"), User(name: "younis", uuid: "293762", signature: "41ce599c9b422691085c5c45e34f78e60e7c7abcd7c09f5ead24324418dd356b"), User(name: "sandra", uuid: "101023", signature: "18653cfc4d8ae4d95d904be2584924bff9b5c568bd69edd02efb8ce76c8ced9f"), User(name: "gohar", uuid: "555788", signature: "e890896cab599bff4042a92c9f14645c0b64468b4420152d14c627d1864dddd2"), User(name: "samira", uuid: "789233", signature: "abde465dcf162c83319909fad665d28593c786d097b771011fab7e441e3fe063"), User(name: "farida", uuid: "223944", signature: "4bb072473be05cf0f1b0f53d8bf1f07b4994f50a707f14cd5baf017ee602797c"), User(name: "rasha", uuid: "433498", signature: "0ad46f96de78b5eeab2b34f4e02ac977440a1e607405fcd44c88cd0aec74a74b"), User(name: "fathy", uuid: "332900", signature: "08c95dd09ccab876d43ab7b88a3f95341caf68387753c3de98bf50415f22a7c8"), User(name: "zayed", uuid: "823334", signature: "bc06b6b0a1acfef9103eef55ee41008b833a61faec36a6f37619cc60a2aa2c6b")].sorted{$0.name < $1.name}

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        Constants.selectedUser = Constants.guest
        tableView.reloadData()
        self.alert(message: "Your are now as GUEST user", title: "LOGGED OUT")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.tintColor = .yellow
        
        //cell.textLabel?.textAlignment = .center
        //cell.detailTextLabel?.textAlignment = .center
        cell.textLabel?.text = users[indexPath.row].name
        cell.detailTextLabel?.text = users[indexPath.row].uuid
        
        let selectedUser = Constants.selectedUser
        print(Constants.selectedUser.name)
        if cell.textLabel?.text == selectedUser.name && cell.detailTextLabel?.text == selectedUser.uuid {
            cell.accessoryType = .checkmark
            cell.isSelected = true
        } else {
            cell.accessoryType = .none
            cell.isSelected = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            
            for row in 0..<tableView.numberOfRows(inSection: indexPath.section) {
                if let cell = tableView.cellForRow(at: IndexPath(row: row, section: indexPath.section)) {
                    cell.accessoryType = row == indexPath.row ? .checkmark : .none
                }
            }
            cell.accessoryType = .checkmark
        }
        
        Constants.selectedUser = users[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    
    
}
