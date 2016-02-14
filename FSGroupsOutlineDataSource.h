//
//  FSGroupsOutlineDataSource.h
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 7.
//  Copyright 2009 FloCo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Notesmack_AppDelegate.h"

@interface FSGroupsOutlineDataSource : NSObject {

	IBOutlet NSOutlineView* outlineView;
	IBOutlet NSTreeController* groupsController;
	IBOutlet Notesmack_AppDelegate* appDelegate;
}

@end
