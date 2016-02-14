//
//  FSAppController.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 7.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSAppController.h"
#import <CoreData/CoreData.h>
#import "FSNotesmackPrefs.h"
#import "FSNote.h"
#import "FSGroup.h"
#import "FSValueTransformers.h"

@implementation FSAppController

#pragma -
#pragma Initialization (value transformer registration, user defaults...)

+(void)initialize
{	
	if(self == [FSAppController class]){
		
		[FSNotesmackPrefs initializePreferenceDefaults];
		[FSValueTransformers registerValueTransformers];
	}
}

@synthesize newNoteDefaultPriority;

-(id)init
{
	if(self == [super init]){
		
		// init
		userDefaults = [NSUserDefaults standardUserDefaults];
		udController = [NSUserDefaultsController sharedUserDefaultsController];
		
		// bind some properties
		[self bind:@"newNoteDefaultPriority"
		  toObject:udController 
	   withKeyPath:[NSString stringWithFormat:@"values.%@", FSDefaultNotePriorityPref] 
		   options:nil];
	}
	
	return self;
}

#pragma mark -
#pragma mark Initialization

-(void)awakeFromNib
{
	// make sure that the groups outline view is sorted on the sort index
	NSSortDescriptor* sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"sortIndex" 
																	ascending:YES] autorelease];
	[groupsController setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	// bind the priority view
	[noteDetailsPriority bind:@"objectValue" 
					 toObject:notesController 
				  withKeyPath:@"selection.priority"
					  options:nil];
	
	// listen to the notes table selection changes
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self 
		   selector:@selector(notesTableSelectionDidChange:) 
			   name:NSTableViewSelectionDidChangeNotification 
			 object:notesView];
	
	// restore group and note selections from the user defaults, but delayed, once the data is loaded
	[self performSelector:@selector(initViewSelections) withObject:nil afterDelay:(NSTimeInterval)0.0f];
	
	// observe the app quitting, to be able to save the current selections as user defaults
	[nc addObserver:self 
		   selector:@selector(appWillTerminate:) 
			   name:NSApplicationWillTerminateNotification 
			 object:nil];
	
	// handle first run
	[self handleFirstRun];
}

-(void)appWillTerminate:(NSNotification*)notification
{
	[self storeViewSelections];
}


-(void)handleFirstRun
{
	if(![userDefaults boolForKey:FSIsFirstRunPref])
		return;
	
	// if we are here, this is the first run (at least according to the prefs) of notesmack
	// so create some data
	
	// get the object context to insert new objects into
	// and disable undo registartion
	NSManagedObjectContext* moc = [appDelegate managedObjectContext];
	[[moc undoManager] disableUndoRegistration];
	
	// create one group and one note
	FSGroup* firstGroup = [NSEntityDescription insertNewObjectForEntityForName:@"Group" 
														inManagedObjectContext:moc];
	firstGroup.sortIndex = [NSNumber numberWithInt:0];
	firstGroup.name = @"First group";
	FSNote* firstNote = [NSEntityDescription insertNewObjectForEntityForName:@"Note" 
													  inManagedObjectContext:moc];
	firstNote.group = firstGroup;
	firstNote.title = @"Welcome to Notesmack!";
	firstNote.details = @"This is an automatically created Note.";
	firstNote.priority = [NSNumber numberWithInt:3];
	
	// we are done with creating data, so enable undo registartion
	[[moc undoManager] enableUndoRegistration];
	
	// save changes!
	[appDelegate saveAction:self];
	
	// make sure we don't do this again
	[userDefaults setBool:NO forKey:FSIsFirstRunPref];
	
	// make sure the notes get selected on first run
	[userDefaults setValue:[NSArray arrayWithObject:[NSIndexPath indexPathWithIndex:0]]
					forKey:FSGroupsSelectedIndexPathsPref];
	[userDefaults setValue:[NSIndexSet indexSetWithIndex:0] 
					forKey:FSNotesSelectedRowIndicesPref];
}

#pragma mark -
#pragma mark Actions

-(IBAction)changeNotePriority:(id)sender
{
	NSInteger tag = [sender tag];
	[notesController commitEditing];
	[notesController setValue:[NSNumber numberWithInteger:tag] forKeyPath:@"selection.priority"];
}

-(IBAction)setNoteDone:(id)sender
{
	NSNumber* toSet = [NSNumber numberWithBool:YES];
	for(FSNote* note in [notesController selectedObjects])
		note.done = toSet;
}

