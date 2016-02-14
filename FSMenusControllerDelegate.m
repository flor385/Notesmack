//
//  FSContextualMenusController.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 10 5.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSMenusControllerDelegate.h"
#import "FSNote.h"
#import "FSGroup.h"

@interface FSMenusControllerDelegate (Private)

-(NSArray*)clickedSelectedNotes;
-(void)recursivelyCreateMenuItemsForGroup:(FSGroup*)group 
								isEnabled:(BOOL)enabled
								   inMenu:(NSMenu*)menu 
							  indentation:(int)indentation 
							selectedGroup:(FSGroup*)selectedGroup;

@end

@implementation FSMenusControllerDelegate (Private)

-(NSArray*)clickedSelectedNotes
{
	// get the clicked row
	// if it's -1, return an empty array
	NSInteger clickedRow = [notesView clickedRow];
	if(clickedRow == -1)
		return [NSArray array];
	
	// we have at least one object, obtain some stuff we will need
	NSIndexSet* selectedRows = [notesView selectedRowIndexes];
	NSArray* allNotes = [notesController arrangedObjects];
	
	// if the clicked row is contained in the selection,
	// then return an array containing all the selected notes
	if([selectedRows containsIndex:(NSUInteger)clickedRow]){
		
		NSMutableArray* mutableArray = [[[NSMutableArray alloc] initWithCapacity:[selectedRows count]] autorelease];
		for(NSUInteger i = [selectedRows firstIndex] ; i != NSNotFound ; i = [selectedRows indexGreaterThanIndex:i])
			[mutableArray addObject:[allNotes objectAtIndex:i]];
		return [NSArray arrayWithArray:mutableArray];
	
	// otherwise return an array containing only the clicked note
	}else{
		return [NSArray arrayWithObject:[allNotes objectAtIndex:clickedRow]];
	}
}

-(void)recursivelyCreateMenuItemsForGroup:(FSGroup*)group 
								isEnabled:(BOOL)enabled
								   inMenu:(NSMenu*)menu 
							  indentation:(int)indentation 
							selectedGroup:(FSGroup*)selectedGroup
{
	// create the item for the given group
	SEL action = menu == groupsContextualMenu ? 
		@selector(changeClickedNotesGroup:) : @selector(changeSelectedNotesGroup:);
	NSMenuItem* item = [[[NSMenuItem alloc] initWithTitle:group.name 
												   action:action
											keyEquivalent:@""] autorelease];
	[item setIndentationLevel:indentation];
	[item setRepresentedObject:group];
	[item setTarget:self];
	[item setEnabled:enabled];
	if(group == selectedGroup)
		[item setState:NSOnState];
	[menu addItem:item];
	
	// create items for all the children
	NSArray* sortedChildren = [[group.children allObjects] sortedArrayUsingSelector:@selector(compare:)];
	for(FSGroup* child in sortedChildren)
		[self recursivelyCreateMenuItemsForGroup:child
									   isEnabled:enabled 
										  inMenu:menu 
									 indentation:indentation + 1 
								   selectedGroup:selectedGroup];
}

@end


@implementation FSMenusControllerDelegate

#pragma mark -
#pragma mark Group actions

-(IBAction)addGroup:(id)sender
{
	NSInteger clickedRow = [groupsView clickedRow];
	if(clickedRow == -1)
		[appController addGroup:self];
	else{
		[groupsView selectRow:clickedRow byExtendingSelection:NO];
		[appController addSubgroup:self];
	}
}

-(IBAction)deleteClickedGroups:(id)sender
{
	NSInteger clickedRow = [groupsView clickedRow];
	if(clickedRow == -1)
		return;
	
	NSIndexSet* selectedRows = [groupsView selectedRowIndexes];
	
	// if the clickedRow is among the selected rows, delete all the selected groups
	// if the clickedRow is not among the selected rows, only delete that one
	if([selectedRows containsIndex:(NSUInteger)clickedRow])
		[appController deleteSelectedGroup:self];
	else{
		NSTreeNode* clickedGroupNode = [groupsView itemAtRow:clickedRow];
		id clickedGroup = [clickedGroupNode representedObject];
		[appController deleteGroup:clickedGroup];
	}
}

#pragma mark -
#pragma mark Note actions

-(IBAction)deleteClickedNotes:(id)sender
{
	NSInteger clickedRow = [notesView clickedRow];
	if(clickedRow == -1)
		return;
	
	NSIndexSet* selectedRows = [notesView selectedRowIndexes];
	
	// if the clickedRow is among the selected rows, delete all the selected notes
	// if the clickedRow is not among the selected rows, only delete that one
	if([selectedRows containsIndex:(NSUInteger)clickedRow])
		[appController deleteSelectedNotes:self];
	else{
		id clickedNote = [[notesController arrangedObjects] objectAtIndex:clickedRow];
		[appController deleteNotes:[NSArray arrayWithObject:clickedNote]];
	}
}

-(IBAction)makeClickedNotesDone:(id)sender
{
	NSArray* clickedSelectedNotes = [self clickedSelectedNotes];
	if([clickedSelectedNotes count] == 0)
		return;
	
	FSNote* firstNote = [clickedSelectedNotes objectAtIndex:0];
	NSUndoManager* um = [[firstNote managedObjectContext] undoManager];
	NSNumber* valueToSet = [NSNumber numberWithBool:YES];
	
	[um beginUndoGrouping];
	for(FSNote* note in clickedSelectedNotes)
		note.done = valueToSet;
	[um endUndoGrouping];
}

