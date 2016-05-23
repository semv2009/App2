//
//  ServiceViewController.swift
//  App
//
//  Created by developer on 17.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tryAgainButton: UIButton!
    
    var quotes = [Quote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Service"
        configureTableView()
        loadQuotes()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "QuoteTableViewCell", bundle: nil), forCellReuseIdentifier: "QuoteCell")
        tryAgainButton.addTarget(self, action: #selector(ServiceViewController.loadQuotes), forControlEvents: .TouchDown)
    }
    
    func loadQuotes() {
        tryAgainButton.hidden = false
        showLoadingView(StatusConstants.Loading.load, disableUI: true)
        WebHelper.getQuotes(
            success: { [unowned self] (result) in
                self.quotes = result
                self.tableView.reloadData()
                self.hideLoadingView()
                self.tryAgainButton.hidden = true
            },
            failed: {(error) in
                self.tryAgainButton.hidden = false
                if let error = error {
                    switch error.code {
                    case Error.notInternet:
                        self.hideLoadingView(StatusConstants.Failed.noInternet, success: false, animated: true)
                    default:
                        self.hideLoadingView(StatusConstants.Failed.error, success: false, animated: true)
                    }
                } else {
                    self.hideLoadingView(StatusConstants.Failed.error, success: false, animated: true)
                }
        })
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
