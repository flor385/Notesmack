//
//  FSNotesTableDataSource.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 11.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSNotesTableDataSource.h"
#import "FSNote.h"

NSString* const FSNoteIDURIsArrayPBType = @"FSNoteIDURIsArrayPBType";

@implementation FSNotesTableDataSource

- (BOOL)tableView:(NSTableView *)aTableView 
writeRowsWithIndexes:(NSIndexSet *)indices 
	 toPasteboard:(NSPasteboard *)pboard
{
	
	NSArray* arrangedNotes = [notesController arrangedObjects];
	
	// copy the IDs of notes pointed to by the index set
	NSMutableArray* noteURIs = [[NSMutableArray new] autorelease];
	for(NSUInteger index = [indices firstIndex] ; index != NSNotFound ; 
		index = [indices indexGreaterThanIndex:index])
	{
		FSNote* note = [arrangedNotes objectAtIndex:index];
		[noteURIs addObject:[[note objectID] URIRepresentation]];
	}
	
	// add the URIs to the pasteboard
	NSData* noteURIsData = [NSKeyedArchiver archivedDataWithRootObject:noteURIs];
	[pboard declareTypes:[NSArray arrayWithObject:FSNoteIDURIsArrayPBType] 
				   owner:self];
	[pboard setData:noteURIsData
			forType:FSNoteIDURIsArrayPBType];
	
	return YES;
}

@end
