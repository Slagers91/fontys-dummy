//
//  PostCell.swift
//  Fontys-Dummys
//
//  Created by Ruud Slagers on 26/12/2016.
//  Copyright © 2016 Ruud Slagers. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likeLbl: UILabel!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.caption.text = post.caption
        self.likeLbl.text = "\(post.likes)"
        
        //Download de afbeelding
        if img != nil {
            self.postImg.image = img
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 2024 * 2024, completion: { (data, error) in
                if error != nil {
                    print("RUUD: Unable to download image from Firbase storage")
                } else {
                    print("RUUD: Image downloaded from Firabase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
    }

}
