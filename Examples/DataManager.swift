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

    let realmProvider = RProvider()
	
	//Replace _getItems() with this function
	fileprivate func _getItems() -> Observable<[Item]> {
		return self._getItemsFromCache()
			.catchError({ _ -> Observable<[Item]> in
				return self._getItemsFromRealm()
					.catchError({ _ -> Observable<[Item]> in
						return self._getItemsFromNetwork()
					})
			})
	}
	
	fileprivate func _getItemsFromCache() -> Observable<[Item]> {
		return memoryCacheProvider.getItems()
	}
	
	fileprivate func _getItemsFromRealm() -> Observable<[Item]> {
		return realmProvider.getItems()
			.do(onNext:{ (items) in
				self.memoryCacheProvider.saveItems(items)
			})
	}
	
	fileprivate func _getItemsFromNetwork() -> Observable<[Item]> {
		return networkProvider.getItems()
			.do(onNext:{ (items) in
				self.memoryCacheProvider.saveItems(items)
				self.realmProvider.saveItems(items)
			})
	}
	
	fileprivate func _getRItems() -> Observable<[Item]> {
		return realmProvider.getItems()
	}
	
	fileprivate func _getRItemById(_ id: String) -> Observable<Item> {
		return realmProvider.getItemById(id)
	}
	
	fileprivate func _saveRItems(_ items: [Item]) {
		realmProvider.saveItems(items)
	}
	
	fileprivate func _deleteRItems(_ items: [Item]) -> Observable<Void> {
		return realmProvider.deleteItems(items)
	}
	
	fileprivate func _deleteRItems() -> Observable<Void> {
		return realmProvider.deleteAllItems()
	}
	
	fileprivate func _clearRObjects() -> Observable<Void> {
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
	
	func saveRItems(_ items: [Item]) {
		return self._saveRItems(items)
	}
	
	func deleteRItems(_ items: [Item]) -> Observable<Void> {
		return self._deleteRItems(items)
	}
	
	func deleteRItems() -> Observable<Void> {
		return self._deleteRItems()
	}
	
	func clearRObjects() -> Observable<Void> {
		return self._clearRObjects()
	}
}
