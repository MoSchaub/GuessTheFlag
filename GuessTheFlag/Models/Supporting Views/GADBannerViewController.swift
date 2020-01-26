//
//  GADBannerViewController.swift
//  GuessTheFlag
//
//  Created by Moritz Schaub on 25.01.20.
//  Copyright © 2020 Moritz Schaub. All rights reserved.
//

import SwiftUI
import GoogleMobileAds



///Ad banner
final class GADBannerViewController: UIViewControllerRepresentable  {


    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: kGADAdSizeBanner)

        let viewController = UIViewController()
        view.adUnitID = "ca-app-pub-3940256099942544/2934735716" //ca-app-pub-3940256099942544/2934735716
        view.rootViewController = viewController
        view.delegate = viewController
        viewController.view.addSubview(view)
        viewController.view.frame = CGRect(origin: .zero, size: CGSize(width: 468, height: 60))
        view.load(GADRequest())

        return viewController
    }


    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

}

extension UIViewController: GADBannerViewDelegate {
    public func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("ad received")
    }

    public func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("fail ad")
        print(error)
    }
}
