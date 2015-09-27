//
//  FiltersViewController.swift
//  Yelp
//
//  Created by admin on 9/26/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {

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
        super.didReceiveMemoryWarning();
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
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath);
        switch indexPath.section {
        case let section where section == 0 || section == 3:
            let switchCell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell;
            if section == 0 {
                switchCell.switchLabel.text = "Offering a Deal";
            } else if section == 3 {
                switchCell.switchLabel.text = categoryFilters[indexPath.row]["name"]!;
            }
            switchCell.onSwitch.on = self.preferences![indexPath.section][indexPath.row];
            switchCell.delegate = self;
            cell = switchCell;
        case let section where section == 1 || section == 2:
            let singleChoiceCell = tableView.dequeueReusableCellWithIdentifier("SingleChoiceCell", forIndexPath: indexPath) as! SingleChoiceCell;
            if section == 1 {
                singleChoiceCell.preferenceLabel.text = distanceFilterNames[indexPath.row];
            } else if section == 2 {
                singleChoiceCell.preferenceLabel.text = sortByFilters[indexPath.row];
            }
            singleChoiceCell.setCheckMarkSelected(self.preferences![indexPath.section][indexPath.row]);
            cell = singleChoiceCell;
        default:
            break;
        }
        return cell;
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 || indexPath.section == 2 {
            for index in 0...self.preferences![indexPath.section].count - 1 {
                self.preferences![indexPath.section][index] = false;
            }
            self.preferences![indexPath.section][indexPath.row] = true;
            self.updateVisibleCells();
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
    }
    
    private func updateVisibleCells() {
        for cell in tableView.visibleCells {
            if let indexPath = tableView.indexPathForCell(cell) {
                if let singleChoiceCell = cell as? SingleChoiceCell {
                    singleChoiceCell.setCheckMarkSelected(self.preferences![indexPath.section][indexPath.row]);
                }
            }
        }
    }
    
    @IBAction func onCancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil);
    }
    @IBAction func onSearchButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    func switchCellDidToggle(cell: SwitchCell, newValue: Bool) {
        if let indexPath = tableView.indexPathForCell(cell) {
            preferences![indexPath.section][indexPath.row] = newValue;
        }
    }
    
    private func loadSelectedValues() {
        let categoriesPreferences = [Bool](count: self.categoryFilters.count, repeatedValue: false);
        self.preferences = [
            [true], // Deals
            [true, false, false, false, false], // Distance
            [true, false, false], // Sort By
            categoriesPreferences
        ];
    }
}
