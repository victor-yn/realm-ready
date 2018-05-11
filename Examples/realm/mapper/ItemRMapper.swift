//
//  ItemRMapper.swift
//  App
//
//  Created by Victor Yan on 04/05/2018.
//  Copyright © 2018 d2factory. All rights reserved.
//

import Foundation
import RealmSwift

class ItemRMapper {
	
	func map(_ dto: ItemRDto) throws -> Item {
		let id = try OptionalUtils.unwrap(dto.id)
		let title = try OptionalUtils.unwrap(dto.title)
		let description = try OptionalUtils.unwrap(dto._description)
		let image = try OptionalUtils.unwrap(dto.image)
		
		return Item(id: id, title: title, description: description, image: image)
	}
	
	func map(_ dto: Results<ItemRDto>) throws -> [Item] {
		var mappedItems = [Item]()
		for current in dto {
			mappedItems.append(try self.map(current))
		}
		return mappedItems
	}
	
	func map(_ item: Item) -> ItemRDto {
		let dto = ItemRDto()
		dto.id = item.id
		dto._description = item.description
		dto.image = item.image
		dto.title = item.title
		return dto
	}
	
	func map(_ items: [Item]) -> [ItemRDto] {
		var mappedDto = [ItemRDto]()
		for current in items {
			mappedDto.append(map(current))
		}
		return mappedDto
	}
}
