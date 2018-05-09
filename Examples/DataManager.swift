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
    
    let networkProvider = NetworkProvider()
    let networkMonitor = NetworkMonitor()
    let userDefaultsProvider = UserDefaultsProvider()
    let memoryCacheProvider = MemoryCacheProvider()
    let realmProvider = RealmProvider()

    fileprivate init() {
        _ = self.networkMonitor.getNetworkObservable().subscribe(
            onNext: { isConnected in }
        )
    }
    
    fileprivate func _getNetworkObservable() -> Observable<Bool> {
        return self.networkMonitor.getNetworkObservable()
    }
    
    fileprivate func _autoLogIn() -> Observable<String> {
        return userDefaultsProvider.loadCredentials().flatMap({ (email,pwd) -> Observable<String> in
            return self._logIn(email, pwd)
        })
    }
    
    fileprivate func _logIn(_ email: String, _ password: String) -> Observable<String> {
        return networkProvider.login(email, password)
            .do(onNext: { (token) in
                self.networkProvider.token = token
            })
            .flatMap({ (token) -> Observable<String> in
                return Observable.zip(self.userDefaultsProvider.saveCredentials(email, password),
                                      self._getProfile(),
                                      resultSelector: { (aVoid, profile) -> String in
                                        return token
                })
            })
    }
    
    fileprivate func _logOut() {
        userDefaultsProvider.clear()
        networkProvider.token = nil
        memoryCacheProvider.clear()
    }
    
    fileprivate func _getItems() -> Observable<[Item]> {
        return networkProvider.getItems()
    }
	
	fileprivate func _getRItems() -> Observable<[Item]> {
		return realmProvider.getItems()
	}
	
	fileprivate func _getRItemById(_ id: String) -> Observable<Item> {
		return realmProvider.getItemById(id)
	}
	
	fileprivate func _saveRItems(_ items: [Item]) -> Observable<Void> {
		return realmProvider.saveItems(items)
	}
    
    fileprivate func _getItemDetails(_ id: String) -> Observable<Item> {
        return memoryCacheProvider.getItem(id)
            .catchError({ (error) -> Observable<Item> in
                return self.networkProvider.getItemDetails(id)
                    .do(onNext:{ (item) in
                        self.memoryCacheProvider.saveItem(id, item)
                    })
            })
    }
    
    fileprivate func _getProfile() -> Observable<Profile> {
        return memoryCacheProvider.getProfile()
            .catchError({ (error) -> Observable<Profile> in
                return self.networkProvider.getProfileInfo()
                    .do(onNext:{ (profile) in
                        self.memoryCacheProvider.saveProfile(profile)
                    })
            })
        
    }
}

extension DataManager {
    
    func autoLogIn() -> Observable<Void> {
        return self._autoLogIn().map({ (token) -> Void in
        })
    }
    
    func logIn(_ email: String, _ password: String) -> Observable<Void> {
        return self._logIn(email, password).map({ (token) -> Void in })
    }
    
    func getProfile() -> Observable<Profile> {
        return self._getProfile()
    }
    
    func logOut() {
        return self._logOut()
    }
    
    func getItems() -> Observable<[Item]> {
        return self._getItems()
    }
	
	func getRItems() -> Observable<[Item]> {
		return self._getRItems()
	}
	
	func getRItemById(_ id: String) -> Observable<Item> {
		return self._getRItemById(id)
	}
	
	func saveRealmItems(_ items: [Item]) -> Observable<Void> {
		return self._saveRItems(items)
	}
    
    func getNetworkObservable() -> Observable<Bool> {
        return self._getNetworkObservable()
    }
    
    func getItemDetails(_ id: String) -> Observable<Item> {
        return self._getItemDetails(id)
    }
}
