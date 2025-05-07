//
//  admob.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/05/07.
//

import Foundation
import GoogleMobileAds
import SwiftUI

extension AdSize: @retroactive Equatable {
    public static func == (lhs: AdSize, rhs: AdSize) -> Bool {
        lhs.size == rhs.size && lhs.flags == rhs.flags
    }
}

struct BannerContentView: View {

    @State var adSize: AdSize = .init()

    var body: some View {
        GeometryReader { geometry in
            BannerViewContainer(adSize: adSize)
                .frame(height: adSize.size.height)
                .onAppear {
                     adSize = currentOrientationAnchoredAdaptiveBanner(width: geometry.size.width)
                }
        }
        .frame(height: adSize.size.height)
    }
}

private struct BannerViewContainer: UIViewRepresentable {

    let adSize: AdSize

    init(adSize: AdSize) {
        self.adSize = adSize
    }

    func makeUIView(context: Context) -> UIView {
        print(adSize)
        let view = UIView()
        view.addSubview(context.coordinator.bannerView)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.bannerView.adSize = adSize
    }

    func makeCoordinator() -> BannerCoordinator {
        return BannerCoordinator(self)
    }

    class BannerCoordinator: NSObject, BannerViewDelegate {

        @MainActor
        private(set) lazy var bannerView: BannerView = {

            let banner = BannerView(adSize: parent.adSize)
            #if DEBUG
            banner.adUnitID = "ca-app-pub-3940256099942544/2435281174"
            #else
            banner.adUnitID = "ca-app-pub-3494245922462849/1529640839"
            #endif
            banner.load(Request())
            banner.delegate = self
            return banner
        }()

        let parent: BannerViewContainer

        init(_ parent: BannerViewContainer) {
            self.parent = parent
        }

        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            print("DID RECEIVE AD.")
        }

        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            print("FAILED TO RECEIVE AD: \(error.localizedDescription)")
        }
    }
}