-(IBAction)setNoteNotDone:(id)sender
{
	NSNumber* toSet = [NSNumber numberWithBool:NO];
	for(FSNote* note in [notesController selectedObjects])
		note.done = toSet;
}

-(IBAction)selectAndFocusOnDetails:(id)sender
{
	[noteDetailedInfoView selectAll:sender];
	[[noteDetailedInfoView window] makeFirstResponder:noteDetailedInfoView];
}

-(IBAction)showPreferences:(id)sender
{
	FSPreferencesPanelController* controller = [FSPreferencesPanelController defaultController];
	[controller showWindow:sender];
	[[controller window] center];
}

#pragma mark -
#pragma mark Selection preservation

-(void)initViewSelections
{
	// load the actual existing user prefs
	NSArray* groupsSelectedIndexPaths = [NSKeyedUnarchiver unarchiveObjectWithData:
										 [userDefaults objectForKey:FSGroupsSelectedIndexPathsPref]];
	NSIndexSet* notesSelectedRowIndices = [NSKeyedUnarchiver unarchiveObjectWithData:
										   [userDefaults objectForKey:FSNotesSelectedRowIndicesPref]];
	
	// see if the current selection reflect the selections stored in the preferences
	BOOL appropriateGroupSelected = [groupsSelectedIndexPaths isEqualToArray:[groupsController selectionIndexPaths]];
	BOOL selectionsReflectPreferences = appropriateGroupSelected &&
		[notesSelectedRowIndices isEqualToIndexSet:[notesController selectionIndexes]];
	
	// if not, apply the preference selections
	if(!selectionsReflectPreferences){
		[groupsController setSelectionIndexPaths:groupsSelectedIndexPaths];
		[groupsView scrollRowToVisible:[groupsView selectedRow]];
		[notesController setSelectionIndexes:notesSelectedRowIndices];
		[notesView scrollRowToVisible:[notesView selectedRow]];
		
		// do this recursively, until the selections *DO* reflect the selections stored in prefs
		[self performSelector:@selector(initViewSelections) withObject:nil afterDelay:(NSTimeInterval)0.0f];
	}
}

-(void)storeViewSelections
{
	NSArray* groupsSelectionPaths = [groupsController selectionIndexPaths];
	NSIndexSet* notesSelectionIndexes = [notesController selectionIndexes];
	
	[userDefaults setValue:[NSKeyedArchiver archivedDataWithRootObject:groupsSelectionPaths]
					forKey:FSGroupsSelectedIndexPathsPref];
	[userDefaults setValue:[NSKeyedArchiver archivedDataWithRootObject:notesSelectionIndexes]
					forKey:FSNotesSelectedRowIndicesPref];
}

#pragma mark -
#pragma mark Notes table selection observing

-(void)notesTableSelectionDidChange:(NSNotification*)n
{
	[self performSelector:@selector(scrollNoteDetailsViewToTop) withObject:nil afterDelay:(NSTimeInterval)0.0f];
}

-(void)scrollNoteDetailsViewToTop
{
	NSView* documentView = [noteDetailsScrollView documentView];
	NSPoint pointToScrollTo = NSMakePoint(0.0f, [documentView bounds].size.height);
	[documentView scrollPoint:pointToScrollTo];
}

#pragma mark -
#pragma mark Note details text view delegate methods

static BOOL isCommittingEditing = NO;

-(BOOL)textShouldEndEditing:(NSText*)aTextObject
{

	if(!isCommittingEditing){
		isCommittingEditing = YES;
		[notesController commitEditing];
		isCommittingEditing = NO;
	}
	return YES;
}

#pragma mark -
#pragma mark Record adding logic

-(IBAction)addGroup:(id)sender;
{
	if(![groupsController canAdd])
		return;
	
	[groupsController setSelectionIndexPath:nil];
	[groupsController add:sender];
	[self performSelector:@selector(startEditingSelectedGroupName) withObject:nil afterDelay:0];
}

-(IBAction)addSubgroup:(id)sender
{
	if(![groupsController canAddChild])
		return;
	
	[groupsController addChild:sender];
	[self performSelector:@selector(startEditingSelectedGroupName) withObject:nil afterDelay:0];
}

-(void)startEditingSelectedGroupName
{
	[groupsView editColumn:0 row:[groupsView selectedRow] withEvent:nil select:YES];
}

