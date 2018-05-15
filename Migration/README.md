
![realm-logo](https://github.com/realm/realm-cocoa/raw/master/logo.png)

**Cool stuff coming soon........**

TODO : 
- File sources
- Example project
- More examples

# Lightweight Migration

Version 0 final model :

```Swift
class Person: Object {
    dynamic var name = ""
    dynamic var age = 0
}
```

## V1 (adding property)

**Adding a new `email` property in our `Person` model.**

```Swift
class Person: Object {
    dynamic var name = ""
    dynamic var age = 0
    dynamic var email = ""
}
```
> Migration done be calling `Migration`'s `enumerateObjects` method within the migration block and assign an empty email string to the existing data.
```Swift
if oldSchemaVersion < 1 {
    migration.enumerateObjects(ofType: Person.className()) { (_, newPerson) in
        newPerson?["email"] = ""
    }
}
```

## V2 (rename property)

**Let's rename the `name` property to `fullName`.**
> The migration can be done by increasing the schema version and invoking `Migration`'s `renameProperty` method inside the migration block.

>It's important to make sure that the new models have a property with the new name and don’t have a property with the old name.
```Swift
if oldSchemaVersion < 2 {
    migration.renameProperty(onType: Person.className(), from: "name", to: "fullName")
}
```

## V3 (Logic example)

**Separate the `fullName` property into `firstName` and `lastName`.**
> The migration is very similar to what we've done when adding the `email` property.

> Enumerate each `Person` and apply any necessary migration logic.
Don't forget to increase the schema version as well.

```Swift
if oldSchemaVersion < 3 {
    migration.enumerateObjects(ofType: Person.className()) { (oldPerson, newPerson) in
        guard let fullname = oldPerson?["fullName"] as? String else {
            fatalError("fullName is not a string")
        }
        let nameComponents = fullname.components(separatedBy: " ")
        if nameComponents.count == 2 {
            newPerson?["firstName"] = nameComponents.first
            newPerson?["lastName"] = nameComponents.last
        } else {
            newPerson?["firstName"] = fullname
        }
    }
}
```

## Migration (0 -> 3)

**Migration.swift**

```Swift
import Foundation
import RealmSwift

final class Migration {
    // MARK: - Properties
    static let currentSchemaVersion: UInt64 = 3
    
    // MARK: - Static Methods
    static func configure() {
        let config = Realm.Configuration(schemaVersion: currentSchemaVersion, migrationBlock: { (migration, oldSchemaVersion) in
            if oldSchemaVersion < 1 {
                migrateFrom0To1(with: migration)
            }
            
            if oldSchemaVersion < 2 {
                migrateFrom1To2(with: migration)
            }
            
            if oldSchemaVersion < 3 {
                migrateFrom2To3(with: migration)
            }
        })
        Realm.Configuration.defaultConfiguration = config
    }
    
    // MARK: - Migrations
    static func migrateFrom0To1(with migration: Migration) {
        // Add an email property
        migration.enumerateObjects(ofType: Person.className()) { (_, newPerson) in
            newPerson?["email"] = ""
        }
    }
    
    static func migrateFrom1To2(with migration: Migration) {
        // Rename name to fullname
        migration.renameProperty(onType: Person.className(), from: "name", to: "fullName")
    }
    
    static func migrateFrom2To3(with migration: Migration) {
        // Replace fullname with firstName and lastName
        migration.enumerateObjects(ofType: Person.className()) { (oldPerson, newPerson) in
            guard let fullname = oldPerson?["fullName"] as? String else {
                fatalError("fullName is not a string")
            }
            let nameComponents = fullname.components(separatedBy: " ")
            if nameComponents.count == 2 {
                newPerson?["firstName"] = nameComponents.first
                newPerson?["lastName"] = nameComponents.last
            } else {
                newPerson?["firstName"] = fullname
            }
        }
    }
}
```


**AppDelegate.swift** 

In AppDelegate's `didFinishLaunchingWithOptions`, please add
```Swift
Migration.configure()
```

You are now done.
The `if (oldSchemaVersion < X)` calls ensures that users will pass through all necessary upgrades, no matter which schema version they start from. In addition, you take care of users who skipped versions of your app.
