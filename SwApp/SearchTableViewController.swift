//
//  SearchTableViewController.swift
//  SwApp
//
//  Copyright © 2017 Bassi. All rights reserved.
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
   // var filteredUsers = [NSDictionary?]()
    var filteredUsers = [Objects]()
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
        //searchController.obscuresBackgroundDuringPresentation = false
        
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
                        //print(skillsArray)
                        //print("-------")
                        for(key, element) in skillsArray {
                            count = count+1
                          //  print(key)
                         //   print(element)
                        }
                        //print("-------")
                        self.skillsArray.append(skillsArray)
                        self.skillsDict[name] = skillsArray
                        for aSkill in skillsArray{
                       //     print(aSkill)
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
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering(){
            return filteredUsers.count
        }
        return objectsArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if isFiltering(){
            return filteredUsers[section].sectionObjects.count
        }
        return objectsArray[section].sectionObjects.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering(){
            return filteredUsers[section].sectionName
        }
        return objectsArray[section].sectionName
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let allobjects: Objects
        if isFiltering(){
           
            //allobjects = filteredUsers[indexPath.row]
            print("ISFILTERING")
            print("The section number is: \(indexPath.section)")
            print("The row number is: \(indexPath.row)")
            
            //print(indexPath.section)
            //cell.textLabel?.text = filteredUsers[indexPath.row].sectionObjects
            cell.textLabel?.text = filteredUsers[indexPath.section].sectionObjects[indexPath.row]
            cell.detailTextLabel?.text = filteredUsers[indexPath.section].cost[indexPath.row]
        }
        else{
            print("ISNOTFILTERING")
            print("The section number is: \(indexPath.section)")
            print("The row number is: \(indexPath.row)")
            
            allobjects = objectsArray[indexPath.row]
            cell.textLabel?.text = objectsArray[indexPath.section].sectionObjects[indexPath.row]
            cell.detailTextLabel?.text = objectsArray[indexPath.section].cost[indexPath.row]
        }
        
        //cell.textLabel?.text = allobjects.sectionObjects[0]
        //cell.detailTextLabel?.text = allobjects.cost[0]
        
        //cell.textLabel?.text = objectsArray[indexPath.row].sectionObjects[indexPath.row]
        //cell.detailTextLabel?.text = objectsArray[indexPath.row].cost[indexPath.row]
       
        
        // var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell!
        
        // Configure the cell here
        //cell?.textLabel?.text = objectsArray[indexPath.section].sectionObjects[indexPath.row]
        //cell?.detailTextLabel?.text = objectsArray[indexPath.section].cost[indexPath.row]
        
        return cell
    }
    
 
    
    func updateSearchResults(for searchController: UISearchController) {
        //print("starting search 2...")
        for info in objectsArray
        {
            //print("INSIDE HERE" + "\(info.cost)")
        }
        //update search results here
        filterContent(searchText: self.searchController.searchBar.text!)
        //print(self.searchController.searchBar.text!)
    }
    
    //for filter search bar
    func filterContent(searchText: String){
        //print("starting search...")
        
        
        // WORKS FOR FILTERING BY USERS
      filteredUsers = self.objectsArray.filter( {( allobjects: Objects) -> Bool in
           // print("FILTERING CHECK")
            return allobjects.sectionName.lowercased().contains(searchText.lowercased())}
        )
        
        
        
        /*filteredUsers = self.objectsArray.filter( {( allobjects: Objects) -> Bool in
            
                    if allobjects.sectionObjects.contains("Cooking")
                    {
                        print("OVER HERE")
                    }
                    return allobjects.sectionObjects.contains(searchText)
            })*/
        
        
        print("WHAT ARE THE FILTERED USERS")
        for user in filteredUsers{
            print(user.sectionName)
        }
        
        
        
        /*self.filteredUsers = self.usersArray.filter{ user in
            let username = user!["Skills"] as? String
            //print("TESTING HERE" + (username?)!)
            return(username?.lowercased().contains(searchText.lowercased()))!
        }*/

        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let showUserProfileViewController = segue.destination as! SearchDetailViewController
        showUserProfileViewController.loggedInUser = self.loggedInUser
        
        if let indexPath = tableView.indexPathForSelectedRow{
            if isFiltering(){
                let userName = filteredUsers[indexPath.section].sectionName
                showUserProfileViewController.otherUserName = userName
                let userSkill = filteredUsers[indexPath.section].sectionObjects[indexPath.row]
                showUserProfileViewController.otherUserSkill = userSkill
                let userEmail = filteredUsers[indexPath.section].email
                showUserProfileViewController.otherUserEmail = userEmail
                let userCost = "\(filteredUsers[indexPath.section].cost[indexPath.row])"
                showUserProfileViewController.otherUserCost = String(userCost)
            }
            else
            {
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
}
