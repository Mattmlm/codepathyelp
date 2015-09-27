//
//  FiltersViewController.swift
//  Yelp
//
//  Created by admin on 9/26/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController (filtersViewController: FiltersViewController, didUpdateFilters filters: [String: AnyObject]);
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?;
    
    var filterSections: [String] = ["Deals", "Distance", "Sort By", "Categories"];
    var distanceFilterNames: [String] = ["Auto", "2 blocks", "6 blocks", "1 mile", "5 miles"];
    var distanceFilterValues: [Double] = [-1, 0.25, 0.75, 1, 5];
    var distanceSelected: Int = 0;
    var categoryFilters: [[String : String]] = YelpCategories.categories;
    var sortByFiltersNames: [String] = ["Best Matched", "Distance", "Highest Rated"];
    var sortSelected: Int = 0;
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
            return sortByFiltersNames.count;
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
                singleChoiceCell.preferenceLabel.text = sortByFiltersNames[indexPath.row];
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
            if indexPath.section == 1 {
                self.distanceSelected = indexPath.row;
            } else if indexPath.section == 2 {
                self.sortSelected = indexPath.row;
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
        self.delegate?.filtersViewController?(self, didUpdateFilters: self.processPreferences());
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    private func processPreferences() -> [String: AnyObject] {
        let deals = preferences![0][0];
        let distance = distanceFilterValues[distanceSelected];
        let sort = sortSelected;
        var categories : [String] = [];
        for index in 0...preferences![3].count - 1 {
            if (preferences![3][index]) {
                categories.append(categoryFilters[index]["code"]!);
            }
        }
        let preferencesToSearch = [
            "deals" : deals,
            "distance": distance,
            "sort": sort,
            "categories": categories,
        ];
        print(preferencesToSearch);
        
        return preferencesToSearch as! [String : AnyObject];
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
