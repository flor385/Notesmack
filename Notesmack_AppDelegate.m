//
//  Notesmack_AppDelegate.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 7.
//  Copyright FloCo 2009 . All rights reserved.
//

#import "Notesmack_AppDelegate.h"
#import "FSNote.h"
#import "FSDoneNotesDeleter.h"

@implementation Notesmack_AppDelegate


/**
    Returns the support folder for the application, used to store the Core Data
    store file.  This code uses a folder named "Notesmack" for
    the content, either in the NSApplicationSupportDirectory location or (if the
    former cannot be found), the system's temporary directory.
 */

#pragma mark -
#pragma mark Auto-generated methods

- (NSString *)applicationSupportFolder {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"Notesmack"];
}


/**
    Creates, retains, and returns the managed object model for the application 
    by merging all of the models found in the application bundle.
 */
 
- (NSManagedObjectModel *)managedObjectModel {

    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
    Returns the persistent store coordinator for the application.  This 
    implementation will create and return a coordinator, having added the 
    store for the application to it.  (The folder for the store is created, 
    if necessary.)
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {

    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }

    NSFileManager *fileManager;
    NSString *applicationSupportFolder = nil;
    NSURL *url;
    NSError *error;
    
    fileManager = [NSFileManager defaultManager];
    applicationSupportFolder = [self applicationSupportFolder];
    if ( ![fileManager fileExistsAtPath:applicationSupportFolder isDirectory:NULL] ) {
        [fileManager createDirectoryAtPath:applicationSupportFolder attributes:nil];
    }
    
    url = [NSURL fileURLWithPath: [applicationSupportFolder stringByAppendingPathComponent: @"Notesmack.sqlite"]];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] 
								  initWithManagedObjectModel: [self managedObjectModel]];
    
	// add a persistent store, use automatic migration
	NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
								forKey:NSMigratePersistentStoresAutomaticallyOption];
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
												  configuration:nil 
															URL:url 
														options:optionsDictionary 
														  error:&error]){
        [[NSApplication sharedApplication] presentError:error];
    }    

    return persistentStoreCoordinator;
}


/**
    Returns the managed object context for the application (which is already
    bound to the persistent store coordinator for the application.) 
 */
 
- (NSManagedObjectContext *) managedObjectContext {

    if (managedObjectContext != nil) {
        return managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

-(NSManagedObject*)objectForURI:(NSURL*)objectURI
{
	NSManagedObjectID* objectID = 
		[[self persistentStoreCoordinator] managedObjectIDForURIRepresentation:objectURI];
	return [[self managedObjectContext] objectWithID:objectID];
}


/**
    Returns the NSUndoManager for the application.  In this case, the manager
    returned is that of the managed object context for the application.
 */
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self managedObjectContext] undoManager];
}


/**
    Performs the save action for the application, which is to send the save:
    message to the application's managed object context.  Any encountered errors
    are presented to the user.
 */
 
- (IBAction) saveAction:(id)sender {
	
	[groupsController commitEditing];
	[notesController commitEditing];

    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}


/**
    Implementation of the applicationShouldTerminate: method, used here to
    handle the saving of changes in the application managed object context
    before the application terminates.
 */
 
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	
	// delete done notes if necessary
	[FSDoneNotesDeleter checkAndDeleteAsNecessary:self];

    NSError *error;
    int reply = NSTerminateNow;
    
    if (managedObjectContext != nil) {
        if ([managedObjectContext commitEditing]) {
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
				
                // This error handling simply presents error information in a panel with an 
                // "Ok" button, which does not include any attempt at error recovery (meaning, 
                // attempting to fix the error.)  As a result, this implementation will 
                // present the information to the user and then follow up with a panel asking 
                // if the user wishes to "Quit Anyway", without saving the changes.

                // Typically, this process should be altered to include application-specific 
                // recovery steps.  

                BOOL errorResult = [[NSApplication sharedApplication] presentError:error];
				
                if (errorResult == YES) {
                    reply = NSTerminateCancel;
                } 

                else {
					
                    int alertReturn = NSRunAlertPanel(nil, @"Could not save changes while quitting. Quit anyway?" 
													  , @"Quit anyway", @"Cancel", nil);
                    if (alertReturn == NSAlertAlternateReturn) {
                        reply = NSTerminateCancel;	
                    }
                }
            }
        } 
        
        else {
            reply = NSTerminateCancel;
        }
    }
    
    return reply;
}

#pragma mark -
#pragma mark Responding to cut copy and paste

/*
 On the application level cut copy and paste can only be
 performed with notes
 */

static NSString* NotesPBoardType = @"NotesPBoardType";

