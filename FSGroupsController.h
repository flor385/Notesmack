//
//  FSGroupsController.h
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 27.
//  Copyright 2009 FloCo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ESTreeController.h"

@interface FSGroupsController : ESTreeController {
	
	NSNumber* selectionItemsCount;

}

@property(readonly) NSNumber* selectionItemsCount;

@end
