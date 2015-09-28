//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate, UISearchBarDelegate {

    private var businesses: [Business]!
    
    @IBOutlet weak var tableView: UITableView!
    var searchBar: UISearchBar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        self.searchBar = UISearchBar();
        self.searchBar?.sizeToFit()
        self.searchBar?.delegate = self;
        self.navigationItem.titleView = self.searchBar;
        
        tableView.estimatedRowHeight = 120;
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true, distance: nil) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses as NSArray as! [Business]
            self.tableView.reloadData()
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count;
        } else {
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell;
        
        cell.business = businesses[indexPath.row]
        return cell;
    }
    
    // MARK: - SearchBar
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchWithTerm(searchBar.text!, sort: .Distance, categories: nil, deals: true, distance: nil);
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Helper
    
    private func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, distance: NSNumber?) {
        Business.searchWithTerm(term, sort: sort, categories: categories, deals: deals, distance: distance) { (businesses: [Business]!, error: NSError!) -> Void in
            if (businesses != nil) {
                self.businesses = businesses as NSArray as! [Business]
            } else {
                self.businesses = [];
            }
            self.tableView.reloadData()
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
    }
    
    // MARK: - FiltersViewControllerDelegate
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        var term = "Restaurants";
        if (self.searchBar!.text?.characters.count != 0) {
            term = self.searchBar!.text!;
        }
        let sort = YelpSortMode(rawValue: filters["sort"] as! Int);
        let categories = filters["categories"] as! [String];
        let deals = filters["deals"] as! Bool;
        let distance = filters["distance"] as! Double
        if distance == -1 {
            self.searchWithTerm(term, sort: sort, categories: categories, deals: deals, distance: nil);
        } else {
            self.searchWithTerm(term, sort: sort, categories: categories, deals: deals, distance: NSNumber(double: distance));
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "loadFilters" {
            if let navVC = segue.destinationViewController as? UINavigationController {
                if let vc = navVC.topViewController as? FiltersViewController {
                    vc.delegate = self;
                }
            }
        }
    }

}
