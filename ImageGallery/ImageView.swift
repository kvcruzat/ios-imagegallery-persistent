//
//  ImageView.swift
//  ImageGallery
//
//  Created by Khen Cruzat on 04/01/2018.
//  Copyright © 2018 Khen Cruzat. All rights reserved.
//

import UIKit

class ImageView: UIView {
    
    var loadingView: UIActivityIndicatorView?
    
    var imageURL: URL? {
        didSet{
            image = nil
            
//            if let loadingView = subviews.first as? UIActivityIndicatorView {
//                loadingView.startAnimating()
//            }
            if loadingView == nil {
                loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                loadingView!.hidesWhenStopped = true
                addSubview(loadingView!)
            }
            
            loadingView!.center = center
        
            loadingView!.startAnimating()
            
            fetchImage()
        }
    }
    
    var image: UIImage? {
        didSet {
//            if let loadingView = subviews.first as? UIActivityIndicatorView {
//                loadingView.stopAnimating()
//            }
            loadingView?.stopAnimating()
            
            if let scrollView = self.superview as? UIScrollView {
                frame.size = self.image!.size
                sizeToFit()
                print(frame.size)
                scrollView.contentSize = self.frame.size
            }
            
            setNeedsDisplay()
        }
        
    }
    
    private func fetchImage() {
        if let url = imageURL {
            DispatchQueue.global(qos: .userInitiated).async {
                let urlContents = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let imageData = urlContents {
                        self.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }

    override func draw(_ rect: CGRect ) {
         image?.draw(in: bounds)
    }

}
