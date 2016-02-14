//
//  FSNotesmackPrefs.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 24.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSNotesmackPrefs.h"

// GUI state prefs
NSString* const FSViewAllNotesPref = @"FSViewAllNotesPref";
NSString* const FSShowDoneNotesPref = @"FSShowDoneNotesPref";

// invisible prefs
NSString* const FSGroupsSelectedIndexPathsPref = @"FSGroupsSelectedIndexPathsPref";
NSString* const FSNotesSelectedRowIndicesPref = @"FSNotesSelectedRowIndicesPref";
NSString* const FSIsFirstRunPref = @"FSIsFirstRunPref";

// preferences from the panel
NSString* const FSDefaultNotePriorityPref = @"FSDefaultNotePriorityPref";
NSString* const FSDeleteDoneNotesPref = @"FSDeleteDoneNotesPref";

@implementation FSNotesmackPrefs

+(void)initializePreferenceDefaults
{
	// init
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	
	// register some default perference values
	NSMutableDictionary* udDefaults = [[NSMutableDictionary new] autorelease];
	[udDefaults setValue:[NSKeyedArchiver archivedDataWithRootObject:[NSArray array]] 
				  forKey:FSGroupsSelectedIndexPathsPref];
	[udDefaults setValue:[NSKeyedArchiver archivedDataWithRootObject:[NSIndexSet indexSet]]
				  forKey:FSNotesSelectedRowIndicesPref];
	[udDefaults setValue:[NSNumber numberWithBool:NO] forKey:FSViewAllNotesPref];
	[udDefaults setValue:[NSNumber numberWithBool:NO] forKey:FSShowDoneNotesPref];
	[udDefaults setValue:[NSNumber numberWithBool:YES] forKey:FSIsFirstRunPref];
	[udDefaults setValue:[NSNumber numberWithInt:0] forKey:FSDefaultNotePriorityPref];
	[udDefaults setValue:[NSNumber numberWithInt:FSDeleteDoneNotesNever] forKey:FSDeleteDoneNotesPref];
	[userDefaults registerDefaults:udDefaults];
}

@end
