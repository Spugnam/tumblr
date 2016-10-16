//
//  PhotosViewController.swift
//  tumblr
//
//  Created by quentin picard on 10/11/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    var responseDicoInterne: NSDictionary = [:]
    var posts: [NSDictionary]?
    
    let refreshControl = UIRefreshControl()
    var isMoreDataLoading = false


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //tableView.rowHeight = 320  // changed to height to conserve ratio in storyboard
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Use Generic identifiers here  (!)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "TableViewHeaderView")
        
        networkRequest()
        
        // Refresh
        refreshControl.addTarget(self, action: #selector(PhotosViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            isMoreDataLoading = true
            refresh()
        }
    }
    
    func refresh() {
        networkRequest()
        // table is reloaded in networkRequest
        refreshControl.endRefreshing()
        print("I just refreshed the tab")
    }
    
    func networkRequest() {
        // API
        let apiKey = "Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    NSLog("response: \(responseDictionary)")
                    
                    self.responseDicoInterne = (responseDictionary["response"] as! NSDictionary)
                    self.posts = (self.responseDicoInterne["posts"] as! [NSDictionary])

                    // reload after the network has returned the data
                    self.tableView.reloadData()
                }
            }
        });
        task.resume()
    }

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let posts = posts {
            return posts.count
        } else {
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellIdentifier", for: indexPath) as! myTableViewCell
            
        let photoDictionary = posts![indexPath.section]
        let photosTab = photoDictionary["photos"] as! [NSDictionary]
        let photos = photosTab[0]  // photosTab is a tab with only 1 element
        let originalSizePhoto = photos["original_size"] as! NSDictionary
        
        if let photoPath = originalSizePhoto["url"] as? String {
            let photoUrl = NSURL(string: photoPath)
            cell.mainImageView.setImageWith(photoUrl as! URL)
            print("photo path: \(photoPath)")
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewHeaderView")! as UITableViewHeaderFooterView
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        // set the avatar
        profileView.setImageWith(NSURL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")! as URL)
        headerView.addSubview(profileView)
        
        // Add a UILabel for the date here
        // Use the section number to get the right URL
        let dateLabel = UILabel(frame: CGRect(x: 50, y: -5, width: 270, height: 50))
        
        let photoDictionary = posts![section]
        let publishedDate = photoDictionary["date"] as! String
        dateLabel.text = publishedDate
        dateLabel.font = dateLabel.font.withSize(11)
        dateLabel.textColor = UIColor.gray
        headerView.addSubview(dateLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //send current cell using sender
        let cell = sender as! myTableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let photoDictionary = posts![indexPath!.section]
        
        // Get the new view controller using segue.destinationViewController.
        let photoDetailsViewController = segue.destination as! PhotoDetailsViewController
        photoDetailsViewController.photoDictionary = photoDictionary
        
        // Pass the selected object to the new view controller.
    }
    
}
