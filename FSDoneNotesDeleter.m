//
//  FSDoneNotesDeleter.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 10 19.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSDoneNotesDeleter.h"
#import "FSNotesmackPrefs.h"
#import "FSNote.h"

@implementation FSDoneNotesDeleter

+(void)checkAndDeleteAsNecessary:(Notesmack_AppDelegate*)nsad
{	
	int deletionPref = (int)[[NSUserDefaults standardUserDefaults] integerForKey:FSDeleteDoneNotesPref];
	
	// if we don't have to delete, we don't have to delete
	if(deletionPref == FSDeleteDoneNotesNever)
		return;
	
	// get all the notes
	NSManagedObjectContext* moc = [nsad managedObjectContext];
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note"
											  inManagedObjectContext:moc];
	[fetchRequest setEntity:entity];
	
	NSError *error;
	NSArray *fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
	if (fetchedObjects == nil) {
		
		[[NSApplication sharedApplication] presentError:error];
		return;
	}
	
	// figure out where the breakline for notes that should be deleted is
	NSTimeInterval delta;
	switch(deletionPref){
		case FSDeleteDoneNotesAfterOneHour : {
			delta = (NSTimeInterval)3600.0f;
			break;
		}
		case FSDeleteDoneNotesAfterOneDay :{
			delta = (NSTimeInterval)(3600.0f * 24);
			break;
		}
		case FSDeleteDoneNotesAfterOneWeek :{
			delta = (NSTimeInterval)(3600.0f * 24 * 7);
			break;
		}
		case FSDeleteDoneNotesAfterOneMonth :{
			delta = (NSTimeInterval)(3600.0f * 24 * 30);
			break;
		}
		default:{
			[NSException raise:@"Unknown FSDeleteDoneNotesPref flag" format:@"Contact developer"];
		}
	}
	NSDate* breakline = [NSDate dateWithTimeIntervalSinceNow:-delta];
	
	// go over all the notes in the array, and delete those that need deletion
	[[moc undoManager] disableUndoRegistration];
	for(FSNote* note in fetchedObjects)
		if([note.lastModified compare:breakline] == NSOrderedAscending)
			[moc deleteObject:note];
		
	[[moc undoManager] enableUndoRegistration];
}

@end