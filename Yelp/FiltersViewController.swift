//
//  FiltersViewController.swift
//  Yelp
//
//  Created by admin on 9/26/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var filterSections: [String] = ["Deals", "Distance", "Sort By", "Categories"];
    var distanceFilterNames: [String] = ["Auto", "2 blocks", "6 blocks", "1 mile", "5 miles"];
    var distanceFilterValues: [Double] = [-1, 0.25, 0.75, 1, 5];
    var categoryFilters: [[String : String]] = YelpCategories.categories;
    var sortByFilters: [String] = ["Best Matched", "Distance", "Highest Rated"];
    var preferences: [[Bool]]?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadSelectedValues();
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        tableView.estimatedRowHeight = 80;
        tableView.rowHeight = UITableViewAutomaticDimension;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filterSections.count;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1;
        case 1:
            return distanceFilterNames.count;
        case 2:
            return sortByFilters.count;
        case 3:
            return categoryFilters.count;
        default:
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section < filterSections.count) {
            return filterSections[section];
        } else {
            return nil;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell;
        switch indexPath.section {
        case 0:
            cell.switchLabel.text = "Offering a Deal";
        case 1:
            cell.switchLabel.text = distanceFilterNames[indexPath.row];
        case 2:
            cell.switchLabel.text = sortByFilters[indexPath.row];
        case 3:
            cell.switchLabel.text = categoryFilters[indexPath.row]["name"]!;
        default:
            break;
        }
        
        cell.onSwitch.on = self.preferences![indexPath.section][indexPath.row];
        
        return cell;
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("indexPath selected: \(indexPath)");
    }
    
    @IBAction func onCancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func onSearchButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func preferenceSwitchCellDidToggle(cell: PreferenceSwitchCell, newValue: Bool) {
//        prefValues[cell.prefRowIdentifier] = newValue
//    }
    
    func loadSelectedValues() {
        let categoriesPreferences = [Bool](count: self.categoryFilters.count, repeatedValue: false);
        self.preferences = [
            [true], // Deals
            [true, false, false, false, false], // Distance
            [true, false, false], // Sort By
            categoriesPreferences
        ]
    }
}
