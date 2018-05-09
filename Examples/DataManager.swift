//
//  DataManager.swift
//  Starterkit
//
//  Created by D2Factory.
//  Copyright © 2016 devoteam digital factory. All rights reserved.
//

import RxSwift
import Foundation

class DataManager {
    static let shared = DataManager()

    let realmProvider = RealmProvider()
	
	fileprivate func _getRItems() -> Observable<[Item]> {
		return realmProvider.getItems()
	}
	
	fileprivate func _getRItemById(_ id: String) -> Observable<Item> {
		return realmProvider.getItemById(id)
	}
	
	fileprivate func _saveRItems(_ items: [Item]) -> Observable<Void> {
		return realmProvider.saveItems(items)
	}
	
	fileprivate func _clearRItems() -> Observable<Void> {
		return realmProvider.clearItems()
	}
	
	fileprivate func _clearRData() -> Observable<Void> {
		return realmProvider.clear()
	}
}

extension DataManager {
	
	func getRItems() -> Observable<[Item]> {
		return self._getRItems()
	}
	
	func getRItemById(_ id: String) -> Observable<Item> {
		return self._getRItemById(id)
	}
	
	func saveRItems(_ items: [Item]) -> Observable<Void> {
		return self._saveRItems(items)
	}
	
	func clearRItems() -> Observable<Void> {
		return self._clearRItems()
	}
	
	func clearRData() -> Observable<Void> {
		return self._clearRData()
	}
}
