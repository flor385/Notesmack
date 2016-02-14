//
//  FSNotesFiler.h
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 24.
//  Copyright 2009 FloCo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FSNotesFilter : NSObject {

	// the array controller we are filtering
	IBOutlet NSArrayController* toFilter;
	
	// outlets to views that are affecting the filter
	IBOutlet NSSearchField* toolbarSearchField;
	IBOutlet NSTreeController* groupsController;
	
	// filtering properties
	NSPredicate* searchFieldPredicate;
	NSArray* selectedGroupNodes;
	NSNumber* showDoneNotes;
	NSNumber* showAllNotes;
}

@property(retain) NSPredicate* searchFieldPredicate;
@property(retain) NSArray* selectedGroupNodes;
@property(copy) NSNumber* showDoneNotes;
@property(copy) NSNumber* showAllNotes;

-(void)updateControllerFilter;

@end