-(void)copy:(id)sender
{
	// get the selected notes
	NSArray *selectedObjects = [notesController selectedObjects];
    NSUInteger count = [selectedObjects count];
    if(count == 0)
		return;
	
	// prepare an array of dict representations of notes
	NSMutableArray *copyObjectsArray = [NSMutableArray arrayWithCapacity:count];
	NSMutableArray *copyStringsArray = [NSMutableArray arrayWithCapacity:count];
	for(FSNote *note in selectedObjects){
		[copyObjectsArray addObject:[note dictRepresentation]];
		[copyStringsArray addObject:[note stringRepresentation]];
	}
		
	// add this to the pasteboard
	NSPasteboard *generalPasteboard = [NSPasteboard generalPasteboard];
	[generalPasteboard declareTypes:[NSArray arrayWithObjects:NotesPBoardType, NSStringPboardType, nil]
							  owner:self];
	NSData *copyData = [NSKeyedArchiver archivedDataWithRootObject:copyObjectsArray];
	[generalPasteboard setData:copyData forType:NotesPBoardType];
	NSString* copyString = [copyStringsArray componentsJoinedByString:@"\n"];
	[generalPasteboard setString:copyString forType:NSStringPboardType];
}

- (void)paste:sender
{
	// check if it can be done
	if(![notesController canAdd]){
		NSBeep();
		return;
	}
	
	// get the pasteboard data
    NSPasteboard* generalPasteboard = [NSPasteboard generalPasteboard];
    NSData* data = [generalPasteboard dataForType:NotesPBoardType];
    if(data == nil){
		NSBeep();
		return;
    }
	NSArray* notesArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	
	// get the group to insert a note into
	NSArray* selectedGroups = [groupsController selectedObjects];
	if([selectedGroups count] != 1){
		NSBeep();
		return;
	}
	FSGroup* selectedGroup = [selectedGroups objectAtIndex:0];
   
	// we need the context to create records in, and the undo manager to group the undo actions
	NSManagedObjectContext *moc = [selectedGroup managedObjectContext];
	NSUndoManager* um = [moc undoManager];
	
	// track newly created notes, to be able to select them once the adding is done
	NSMutableArray* newNotes = [NSMutableArray arrayWithCapacity:[notesArray count]];
	
	// for each dict from the pasteboard, create and insert a note
	[um beginUndoGrouping];
    for(NSDictionary* noteDict in notesArray) {
        
		// create a note
		FSNote* newNote;
        newNote = (FSNote*)[NSEntityDescription insertNewObjectForEntityForName:@"Note"
														 inManagedObjectContext:moc];
		
		// set it's values
		[newNote setValuesForKeysWithDictionary:noteDict];
		[newNote setGroup:selectedGroup];
		[newNotes addObject:newNote];
    }
	[um endUndoGrouping];
	
	// make sure that the objects are properly arranged
	[notesController rearrangeObjects];
	
	// select the pasted records
	[notesController setSelectedObjects:newNotes];
}

-(void)cut:(id)sender
{
	// copy
	[self copy:sender];
	
	// find the selected items
	NSArray* selectedNotes = [notesController selectedObjects];
	if([selectedNotes count] == 0)
		return;
	
	// we will need these
	NSManagedObjectContext *moc = [notesController managedObjectContext];
	NSUndoManager* um = [moc undoManager];
	
	// delete the cut items as one undoable action
	[um beginUndoGrouping];
	for(FSNote* note in selectedNotes)
		[moc deleteObject:note];
	[um endUndoGrouping];
}

- (BOOL)validateMenuItem:(NSMenuItem*)item {
    
	SEL selector = [item action];
	
	// cut and copy
	if(selector == @selector(copy:) || selector == @selector(cut:))
		return [notesController canRemove];
	
	if(selector == @selector(paste:)){
		
		// can the controller accept a paste?
		if(![notesController canInsert])
			return NO;
		
		// do we have data to paste
		NSPasteboard* pb = [NSPasteboard generalPasteboard];
		return [pb availableTypeFromArray:[NSArray arrayWithObject:NotesPBoardType]] != nil;
	}
	
	if(selector == @selector(saveAction:))
		return YES;
	
	return NO;
}

#pragma mark -
#pragma mark Managed context change observing

-(id)init
{
	if(self == [super init]){
		contextHasChanges = NO;
	}
	
	return self;
}

-(void)awakeFromNib
{
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self 
		   selector:@selector(contextDidChange:) 
			   name:NSManagedObjectContextObjectsDidChangeNotification 
			 object:[self managedObjectContext]];
	[nc addObserver:self 
		   selector:@selector(contextDidSave:) 
			   name:NSManagedObjectContextDidSaveNotification 
			 object:[self managedObjectContext]];
}

-(void)contextDidChange:(NSNotification*)n
{
	[self willChangeValueForKey:@"contextHasChanges"];
	contextHasChanges = [[self managedObjectContext] hasChanges];
	[self didChangeValueForKey:@"contextHasChanges"];
}

-(void)contextDidSave:(NSNotification*)n
{
	[self willChangeValueForKey:@"contextHasChanges"];
	contextHasChanges = NO;
	[self didChangeValueForKey:@"contextHasChanges"];
}

-(BOOL)contextHasChanges
{
	return contextHasChanges;
}

#pragma mark -
 
- (void) dealloc {

    [managedObjectContext release], managedObjectContext = nil;
    [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
    [managedObjectModel release], managedObjectModel = nil;
    [super dealloc];
}


@end
