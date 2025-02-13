//
//  Note.swift
//  MyTodoList
//
//  Created by Jakaria Noman on 16/1/25.
//

//To Access data File Path , first Open Finder.
//Then Command + SHift + G -> This will open a dialog box
//Then Enter the Full Path or Specific path.


/*Core Data and PersistentCointer
 
 Core Data is indeed an Apple framework that helps manage and persist data in iOS, macOS, and other Apple platforms.
 Using Core Data, you can store and manage your app’s data in a persistent container, which is part of Core Data's architecture.
 
 Common Core Data Operations:
1. Fetching: Retrieving objects from the persistent store, either all objects of a certain type or
   using predicates (filters) to narrow down results.
  Example:
  let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
  let users = try context.fetch(fetchRequest)
 
 2. Inserting: Creating new managed objects (entities).
   Example:
   let user = User(context: context)
   user.name = "John Doe"
 
 3. Deleting: Removing objects from the context.
   Example:
   context.delete(user)
 
 4. Saving: Persisting any changes in the managed object context to the underlying persistent store.
   Example:
   try context.save()
 */
