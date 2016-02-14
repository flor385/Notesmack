//
//  FSNotesTableDataSource.h
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 11.
//  Copyright 2009 FloCo. All rights reserved.
//

#import <Cocoa/Cocoa.h>


extern NSString* const FSNoteIDURIsArrayPBType;

@interface FSNotesTableDataSource : NSObject {

	IBOutlet NSArrayController* notesController;
}

@end
