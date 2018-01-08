//
//  ImageViewController.swift
//  ImageGallery
//
//  Created by Khen Cruzat on 07/01/2018.
//  Copyright © 2018 Khen Cruzat. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
        
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.addSubview(imageView)
            scrollView.minimumZoomScale = 1/15
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
        }
    }
    
    var imageView = ImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.loadingView!.center = view.center
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
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
