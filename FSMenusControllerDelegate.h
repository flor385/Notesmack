//
//  FSContextualMenusController.h
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 10 5.
//  Copyright 2009 FloCo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FSAppController.h"

@interface FSMenusControllerDelegate : NSObject {

	IBOutlet FSAppController* appController;
	
	IBOutlet NSArrayController* notesController;
	IBOutlet NSTreeController* groupsController;
	
	IBOutlet NSTableView* notesView;
	IBOutlet NSOutlineView* groupsView;
	
	IBOutlet NSMenu* groupsContextualMenu;
	IBOutlet NSMenu* groupsBarMenu;
}

// group actions
-(IBAction)addGroup:(id)sender;
-(IBAction)deleteClickedGroups:(id)sender;

// note actions
-(IBAction)deleteClickedNotes:(id)sender;
-(IBAction)makeClickedNotesDone:(id)sender;
-(IBAction)makeClickedNotesNotDone:(id)sender;
-(IBAction)changeClickedNotesPriority:(id)sender;

@end
