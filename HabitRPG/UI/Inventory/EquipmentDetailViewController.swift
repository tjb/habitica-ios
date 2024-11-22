//
//  EquipmentDetailViewController.swift
//  Habitica
//
//  Created by Phillip Thelen on 18.04.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import UIKit
import Habitica_Models

class EquipmentDetailViewController: BaseTableViewController, UISearchResultsUpdating {
    
    var selectedType: String?
    var selectedCostume = false
    
    var datasource: EquipmentViewDataSource?
    private let inventoryRepository = InventoryRepository()
    
    private var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        if let gearType = selectedType {
            datasource = EquipmentViewDataSource(useCostume: selectedCostume, gearType: gearType)
            datasource?.tableView = self.tableView
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        self.navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.backButtonTitle = nil
        if #available(iOS 16.0, *) {
            self.navigationItem.preferredSearchBarPlacement = .inline
            searchController.scopeBarActivation = .onTextEntry
            searchController.searchSuggestions = [
                UISearchSuggestionItem(localizedSuggestion: "Spring Gear"),
                UISearchSuggestionItem(localizedSuggestion: "Summer Gear"),
                UISearchSuggestionItem(localizedSuggestion: "Autumn Gear"),
                UISearchSuggestionItem(localizedSuggestion: "Winter Gear"),
                UISearchSuggestionItem(localizedSuggestion: "Subscriber Item")
            ]
        }
        searchController.searchResultsUpdater = self
    }
    
    override func applyTheme(theme: any Theme) {
        super.applyTheme(theme: theme)
        searchController.searchBar.backgroundColor = theme.contentBackgroundColor
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let gear = datasource?.item(at: indexPath) {
            inventoryRepository.equip(type: selectedCostume ? "costume" : "equipped", key: gear.key ?? "").observeCompleted {
                UIApplication.requestReview()
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            datasource?.searchString = searchText
        } else {
            datasource?.searchString = nil
        }
        self.tableView.reloadData()
    }
    
    @available(iOS 16.0, *)
    func updateSearchResults(for searchController: UISearchController, selecting searchSuggestion: any UISearchSuggestion) {
        searchController.searchBar.text = searchSuggestion.localizedSuggestion
    }
}
