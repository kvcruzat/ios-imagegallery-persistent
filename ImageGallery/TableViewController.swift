//
//  TableViewController.swift
//  ImageGallery
//
//  Created by Khen Cruzat on 06/01/2018.
//  Copyright © 2018 Khen Cruzat. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISplitViewControllerDelegate, UITextFieldDelegate {
    
    var galleries = [(name: String, gallery: [Image])]()
    var tempGalleries = [(name: String, gallery: [Image])]()
    var deletedGalleries = [(name: String, gallery: [Image])]()

    @IBOutlet weak var newButton: UIBarButtonItem!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.count < 1 {
            return false
        } else {
            textField.resignFirstResponder()
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cell = textField.superview?.superview as? GalleryViewCell, let indexPath = tableView.indexPath(for: cell) {
            galleries[indexPath.row].name = textField.text!
        }
        
        textField.isEnabled = false
        tableView.allowsSelection = true
        newButton.isEnabled = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableView.allowsSelection = false
        newButton.isEnabled = false
        
    }

    @IBAction func newGallery(_ sender: UIBarButtonItem) {
        let selectedIndexPath = tableView.indexPathForSelectedRow
        
        galleries += [(name: "Untitled".madeUnique(withRespectTo: galleries.map{ $0.name }), gallery: [])]
        tableView.reloadData()
        
        if selectedIndexPath != nil {
            tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
        }
    }
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return galleries.count
        } else {
            return deletedGalleries.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath) as! GalleryViewCell

        // Configure the cell...
        if indexPath.section == 0 {
            cell.textField.text = galleries[indexPath.row].name
        } else {
            cell.textField.text = deletedGalleries[indexPath.row].name
            cell.selectionStyle = .none
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if deletedGalleries.count == 0 {
            return nil
        } else if section == 0 {
            return nil
        } else {
            return "Recently Deleted"
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if indexPath.section == 0 {
                tempGalleries += [galleries.remove(at: indexPath.row)]
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                deletedGalleries += [tempGalleries.removeFirst()]
                tableView.insertRows(at: [IndexPath(row: deletedGalleries.count-1, section: 1)], with: .automatic)
            } else {
                deletedGalleries.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let undeleteAction = contextualUndeleteAction(forRowAtIndexPath: indexPath)
            let swipeConfig = UISwipeActionsConfiguration(actions: [undeleteAction])
            return swipeConfig
        } else {
            return nil
        }
        
    }
    
    func contextualUndeleteAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .normal,
                                        title: "Undelete") {_,_,_ in
                                            self.tempGalleries += [self.deletedGalleries.remove(at: indexPath.row)]
                                            self.tableView.deleteRows(at: [indexPath], with: .fade)
                                            
                                            self.galleries += [self.tempGalleries.removeFirst()]
                                            self.tableView.insertRows(at: [IndexPath(row: self.galleries.count - 1, section: 0)], with: .automatic)
                                            
                                            self.tableView.reloadData()

        }
        
        return action
    }

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


    // MARK: - Navigation
    
    override func viewWillLayoutSubviews() {
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
    
    private var splitViewDetailCollectionController: CollectionViewController? {
        let navCon = splitViewController?.viewControllers.last as? UINavigationController
        return navCon?.viewControllers.first as? CollectionViewController
    }
    
    private var lastSeguedToCollectionViewController: CollectionViewController?
    private var lastSelectedCell: UITableViewCell?
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let cell = sender as? UITableViewCell {
            if tableView.indexPath(for: cell)?.section == 0 { return true }
            else { return false }
        } else {
            return false
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Choose Gallery" {
            
            if let cvc = splitViewDetailCollectionController, let cell = lastSelectedCell, let indexPath = tableView.indexPath(for: cell){
                galleries[indexPath.row].gallery = cvc.imageCollection
            }
            
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell), let navCon = segue.destination as? UINavigationController, let vc = navCon.viewControllers.first as? CollectionViewController {
                    print("NUMBER OF PICTURES: \(galleries[indexPath.row].gallery.count)")
                    vc.imageCollection = galleries[indexPath.row].gallery
                    lastSeguedToCollectionViewController = vc
                    lastSelectedCell = cell
            }
        }
    }

}
