//
//  Notesmack_AppDelegate.h
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 7.
//  Copyright FloCo 2009 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Notesmack_AppDelegate : NSObject 
{
    IBOutlet NSWindow *window;
	IBOutlet NSTreeController* groupsController;
	IBOutlet NSArrayController* notesController;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
	
	BOOL contextHasChanges;
}

@property(readonly) BOOL contextHasChanges;

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator;
-(NSManagedObjectModel *)managedObjectModel;
-(NSManagedObjectContext *)managedObjectContext;
-(NSManagedObject*)objectForURI:(NSURL*)objectURI;

- (IBAction)saveAction:sender;

@end
