//
//  SearchTableViewController.swift
//
//
//  Created by Navjot Bola on 5/13/17.
//
//

import UIKit
import Firebase
import FirebaseDatabase

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    var loggedInUser: FIRUser?
    struct Objects {
        var sectionName: String!
        var sectionObjects: [String]!
        var cost: [String]!
        var email: String!
        //var id: String!
    }
    let searchController = UISearchController(searchResultsController: nil)
    var usersArray = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
    var skillsArray = [NSDictionary?]()
    var skillsDict = [String: NSDictionary]()
    @IBOutlet var resultsTableView: UITableView!
    var databaseRef = FIRDatabase.database().reference()
    var theSkills = [String: Int]()
    var objectsArray = [Objects]()
    var tempObjectsArray = [Objects]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        databaseRef.child("Profile").queryOrdered(byChild: "Skills").observe(.value, with: {(snapshot) in
            var count = 0;
            for test in snapshot.children.allObjects
            {
                // Make each one a snapshot
                let snap = test as! FIRDataSnapshot
                // Extract the fields
                if let children = snap.value as? [String: AnyObject]
                {
                    let name = children["Name"] as! String
                    let email = children["Email ID"] as! String
                    if let skillsArray = children["Skills"] as? NSDictionary {
                        self.theSkills = skillsArray as! [String : Int]
                        let lazyMapCollection = self.theSkills.keys
                        let stringArray = Array(lazyMapCollection)
                        
                        let lazyMapCollection2 = self.theSkills.values
                        let stringArray2 = Array(lazyMapCollection2)
                        var stringArray3 = stringArray2.map
                            { 
                                String($0)
                            }
                        self.objectsArray.append(Objects(sectionName: name, sectionObjects: stringArray, cost: stringArray3, email: email))
                        print(skillsArray)
                        print("-------")
                        for(key, element) in skillsArray {
                            count = count+1
                            print(key)
                            print(element)
                        }
                        print("-------")
                        self.skillsArray.append(skillsArray)
                        self.skillsDict[name] = skillsArray
                        for aSkill in skillsArray{
                            print(aSkill)
                        }
                    }
                    print(self.objectsArray)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

                }
            }
        })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return objectsArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return objectsArray[section].sectionObjects.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectsArray[section].sectionName
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell!
        
        // Configure the cell here
        cell?.textLabel?.text = objectsArray[indexPath.section].sectionObjects[indexPath.row]
        cell?.detailTextLabel?.text = objectsArray[indexPath.section].cost[indexPath.row]
        
        return cell!
    }
    
 
    
    func updateSearchResults(for searchController: UISearchController) {
        print("starting search 2...")
        //update search results here
        filterContent(searchText: self.searchController.searchBar.text!)
    }
    
    //for filter search bar
    func filterContent(searchText: String){
        print("starting search...")
        self.filteredUsers = self.usersArray.filter{ user in
            let username = user!["Skills"] as? String
            return(username?.lowercased().contains(searchText.lowercased()))!
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let showUserProfileViewController = segue.destination as! SearchDetailViewController
        showUserProfileViewController.loggedInUser = self.loggedInUser
        
        if let indexPath = tableView.indexPathForSelectedRow{
            let userName = objectsArray[indexPath.section].sectionName
            showUserProfileViewController.otherUserName = userName
            let userSkill = objectsArray[indexPath.section].sectionObjects[indexPath.row]
            showUserProfileViewController.otherUserSkill = userSkill
            let userEmail = objectsArray[indexPath.section].email
            showUserProfileViewController.otherUserEmail = userEmail
            let userCost = "\(objectsArray[indexPath.section].cost[indexPath.row])"
            showUserProfileViewController.otherUserCost = String(userCost)
        }
    }
}
