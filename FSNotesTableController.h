//
//  FSNotesTableController.h
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 8.
//  Copyright 2009 FloCo. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FSNotesTableController : NSObject {

	IBOutlet NSArrayController* notesController;
	IBOutlet NSTableColumn* priorityColumn;
	IBOutlet NSTableColumn* doneColumn;
	IBOutlet NSTableColumn* groupNameColumn;
	
	NSUserDefaultsController* udController;
}

@end
