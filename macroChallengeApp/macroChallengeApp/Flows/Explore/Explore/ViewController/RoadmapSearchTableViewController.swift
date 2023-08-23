import UIKit

class RoadmapSearchTableViewController: UITableViewController {
    var matchingRoadmaps: [RoadmapDTO] = []
    var roadmaps: [RoadmapDTO] = []
    let designSystem = DefaultDesignSystem.shared
    lazy var userCurrency: String = {
        let userC = self.getUserCurrency()
        return userC
    }()
    weak var coordinator: ExploreCoordinator?
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        self.view.backgroundColor = designSystem.palette.backgroundPrimary
    }
    
    func getUserCurrency() -> String {
        let locale = Locale.current
        let currencySymbol = locale.currencySymbol
        return currencySymbol ?? "U$"
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingRoadmaps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell else {
            preconditionFailure("Cell not found")
        }
        let roadmap = matchingRoadmaps[indexPath.row]
        cell.title.text = roadmap.name
        
        if let cachedImage = FirebaseManager.shared.imageCash.object(forKey: NSString(string: roadmap.imageId)) {
            cell.cover.image = cachedImage
        } else {
            cell.cover.image = UIImage(named: cell.setupImage(category: roadmap.category))
        }
        
        cell.setupContent(roadmap: roadmap)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            coordinator?.previewRoadmap(roadmapId: matchingRoadmaps[indexPath.row].id)
        } else {
            coordinator?.previewRoadmap(roadmapId: roadmaps[indexPath.row].id)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
        
    }
}

extension RoadmapSearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            // searchController.searchBar.showsBookmarkButton = false
            self.isSearching = true
        } else {
            // searchController.searchBar.showsBookmarkButton = true
            self.isSearching = false
        }
        
        guard let searchBarText = searchController.searchBar.text?.lowercased() else { return }
                
        matchingRoadmaps = roadmaps.filter({ roadmap in
            let category = roadmap.category.localized()
            return roadmap.name.lowercased().contains(searchBarText) || category.lowercased().contains(searchBarText)
        })
        
        self.tableView.reloadData()
    }
}

extension RoadmapSearchTableViewController: RoadmapSearchTableDidUpdateRoadmaps {
    func updateRoadmaps(roadmaps: [RoadmapDTO]) {
        self.roadmaps = roadmaps
    }
}
