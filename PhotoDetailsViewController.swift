//
//  PhotoDetailsViewController.swift
//  tumblr
//
//  Created by quentin picard on 10/15/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    var photoDictionary: NSDictionary!
    
    //let photoUrl = NSURL(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let photosTab = photoDictionary["photos"] as! [NSDictionary]
        let photos = photosTab[0]  // photosTab is a tab with only 1 element
        let originalSizePhoto = photos["original_size"] as! NSDictionary
        
        if let photoPath = originalSizePhoto["url"] as? String {
            let photoUrl = NSURL(string: photoPath)
            detailImageView.setImageWith(photoUrl as! URL)
        }
    }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destinationViewController.
         // Pass the selected object to the new view controller.
         }
         */
        
}
