//
//  BigPhotoCollectionViewCell.swift
//  FoodRecord
//
//  Created by 李世文 on 2021/8/18.
//

import UIKit

class BigPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    func updateZoom() {
        guard let imageSize = imageView.image?.size else { return }
        let widthScale = bounds.size.width / imageSize.width
        let heightScale = bounds.size.height / imageSize.height
        let scale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = scale
//        scrollView.maximumZoomScale = max(widthScale, heightScale)
        scrollView.zoomScale = scale
        // scrollViewDidZoom 有可能沒有觸發，
        // 因此在這裡先呼叫一次
        updateContentInset()
    }
    
    func updateContentInset(){
        guard let imageHeight = imageView.image?.size.height else { return }
        let inset = (bounds.height - imageHeight * scrollView.zoomScale) / 2
        scrollView.contentInset = .init(top: max(inset, 0), left: 0, bottom: 0, right: 0)
    }
    
    
}

extension BigPhotoCollectionViewCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateContentInset()
    }
}
