//
//  EquipmentViewDataSource.swift
//  Habitica
//
//  Created by Phillip Thelen on 19.04.18.
//  Copyright © 2018 HabitRPG Inc. All rights reserved.
//

import Foundation
import Habitica_Models
import Habitica_Database
import ReactiveSwift

class EquipmentViewDataSource: BaseReactiveTableViewDataSource<GearProtocol> {
    
    private let userRepository = UserRepository()
    private let inventoryRepository = InventoryRepository()
    
    private var equippedKey: String?
    var searchProperty = MutableProperty<String?>(nil)
    var searchString: String? {
        get {
            return searchProperty.value
        }
        set(value) {
            searchProperty.value = value
        }
    }
    
    private func buildGearSignalProducer(keys: [String], gearType: String, search: String?) -> SignalProducer<ReactiveResults<[GearProtocol]>, Never> {
        let predicate: NSPredicate
        if let search = search {
            predicate = NSPredicate(format: "key IN %@ && type == %@ && (text CONTAINS[cd] %@ || notes CONTAINS[cd] %@)", keys, gearType, search, search)
        } else {
            predicate = NSPredicate(format: "key IN %@ && type == %@", keys, gearType)
        }
        return inventoryRepository.getGear(predicate: predicate).flatMapError({ (_) -> SignalProducer<ReactiveResults<[GearProtocol]>, Never> in
            return SignalProducer.empty
        })
    }
            
    init(useCostume: Bool, gearType: String) {
        super.init()
        sections.append(ItemSection<GearProtocol>())
        
        disposable.add(inventoryRepository.getOwnedGear()
            .map({ (data) -> [String] in
                return data.value.map({ (ownedGear) -> String in
                    return ownedGear.key ?? ""
                }).filter({ (key) -> Bool in
                    return !key.isEmpty
                })
            }).flatMapError({ (_) -> SignalProducer<[String], Never> in
                return SignalProducer.empty
            })
            .combineLatest(with: searchProperty.producer)
            .flatMap(.latest, {[weak self] (keys, search) in
                return self?.buildGearSignalProducer(keys: keys, gearType: gearType, search: search) ?? SignalProducer.empty
            })
                .on(value: {[weak self](gear: [GearProtocol], changes: ReactiveChangeset?) in
                self?.sections[0].items = gear
                self?.notify(changes: changes)
            })
            .start()
        )
        
        disposable.add(userRepository.getUser().on(value: {[weak self]user in
            if useCostume {
                self?.equippedKey = user.items?.gear?.costume?.keyFor(type: gearType)
            } else {
                self?.equippedKey = user.items?.gear?.equipped?.keyFor(type: gearType)
            }
            self?.tableView?.reloadData()
        }).start())
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let gear = item(at: indexPath), let equipmentCell = cell as? EquipmentCell {
            equipmentCell.configure(gear)
            equipmentCell.isEquipped = gear.key == equippedKey
        }
        
        return cell
    }
}
