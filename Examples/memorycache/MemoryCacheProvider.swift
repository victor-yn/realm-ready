//
//  MemoryCacheProvider.swift
//  starterkit
//
//  Copyright © 2016 d2factory. All rights reserved.
//

import Foundation
import RxSwift

class MemoryCacheProvider {
	
	var profile: Profile? = nil
	var item = Dictionary<String,Item>()
	var items: [Item]?
	
	func saveProfile(_ incoming: Profile){
		profile = incoming
	}
	
	func getProfile() -> Observable<Profile> {
		return Observable.create{ observer in
			if self.profile != nil {
				observer.onNext(self.profile!)
				observer.onCompleted()
			}
			else {
				observer.onError(NSError())
			}
			return Disposables.create()
		}
	}
	
	func saveItem(_ id: String, _ incoming: Item) {
		item = [id:incoming]
	}
	
	func getItem(_ id: String) -> Observable<Item> {
		print ("\r\n Get Item \(id) From Cache")
		return Observable.create{ observer in
			if self.item.index(forKey: id) != nil {
				observer.onNext(self.item[id]!)
				observer.onCompleted()
			}
			else {
				observer.onError(NSError())
			}
			return Disposables.create()
		}
	}
	
	func saveItems(_ incoming: [Item]) {
		items = incoming
	}
	
	func getItems() -> Observable<[Item]> {
		return Observable.create{ observer in
			if let items = self.items {
				observer.onNext(items)
				observer.onCompleted()
			}
			else {
				observer.onError(NSError())
			}
			return Disposables.create()
		}
	}
	
	func clear() {
		profile = nil
		item.removeAll()
		items = nil
	}
	
}
