//
//  ViewController.swift
//  BannerDemo
//
//  Created by Ethan Hung on 2024/5/7.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bannerScrollView: UIScrollView!
    
    let images = ["cat", "chicken", "dog"]
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showFirstBannerView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
        print("開始計時器")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
        print("停止計時器")
    }
}

extension ViewController: UIScrollViewDelegate {
    func showFirstBannerView() {
        let width = bannerScrollView.bounds.width
        bannerScrollView.contentOffset = CGPoint(x: width, y: 0)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        bannerScrollView.delegate = self
        
        let width = bannerScrollView.bounds.width
        let currentPage = Int(bannerScrollView.contentOffset.x / width)
        let totalPages = images.count

        // 圖片        [ (3) (1) (2) (3) (1) ]
        // currentPage[  1   2   3   4   5  ]
        
        if currentPage == 0 {
            // 最前面的額外圖片（3），跳轉到實際的最後一張圖片（3）
            bannerScrollView.contentOffset = CGPoint(x: width * CGFloat(totalPages), y: 0)
        } else if currentPage == totalPages + 1 {
            // 最後面的額外圖片（1），跳轉到實際的第一張圖片（1）
            bannerScrollView.contentOffset = CGPoint(x: width, y: 0)
        }
        
    }
    func startTimer() {
        // 創建一個重複執行的計時器，每隔 3 秒觸發一次
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            let width = self.bannerScrollView.frame.width
            let currentOffset = self.bannerScrollView.contentOffset.x
            let nextOffset = currentOffset + width

            // 如果 nextOffset 超過了最後一頁的偏移量，調整到第一頁
            if nextOffset >= width * CGFloat(self.images.count + 1) {
                let newOffset = CGPoint(x: width, y: 0)
                self.bannerScrollView.setContentOffset(newOffset, animated: true)
            } else {
                // 否則正常滾動
                let newOffset = CGPoint(x: nextOffset, y: 0)
                self.bannerScrollView.setContentOffset(newOffset, animated: true)
            }
        }
    }
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