-(IBAction)addNote:(id)sender
{
	// check if it is possible to insert new objects
	if(![notesController canAdd] && [[groupsController selectedNodes] count] < 1)
		return;
	
	// create a new note
	NSManagedObjectContext* moc = [appDelegate managedObjectContext];
	[[moc undoManager] beginUndoGrouping];
	FSNote* newNote = [NSEntityDescription
									 insertNewObjectForEntityForName:@"Note"
									 inManagedObjectContext:moc];
	newNote.group = [[[groupsController selectedNodes] objectAtIndex:0] representedObject];
	newNote.priority = newNoteDefaultPriority;
	[[moc undoManager] endUndoGrouping];
	
	// insert the notes controller in the arranged context
	[notesController setSelectedObjects:[NSArray arrayWithObject:newNote]];
	[self performSelector:@selector(startEditingSelectedNoteName) withObject:nil afterDelay:0];
}

-(void)startEditingSelectedNoteName
{
	NSUInteger noteTitleColumn = [notesView columnWithIdentifier:@"title"];
	[notesView editColumn:noteTitleColumn row:[notesView selectedRow] withEvent:nil select:YES];
}

#pragma mark -
#pragma mark Record deletion logic

-(IBAction)deleteSelectedNotes:(id)sender
{
	[self deleteNotes:[notesController selectedObjects]];
}

-(void)deleteNotes:(NSArray*)notes
{
	NSManagedObjectContext* moc = [appDelegate managedObjectContext];
	for(id note in notes)
		[moc deleteObject:note];
}

-(IBAction)deleteSelectedGroup:(id)sender
{
	NSArray* selectedGroups = [groupsController selectedObjects];
	if([selectedGroups count] == 0){
		NSBeep();
		return;
	}else
		[self deleteGroup:[selectedGroups objectAtIndex:0]];
}

-(void)deleteGroup:(FSGroup*)group
{
	NSUInteger numberOfItems = [group countOfItems];
	
	// if there are no notes in the group, delete without warning
	if(numberOfItems == 0){
		[[group managedObjectContext] deleteObject:group];
		return;
	}
	
	// if there are notes related in the group, ask the user to confirm deletion
	NSString* title = [NSString stringWithFormat:@"Are you sure you want to delete \"%@\"?",
					   group.name];
	NSString* message = [NSString stringWithFormat:
						 @"The \"%@\" group contains %d Notes that will be deleted as well.",
						 group.name, numberOfItems];
	
	// display a sheet
	NSBeginAlertSheet(title, @"Delete", @"Cancel", nil, [groupsView window], 
					  self, @selector(deleteGroupSheetDidEndShouldDelete:returnCode:contextInfo:),
					  nil, group, message);
}

- (void)deleteGroupSheetDidEndShouldDelete: (NSWindow *)sheet
								returnCode: (int)returnCode
							   contextInfo: (void *)contextInfo
{
	if (returnCode != NSAlertDefaultReturn)
		return;
	
	FSGroup* group = contextInfo;
	[[group managedObjectContext] deleteObject:group];
}

#pragma mark -
#pragma mark Action item validation

-(BOOL)validateMenuItem:(NSMenuItem*)item
{
	SEL action = [item action];
	
	if(action == @selector(addNote:))
		return [notesController canAdd] && [[groupsController selectedNodes] count] > 0;
	
	if(action == @selector(addGroup:))
		return [groupsController canAdd];
	
	if(action == @selector(addSubgroup:))
		return [groupsController canAdd];
	
	if(action == @selector(setNoteDone:)){
		for(FSNote* note in [notesController selectedObjects])
			if(![note.done boolValue])
				return YES;
		return NO;
	}
	
	if(action == @selector(setNoteNotDone:)){
		for(FSNote* note in [notesController selectedObjects])
			if([note.done boolValue])
				return YES;
		return NO;
	}
	
	if(action == @selector(changeNotePriority:)){
		
		[item setState:NSOffState];
		NSInteger menuItemTag = [item tag];
		
		// get the clicked / selected notes
		// if there aren't any, make the item disabled
		NSArray* selectedNotes = [notesController selectedObjects];
		if([selectedNotes count] == 0)
			return NO;
		
		// look for a note with the same priority as the one represented by this item
		// and make it checked (NSOnState)
		for(FSNote* note in selectedNotes)
			if([note.priority integerValue] == menuItemTag)
				[item setState:NSOnState];
		
		return YES;
	}
	
	if(action == @selector(selectAndFocusOnDetails:)){
		return [[notesController selectedObjects] count] == 1;
	}
	
	return YES;
}

@end
