//
//  ServiceViewController.swift
//  App
//
//  Created by developer on 17.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    @IBOutlet weak var tableView: UITableView!
    
    var quotes = [Quote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Service"
        activityIndicatorView.hidesWhenStopped = true
        startActivityIndicator()
        configureTableView()
        
        WebHelper.getQuotes(
            success: { [unowned self] (result) in
                self.quotes = result
                self.tableView.reloadData()
                self.stopActivityIndicator()
            },
            failed: {(error) in
                self.stopActivityIndicator()
        })
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "QuoteTableViewCell", bundle: nil), forCellReuseIdentifier: "QuoteCell")
    }
    
    func startActivityIndicator() {
        activityIndicatorView.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicatorView.stopAnimating()
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = (tableView.dequeueReusableCellWithIdentifier("QuoteCell", forIndexPath: indexPath)) as? QuoteTableViewCell else { fatalError("Cell is not registered") }
        cell.updateUI(quotes[indexPath.row])
        return cell
    }
    
}
