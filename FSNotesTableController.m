//
//  FSNotesTableController.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 8.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSNotesTableController.h"
#import "FSPriorityCell.h"
#import "FSNote.h"
#import "FSNotesmackPrefs.h"

@implementation FSNotesTableController

-(void)awakeFromNib
{
	// create a priority cell
	NSCell* priorityCell = [[FSPriorityCell new] autorelease];
	[priorityCell setTarget:self];
	[priorityCell setAction:@selector(priorityCellAction:)];
	[priorityCell setContinuous:YES];
	[priorityColumn setDataCell:priorityCell];
	
	// and the done cell
	NSButtonCell* doneCell = [[NSButtonCell new] autorelease];
	[doneCell setButtonType:NSSwitchButton];
	[doneCell setControlSize:NSSmallControlSize];
	[doneCell setTitle:nil];
	[doneCell setTarget:self];
	[doneCell setAction:@selector(doneCellAction:)];
	[doneCell setImagePosition:NSImageOnly];
	[doneColumn setDataCell:doneCell];
	
	// hide the group name column if necessary
	udController = [NSUserDefaultsController sharedUserDefaultsController];
	NSString* controllerKey = [NSString stringWithFormat:@"values.%@", FSViewAllNotesPref];
	[groupNameColumn setHidden:![[udController valueForKeyPath:controllerKey] boolValue]];
	[udController addObserver:self forKeyPath:controllerKey options:0 context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath 
					 ofObject:(id)object 
					   change:(NSDictionary *)change 
					  context:(void *)context
{
	NSString* viewAllNotesControllerKeypath = [NSString stringWithFormat:@"values.%@", FSViewAllNotesPref];
	if(udController == object && [keyPath isEqualToString:viewAllNotesControllerKeypath]){
		
		NSNumber* viewingAll = [udController valueForKeyPath:viewAllNotesControllerKeypath];
		[groupNameColumn setHidden:![viewingAll boolValue]];
	}
}


-(void)priorityCellAction:(id)sender
{
	NSEvent* currentEvent = [NSApp currentEvent];
	NSTableView* tableView = [priorityColumn tableView];
	NSPoint pointInView = [tableView convertPoint:[currentEvent locationInWindow] fromView:nil];
	
	NSRect cellRect = [tableView frameOfCellAtColumn:[tableView columnAtPoint:pointInView] 
												 row:[tableView rowAtPoint:pointInView]];
	NSRect drawRect = [((NSCell*)[priorityColumn dataCell]) drawingRectForBounds:cellRect];
	
	if(NSPointInRect(pointInView, drawRect)){
		// determine the priority that was clicked
		float oneRatingWidth = drawRect.size.height;
		int rating = (int)((pointInView.x - drawRect.origin.x) / oneRatingWidth) + 1;
		NSInteger row = [tableView rowAtPoint:pointInView];
		[notesController setSelectionIndex:row];
		[[notesController selection] setValue:[NSNumber numberWithInt:rating] forKey:@"priority"];
	}
}

-(void)doneCellAction:(id)sender
{
	NSEvent* currentEvent = [NSApp currentEvent];
	NSTableView* tableView = [doneColumn tableView];
	NSPoint pointInView = [tableView convertPoint:[currentEvent locationInWindow] fromView:nil];
	NSInteger row = [tableView rowAtPoint:pointInView];
	[notesController setSelectionIndex:row];
	NSNumber* oldValue = [[notesController selection] valueForKey:@"done"];
	[[notesController selection] setValue:[NSNumber numberWithBool:![oldValue boolValue]]
														   forKey:@"done"];
}

@end
