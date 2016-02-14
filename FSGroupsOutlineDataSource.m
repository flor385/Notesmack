//
//  FSGroupsOutlineDataSource.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 7.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSGroupsOutlineDataSource.h"
#import "NSTreeController_Extensions.h"
#import "NSTreeNode_Extensions.h"
#import "FSNotesTableDataSource.h"
#import "FSNote.h"
#import "FSGroup.h"

NSString* ESNodeIndexPathPasteBoardType = @"ESNodeIndexPathPasteBoardType";

@implementation FSGroupsOutlineDataSource

-(void)awakeFromNib{
	[outlineView registerForDraggedTypes:
	 [NSArray arrayWithObjects:ESNodeIndexPathPasteBoardType, FSNoteIDURIsArrayPBType, nil]];
}


- (BOOL)outlineView:(NSOutlineView *)outlineView 
		 writeItems:(NSArray*)items 
	   toPasteboard:(NSPasteboard *)pasteBoard;
{
	[pasteBoard declareTypes:[NSArray arrayWithObject:ESNodeIndexPathPasteBoardType] 
					   owner:self];
	[pasteBoard setData:[NSKeyedArchiver archivedDataWithRootObject:[items valueForKey:@"indexPath"]]
				forType:ESNodeIndexPathPasteBoardType];
	return YES;
}

- (NSDragOperation)outlineView:(NSOutlineView*)anOutlineView 
				  validateDrop:(id <NSDraggingInfo>)info
				  proposedItem:(id)proposedParentItem 
			proposedChildIndex:(NSInteger)proposedChildIndex
{
	NSPasteboard* pboard = [info draggingPasteboard];
	NSArray* pboardTypes = [pboard types];
	
	// Notes being dragged
	if([pboardTypes containsObject:FSNoteIDURIsArrayPBType]){
		
		// if the proposedChildIndex is a valid value, that suggests a drop in between of items
		// this is not acceptable when dropping a note over a group, so indicate that
		if (proposedChildIndex != -1)
			return NSDragOperationNone;
		
		// dragging is OK only if dragging to a group that is NOT the group
		// that the dragged items belong to
		NSManagedObject* group = [((NSTreeNode*)proposedParentItem) representedObject];
		if(group == nil)
			return NSDragOperationNone;
		NSArray* noteURIs = [NSKeyedUnarchiver 
							 unarchiveObjectWithData:[pboard dataForType:FSNoteIDURIsArrayPBType]];
		FSNote* firstNote = (FSNote*)[appDelegate objectForURI:[noteURIs objectAtIndex:0]];
		if(group == firstNote.group)
			return NSDragOperationNone;
		
		
		// the type of drag depends on the modifier key
		if([info draggingSourceOperationMask] == NSDragOperationCopy)
			return NSDragOperationCopy;
		else
			return NSDragOperationGeneric;
	}
	
	// Groups being dragged (reorganized)
	else if([pboardTypes containsObject:ESNodeIndexPathPasteBoardType]){
		
		// will be -1 if the mouse is hovering over a leaf node
		if(proposedChildIndex == -1){
			if(proposedParentItem != nil)
				[anOutlineView setDropItem:proposedParentItem dropChildIndex:0];
			else
				return NSDragOperationNone;
		}
		
		NSArray *draggedIndexPaths = [NSKeyedUnarchiver unarchiveObjectWithData:
									  [[info draggingPasteboard] 
									   dataForType:ESNodeIndexPathPasteBoardType]];
		
		// check if the drop target is valid
		BOOL targetIsValid = YES;
		for(NSIndexPath* indexPath in draggedIndexPaths) {
			NSTreeNode* node = [groupsController nodeAtIndexPath:indexPath];
			if(!node.isLeaf){
				if([proposedParentItem isDescendantOfNode:node] || proposedParentItem == node){
					targetIsValid = NO;
					break;
				}
			}
		}
		return targetIsValid ? NSDragOperationMove : NSDragOperationNone;
	}
	
	return NSDragOperationNone;
}

- (BOOL)outlineView:(NSOutlineView*)outlineView 
		 acceptDrop:(id <NSDraggingInfo>)info 
			   item:(id)proposedParentItem 
		 childIndex:(NSInteger)proposedChildIndex
{
	NSPasteboard* pboard = [info draggingPasteboard];
	NSArray* pboardTypes = [pboard types];
	
	// Notes being dragged
	if([pboardTypes containsObject:FSNoteIDURIsArrayPBType]){
		
		// the group dragged to
		FSGroup* group = [((NSTreeNode*)proposedParentItem) representedObject];
		
		// the URIs of Notes being dragged
		NSArray* noteURIs = [NSKeyedUnarchiver 
							 unarchiveObjectWithData:[pboard dataForType:FSNoteIDURIsArrayPBType]];
		
		NSUndoManager* um = [[group managedObjectContext] undoManager];
		
		// the data changes is performed as a single undoable op
		[um beginUndoGrouping];
		
		// if we need to copy the notes, then create new notes, copy values and add to the right group
		if([info draggingSourceOperationMask] == NSDragOperationCopy)
			for(NSURL* noteURI in noteURIs){
				FSNote* note = (FSNote*)[appDelegate objectForURI:noteURI];
				NSDictionary* noteValues = [note dictRepresentation];
				FSNote* newNote = (FSNote*)[NSEntityDescription insertNewObjectForEntityForName:@"Note"
																 inManagedObjectContext:[group managedObjectContext]];
				[newNote setValuesForKeysWithDictionary:noteValues];
				newNote.group = group;
			}
		
		// otherwise simply change the group relationship
		else
			for(NSURL* noteURI in noteURIs){
				FSNote* note = (FSNote*)[appDelegate objectForURI:noteURI];
				note.group = group;
			}
		
		[um endUndoGrouping];
		
		return YES;
	}
	
	// Groups being dragged (reorganized)
	else if([pboardTypes containsObject:ESNodeIndexPathPasteBoardType]){
		
		// if the proposed child index is -1, refuse
		if(proposedChildIndex == -1)
			return NO;
		
		NSArray *droppedIndexPaths = [NSKeyedUnarchiver unarchiveObjectWithData:
									  [[info draggingPasteboard] dataForType:
									   ESNodeIndexPathPasteBoardType]];
		
		NSMutableArray *draggedNodes = [NSMutableArray array];
		for (NSIndexPath *indexPath in droppedIndexPaths)
			[draggedNodes addObject:[groupsController nodeAtIndexPath:indexPath]];
		
		NSIndexPath *proposedParentIndexPath;
		if (!proposedParentItem)
			proposedParentIndexPath = [[[NSIndexPath alloc] init] autorelease];
		else
			proposedParentIndexPath = [proposedParentItem indexPath];
		
		[groupsController moveNodes:draggedNodes 
					  toIndexPath:[proposedParentIndexPath indexPathByAddingIndex:proposedChildIndex]];
		return YES;
	}
	
	return NO;
}

@end
