//
//  FSNotesmackPrefs.h
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 24.
//  Copyright 2009 FloCo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString* const FSGroupsSelectedIndexPathsPref;
extern NSString* const FSNotesSelectedRowIndicesPref;
extern NSString* const FSViewAllNotesPref;
extern NSString* const FSShowDoneNotesPref;
extern NSString* const FSIsFirstRunPref;
extern NSString* const FSDefaultNotePriorityPref;
extern NSString* const FSDeleteDoneNotesPref;

enum {
	FSDeleteDoneNotesNever = 0,
	FSDeleteDoneNotesAfterOneHour = 1,
	FSDeleteDoneNotesAfterOneDay = 2,
	FSDeleteDoneNotesAfterOneWeek = 3,
	FSDeleteDoneNotesAfterOneMonth = 4
};

@interface FSNotesmackPrefs : NSObject {

}

+(void)initializePreferenceDefaults;

@end
