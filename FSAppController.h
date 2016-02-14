//
//  FSAppController.h
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 7.
//  Copyright 2009 FloCo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FSPriorityView.h"
#import "Notesmack_AppDelegate.h"
#import "FSGroup.h"
#import "FSPreferencesPanelController.h"

@interface FSAppController : NSObject {
	
	NSUserDefaults* userDefaults;
	NSUserDefaultsController* udController;
	
	NSNumber* newNoteDefaultPriority;
	
	IBOutlet Notesmack_AppDelegate* appDelegate;

	// the controllers
	IBOutlet NSTreeController* groupsController;
	IBOutlet NSArrayController* notesController;
	IBOutlet NSArrayController* allNotesController;
	
	// some views we access programatically
	IBOutlet NSOutlineView* groupsView;
	IBOutlet NSTableView* notesView;
	IBOutlet NSTextView* noteDetailedInfoView;
	IBOutlet NSScrollView* noteDetailsScrollView;
	IBOutlet FSPriorityView* noteDetailsPriority;
}

@property(copy) NSNumber* newNoteDefaultPriority;

-(IBAction)changeNotePriority:(id)sender;
-(IBAction)setNoteDone:(id)sender;
-(IBAction)setNoteNotDone:(id)sender;
-(IBAction)selectAndFocusOnDetails:(id)sender;

-(IBAction)addGroup:(id)sender;
-(IBAction)addSubgroup:(id)sender;
-(IBAction)addNote:(id)sender;
-(IBAction)deleteSelectedNotes:(id)sender;
-(IBAction)deleteSelectedGroup:(id)sender;

-(IBAction)showPreferences:(id)sender;

-(void)deleteNotes:(NSArray*)notes;
-(void)deleteGroup:(FSGroup*)groups;

-(void)initViewSelections;
-(void)storeViewSelections;
-(void)handleFirstRun;

@end