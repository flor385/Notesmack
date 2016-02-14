//
//  FSPreferencesPanelController.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 10 19.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSPreferencesPanelController.h"


@implementation FSPreferencesPanelController

static FSPreferencesPanelController* defaultController = nil;

+(FSPreferencesPanelController*)defaultController
{
	if(defaultController == nil){
		defaultController = [[FSPreferencesPanelController alloc] initWithWindowNibName:@"PreferencesPanel"];
	}
	
	return defaultController;
}

@end
