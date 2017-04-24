//
//  TaggingTableTableViewController.swift
//  PhotoArchive
//
//  Created by Phillip Gulegin on 2/21/17.
//  Copyright © 2017 Phillip Gulegin. All rights reserved.
//

import UIKit

class TaggingTableTableViewController: UITableViewController {

    // Future note: May have to create a simple object/association which will tie together the titles and descriptions
    // because right now they are not
    // Array of strings with all of the Context Titles from the database
    var contexts = globalObject.sharedInstance.dbContexts;

    
    // Array of string with all of the Context Descriptions from the database
    var contextsDetails = [String]()
    
    // Dictionary for Contexts with the String as the first letter (ignore case) and the int as how many times it occurs
    var contextsSections = [String:Int]()
    
    // Array of strongs with the sorted keys from the dictionary above
    var contextsSectionsSortedKeys = [String]()
    
    func updateUI(){
        
        for i in 0..<contexts.count {
            
            let sectionLetter = String(contexts[i].id[contexts[i].id.startIndex]).uppercased()
            
            if (contextsSections[sectionLetter] != nil) {
                contextsSections[sectionLetter] = contextsSections[sectionLetter]! + 1
            }
            else {
                contextsSections[sectionLetter] = 1;
            }
        }
        
        // Sorts contexts into alphabetical order
        contexts = contexts.sorted{$0.id.localizedCompare($1.id) == .orderedAscending}
        
        // Sorts keys into alphabetical order
        contextsSectionsSortedKeys = Array(contextsSections.keys).sorted(by: <)
        
        self.tableView.reloadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        let client = delegate.client!;
        
        //        let client = MSClient(
        //            applicationURLString:"https://boephotoarchive-dev.azurewebsites.net"
        //        )
        
        let contextTable = client.table(withName: "Context");
        
        contextTable.read(completion: {
            (result, error) in
            if let err = error {
            } else if let contextResults = result?.items {
                var contextList = [Context]()
                
                for context in contextResults {
                    
                    contextList.append(
                        Context(
                            id: context["id"] as! String,
                            descriptor: context["descriptor"] as! String
                        )
                    )
                }
                
                
                self.updateUI(contextList: contextList);
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    // Total number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return contextsSections.count
    }

    // Total number of rows for every section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contextsSections[contextsSectionsSortedKeys[section]]!
    }
    
    // Title for every section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contextsSectionsSortedKeys[section]
    }
    
    // Index on the right for every section title
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contextsSectionsSortedKeys
    }

    // Confirgures the cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaggingTableTableViewCell", for: indexPath) as! TaggingTableTableViewCell
        
        // finds which context is the one that needs to be printed
        var count = 0
        count = count + indexPath.row
        
        for i in 0..<indexPath.section {
            count = count + contextsSections[contextsSectionsSortedKeys[i]]!
        }
        
        // Configure the cell...
        cell.title.text = contexts[count].id
        cell.titledescription.text = contexts[count].descriptor
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! AttributeTableTableViewController
        
        let indexPath = tableView.indexPathForSelectedRow
        
        var count = 0
        count = count + (indexPath?.row)!
        
        for i in 0..<(indexPath?.section)! {
            count = count + contextsSections[contextsSectionsSortedKeys[i]]!
        }
        
        vc.contextTitle.title = contexts[count].id
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
