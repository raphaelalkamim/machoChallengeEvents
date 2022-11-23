//
//  ViewController.swift
//  macroChallengeApp
//
//  Created by Raphael Alkamim on 02/09/22.
//

import UIKit
import Network
import GoogleMobileAds

class ExploreViewController: UIViewController {
    weak var coordinator: ExploreCoordinator?
    let designSystem: DesignSystem = DefaultDesignSystem.shared
    let locationSearchTable = RoadmapSearchTableViewController()
    let explorerView = ExploreView()
    var roadmaps: [RoadmapDTO] = []
    var roadmapsMock: [Roadmaps] = []
    let network: NetworkMonitor = NetworkMonitor.shared
    let onboardEnable = UserDefaults.standard.bool(forKey: "onboard")
    
    var adLoader: GADAdLoader!
    var adsNatives: [GADNativeAd] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        network.startMonitoring()
        explorerView.showSpinner()
        emptyState(conection: network.isReachable)
        
        self.setContextMenu()
        self.locationSearchTable.coordinator = coordinator
        self.setupExplorerView()
        if let data = KeychainManager.shared.read(service: "username", account: "explorer") {
            let userID = String(data: data, encoding: .utf8)!
            print(userID)
        }
        if onboardEnable == false {
            coordinator?.startOnboarding()
        }
        
        let multipleAdsOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdsOptions.numberOfAds = 5

        adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/3986624511", rootViewController: self,
                adTypes: [.native],
                options: [multipleAdsOptions])
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        network.startMonitoring()
        DataManager.shared.getPublicRoadmaps({ roadmaps in
            self.roadmaps = roadmaps
            self.roadmaps.sort { $0.likesCount > $1.likesCount }
            if roadmaps.isEmpty { self.getMockData() }
            if !self.adsNatives.isEmpty {
                for ad in self.adsNatives {
                    self.roadmaps.append(RoadmapDTO(id: -5, name: ad.headline ?? "Anúncio", location: "", budget: 0, dayCount: 0, dateInitial: "", dateFinal: "", peopleCount: 0, imageId: "", category: "Advertize", currency: "", likesCount: 0))
                }
                
            }
            self.explorerView.roadmapsCollectionView.reloadData()
            self.emptyState(conection: self.network.isReachable)
        })
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func addNewRoadmap() {
        coordinator?.createNewRoadmap()
    }
    func getMockData() {
        let mockManager = DataMockManager()
        if let localData = mockManager.readLocalFile(forName: "dataRoadmaps") {
            self.roadmapsMock = mockManager.parse(jsonData: localData)!
            self.roadmapsMock.sort { $0.likesCount > $1.likesCount }
            self.explorerView.hiddenSpinner()
        }
    }
}

extension ExploreViewController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        print("filtro")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            FirebaseManager.shared.createAnalyticsEvent(event: "search_roadmap", parameters: ["search_text": searchText])
        }
    }
}
