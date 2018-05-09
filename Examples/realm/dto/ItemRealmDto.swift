//
//  ItemRealmDto.swift
//  App
//
//  Created by Victor Yan on 04/05/2018.
//  Copyright © 2018 d2factory. All rights reserved.
//

import Foundation
import RealmSwift

class ItemRealmDto : Object {
	@objc dynamic var id: String? = nil
	@objc dynamic var title: String? = nil
	@objc dynamic var _description: String? = nil
	@objc dynamic var image: String? = nil
	
	override static func primaryKey() -> String? {
		return "id" // Property that will be used as the primary key
	}
}
