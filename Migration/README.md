
![realm-logo](https://github.com/realm/realm-cocoa/raw/master/logo.png)

**Cool stuff coming soon........**

TODO : 
- Example project
- Heavy migration

# Lightweight Migration


```Swift
class Person: Object {
    dynamic var name = ""
    dynamic var age = 0
}
```

## Migration 1 (adding property)

Let's try to add a new `email` property in our `Person` model.
To do this, we simply change the object interface to the following:
```Swift
class Person: Object {
    dynamic var name = ""
    dynamic var age = 0
    dynamic var email = ""
}
```
Because my previous model version doesn't have the `email` property,
I can do the migration by calling `Migration`'s `enumerateObjects` method within the migration block and assign an empty email string to the existing data.
```Swift
if oldSchemaVersion < 1 {
    migration.enumerateObjects(ofType: Person.className()) { (_, newPerson) in
        newPerson?["email"] = ""
    }
}
```

## Migration 2 (rename property)

Let's rename the `name` property to `fullName`.
The migration can be done by increasing the schema version and invoking `Migration`'s `renameProperty` method inside the migration block.
It's important to make sure that the new models have a property with the new name and don’t have a property with the old name.
```Swift
if oldSchemaVersion < 2 {
    migration.renameProperty(onType: Person.className(), from: "name", to: "fullName")
}
```

## Migration 3 (Logic example)

Finally, I would like to separate the `fullName` property into `firstName` and `lastName`.
The migration is very similar to what we've done when adding the `email` property.
I enumerate each `Person` and apply any necessary migration logic.
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