-(IBAction)makeClickedNotesNotDone:(id)sender
{
	NSArray* clickedSelectedNotes = [self clickedSelectedNotes];
	if([clickedSelectedNotes count] == 0)
		return;
	
	FSNote* firstNote = [clickedSelectedNotes objectAtIndex:0];
	NSUndoManager* um = [[firstNote managedObjectContext] undoManager];
	NSNumber* valueToSet = [NSNumber numberWithBool:NO];
	
	[um beginUndoGrouping];
	for(FSNote* note in clickedSelectedNotes)
		note.done = valueToSet;
	[um endUndoGrouping];
}

-(IBAction)changeClickedNotesPriority:(id)sender
{
	NSArray* clickedSelectedNotes = [self clickedSelectedNotes];
	if([clickedSelectedNotes count] == 0)
		return;
	
	FSNote* firstNote = [clickedSelectedNotes objectAtIndex:0];
	NSUndoManager* um = [[firstNote managedObjectContext] undoManager];
	NSNumber* valueToSet = [NSNumber numberWithInteger:[sender tag]];
	
	[um beginUndoGrouping];
	for(FSNote* note in clickedSelectedNotes)
		note.priority = valueToSet;
	[um endUndoGrouping];
}

-(void)changeClickedNotesGroup:(id)sender
{
	NSArray* clickedSelectedNotes = [self clickedSelectedNotes];
	if([clickedSelectedNotes count] == 0)
		return;
	
	FSNote* firstNote = [clickedSelectedNotes objectAtIndex:0];
	NSUndoManager* um = [[firstNote managedObjectContext] undoManager];
	FSGroup* groupToSet = [sender representedObject];
	
	[um beginUndoGrouping];
	for(FSNote* note in clickedSelectedNotes)
		note.group = groupToSet;
	[um endUndoGrouping];
}

-(void)changeSelectedNotesGroup:(id)sender
{
	NSArray* clickedSelectedNotes = [notesController selectedObjects];
	if([clickedSelectedNotes count] == 0)
		return;
	
	FSNote* firstNote = [clickedSelectedNotes objectAtIndex:0];
	NSUndoManager* um = [[firstNote managedObjectContext] undoManager];
	FSGroup* groupToSet = [sender representedObject];
	
	[um beginUndoGrouping];
	for(FSNote* note in clickedSelectedNotes)
		note.group = groupToSet;
	[um endUndoGrouping];
}

#pragma mark -
#pragma mark Menu delegate methods, action validation

-(void)menuNeedsUpdate:(NSMenu*)menu
{
	if(menu == groupsContextualMenu || menu == groupsBarMenu){
		
		NSInteger numberOfItems = [menu numberOfItems];
		for(NSInteger i = 1 ; i <= numberOfItems ; i++)
			[menu removeItemAtIndex:numberOfItems - i];
		
		// get all the groups that don't have a parent item
		NSMutableArray* groupsWithoutParent = [[NSMutableArray new] autorelease];
		for(FSGroup* group in [groupsController content])
			if(group.parent == nil)
				[groupsWithoutParent addObject:group];
		
		// sort the groups
		[groupsWithoutParent sortUsingSelector:@selector(compare:)];
		
		// get the relevant notes
		NSArray* relevantNotes = menu == groupsContextualMenu ? 
			[self clickedSelectedNotes] : [notesController selectedObjects];
		NSMutableSet* selectedNoteGroups = [[NSMutableSet new] autorelease];
		for(FSNote* note in relevantNotes)
			[selectedNoteGroups addObject:note.group];
		
		FSGroup* selectedGroup = [selectedNoteGroups count] > 1 ? nil : [selectedNoteGroups anyObject];
		BOOL enabled = [relevantNotes count] > 0;
		
		// recursively create menu items
		for(FSGroup* group in groupsWithoutParent)
			[self recursivelyCreateMenuItemsForGroup:group 
										   isEnabled:enabled 
											  inMenu:menu 
										 indentation:0 
									   selectedGroup:selectedGroup];
	}
}

-(BOOL)validateMenuItem:(NSMenuItem*)item
{
	SEL action = [item action];
	
	if(action == @selector(addGroup:))
		return [groupsController canAdd];
	
	if(action == @selector(deleteClickedGroups:))
		return [groupsView clickedRow] != -1;
	
	if(action == @selector(deleteClickedNotes:))
		return [notesView clickedRow] != -1;
	
	if(action == @selector(makeClickedNotesDone:)){
		
		NSArray* clickedSelectedNotes = [self clickedSelectedNotes];
		for(FSNote* note in clickedSelectedNotes)
			if([note.done boolValue] == NO)
				return YES;
		return NO;
	}
		
	if(action == @selector(makeClickedNotesNotDone:)){
		
		NSArray* clickedSelectedNotes = [self clickedSelectedNotes];
		for(FSNote* note in clickedSelectedNotes)
			if([note.done boolValue] == YES)
				return YES;
		return NO;
	}
	
	if(action == @selector(changeClickedNotesPriority:)){
		
		[item setState:NSOffState];
		NSInteger menuItemTag = [item tag];
		
		// get the clicked / selected notes
		// if there aren't any, make the item disabled
		NSArray* clickedSelectedNotes = [self clickedSelectedNotes];
		if([clickedSelectedNotes count] == 0)
			return NO;
		
		// look for a note with the same priority as the one represented by this item
		// and make it checked (NSOnState)
		for(FSNote* note in clickedSelectedNotes)
			if([note.priority integerValue] == menuItemTag)
				[item setState:NSOnState];
				
		return YES;
	}
	
	// items in the group menus already have their enabledness prepared beforehand,
	// so obey that
	NSMenu* menu = [item menu];
	if(menu == groupsContextualMenu || menu == groupsBarMenu)
		return [item isEnabled];
		
	return YES;
}

@end
