//
//  BigPhotoViewController.swift
//  FoodRecord
//
//  Created by 李世文 on 2021/8/18.
//

import UIKit

class BigPhotoViewController: UIViewController {

    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var photos: Array<UIImage>!
    var item: Int!
    var isShow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        setupCollectionFlowLayout()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isShow == false {//viewDidLayoutSubviews可能被多次觸發
            let indextPath = IndexPath(item: item, section: 0)
            photosCollectionView.scrollToItem(at: indextPath, at: .centeredHorizontally, animated: false)
            pageControl.currentPage = item
            isShow = true
        }
        
    }
    
    func setupCollectionFlowLayout() {
        let flowLayout = photosCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = UIScreen.main.bounds.size
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumInteritemSpacing = 0
        flowLayout?.minimumLineSpacing = 0
        flowLayout?.sectionInset = .zero
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == photosCollectionView {
            item = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            pageControl.currentPage = item
        }
    }
    
    @IBAction func changePage(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        photosCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        
    }
    
    @IBAction func dismissBigPhoto(_ sender: Any) {
        performSegue(withIdentifier: "unwindToBigPhoto", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BigPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = photos.count
        pageControl.numberOfPages = count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BigPhotoCollectionViewCell", for: indexPath) as? BigPhotoCollectionViewCell else { return UICollectionViewCell() }
        cell.imageView.image = photos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let BigPhotoCell = cell as? BigPhotoCollectionViewCell
        BigPhotoCell?.updateZoom()
    }
    
}
