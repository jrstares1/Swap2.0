//
//  OnBoardingViewController.swift
//  Swap2
//
//  Created by Justin Stares on 11/2/20.
//

import UIKit
import Lottie


struct Slide {
    let title: String
    let anmimationName: String
    let buttonColor: UIColor
    let buttonTitle: String
    
    static let collection: [Slide] = [
        .init(title: "Welcome to Swap", anmimationName: "welcomeAnim", buttonColor: .systemYellow, buttonTitle: "Next"),
        .init(title: "Scan another users qr code to swap profile information", anmimationName: "scanAnim", buttonColor: .systemGreen, buttonTitle: "Get Started")
    ]

}

class OnBoardingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! OnboardingCollectionViewCell
        let slide = slides[indexPath.item]
        cell.configure(with: slide)
        cell.actionButtonDidTap = { [weak self] in
            self?.handleActionButtonTapped(at: indexPath)
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let slides: [Slide] = Slide.collection
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()

        // Do any additional setup after loading the view.
    }
    

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isPagingEnabled = true
    }
    
    
    private func handleActionButtonTapped(at indexPath: IndexPath){
        
        if indexPath.item == slides.count - 1 {
            //we are on the last slide
            let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            let initViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as UIViewController
            initViewController.modalPresentationStyle = .fullScreen
            self.present(initViewController, animated: true, completion: nil)
            
        }else{
            let nextItem = indexPath.item + 1
            let nextIndexPath = IndexPath(item: nextItem, section: 0)
            collectionView.scrollToItem(at: nextIndexPath, at: .left, animated: true)
        }
        
    }

}

    
class OnboardingCollectionViewCell: UICollectionViewCell{
        
    
    
    @IBOutlet weak var animationView: AnimationView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var actionButton: UIButton!
    

    @IBAction func actionButtonTapped(_ sender: Any) {
        actionButtonDidTap?()

    }

    
    var actionButtonDidTap: (() -> Void)?
    
    
    func configure(with slide: Slide) {
        titleLabel.text = slide.title
        actionButton.backgroundColor = slide.buttonColor
        actionButton.setTitle(slide.buttonTitle, for: .normal)
        
        let animation = Animation.named(slide.anmimationName)
        animationView.animation = animation
        animationView.loopMode = .loop
        
        if !animationView.isAnimationPlaying {
            animationView.play()
        }
        
    }
}
    
    
   
