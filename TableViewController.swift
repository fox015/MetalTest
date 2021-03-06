//
//  TableViewController.swift
//  MetalTest
//
//  Created by Rob Gilbert on 16/11/2015.
//  Copyright © 2015 Ninety Four. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
	
	// MARK: Properties
	var shapes = [Shape]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
		self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
		
		loadSampleShapes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return shapes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
			"TableViewCell", forIndexPath: indexPath) as! TableViewCell

		let shape = shapes[indexPath.row]
		
		cell.name.text = shape.name

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

	
    // MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "ShowNode" {
			// We are moving to the node view.
			let nodeViewController = segue.destinationViewController as! ViewController
			
			// Get the cell that generated this segue.
			if let selectedObjectCell = sender as? TableViewCell {
				let indexPath = tableView.indexPathForCell(selectedObjectCell)!
				let selectedObject = shapes[indexPath.row]
				switch selectedObject.type {
					case .Triangle:
						nodeViewController.objectToDraw = Triangle()
					case .Cube:
						nodeViewController.objectToDraw = Cube()
				}
			}
		}
	}
	
	func loadSampleShapes() {
		shapes.append(Shape(name: "Triangle", type: .Triangle))
		shapes.append(Shape(name: "Cube", type: .Cube))
	}

}
