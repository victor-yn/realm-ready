//
//  RProvider.swift
//  App
//
//  Created by Victor Yan on 04/05/2018.
//  Copyright © 2018 d2factory. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class RProvider {
	
	let realm = try! Realm()
	let itemsMapper = ItemRMapper()
	
	func getItems() -> Observable<[Item]> {
		return Observable.create{ observer in
			do {
				let objects = self.realm.objects(ItemRDto.self)
				guard !objects.isEmpty else { throw NSError() }
				let items = try self.itemsMapper.map(objects)
				observer.onNext(items)
				observer.onCompleted()
			}
			catch let error as NSError {
				observer.onError(error)
			}
			return Disposables.create()
		}
	}
	
	func getItemById(_ id: String) -> Observable<Item> {
		return Observable.create{ observer in
			do {
				guard let object = self.realm.objects(ItemRDto.self).filter("id = '\(id)'").first else {
					throw NSError()
				}
				let item = try self.itemsMapper.map(object)
				observer.onNext(item)
				observer.onCompleted()
			}
			catch let error as NSError {
				observer.onError(error)
			}
			return Disposables.create()
		}
	}
	
	func deleteItems(_ incoming: [Item]) -> Observable<Void> {
		return Observable.create({ (observer) -> Disposable in
			do {
				let idsToDelete = incoming.map { $0.id }
				let objectsToDelete = self.realm.objects(ItemRDto.self).filter("id IN %@", idsToDelete)
				try self.realm.write {
					self.realm.delete(objectsToDelete)
				}
				observer.onNext(())
				observer.onCompleted()
			}
			catch let error as NSError {
				observer.onError(error)
			}
			return Disposables.create()
		})
	}
	
	func deleteAllItems() -> Observable<Void> {
		return Observable.create({ (observer) -> Disposable in
			do {
				let itemsDto = self.realm.objects(ItemRDto.self)
				try self.realm.write {
					self.realm.delete(itemsDto)
				}
				observer.onNext(())
				observer.onCompleted()
			}
			catch let error as NSError {
				observer.onError(error)
			}
			return Disposables.create()
		})
	}
	
	func saveItems(_ incoming: [Item]) {
		let dtos = self.itemsMapper.map(incoming)
		try! self.realm.write {
			self.realm.add(dtos, update: true)
		}
	}
	
	func clear() -> Observable<Void> {
		return Observable.create({ (observer) -> Disposable in
			do {
				try self.realm.write {
					self.realm.deleteAll()
				}
				observer.onNext(())
				observer.onCompleted()
			}
			catch let error as NSError {
				observer.onError(error)
			}
			return Disposables.create()
		})
	}
}

