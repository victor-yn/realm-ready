//
//  ItemRealmMapper.swift
//  App
//
//  Created by Victor Yan on 04/05/2018.
//  Copyright © 2018 d2factory. All rights reserved.
//

import Foundation
import RealmSwift

class ItemRealmMapper {
	
	func map(_ optionalDto: ItemRealmDto?) throws -> Item {
		let dto = try OptionalUtils.unwrap(optionalDto)
		let id = try OptionalUtils.unwrap(dto.id)
		let title = try OptionalUtils.unwrap(dto.title)
		let description = try OptionalUtils.unwrap(dto._description)
		let image = try OptionalUtils.unwrap(dto.image)
		
		return Item(id: id, title: title, description: description, image: image)
	}
	
	func map(_ optionalDto: Results<ItemRealmDto>?) throws -> [Item] {
		let items = try OptionalUtils.unwrap(optionalDto)
		var mappedItems = [Item]()
		for current in items {
			mappedItems.append(try self.map(current))
		}
		return mappedItems
	}
	
	func map(_ item: Item) -> ItemRealmDto {
		let dto = ItemRealmDto()
		dto.id = item.id
		dto._description = item.description
		dto.image = item.image
		dto.title = item.title
		return dto
	}
	
	func map(_ items: [Item]) -> [ItemRealmDto] {
		var mappedDto = [ItemRealmDto]()
		for current in items {
			mappedDto.append(map(current))
		}
		return mappedDto
	}
}
