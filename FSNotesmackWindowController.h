//
//  FSNotesmackWindowController.h
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2010 06 6.
//  Copyright 2010 FloCo. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FSNotesmackWindowController : NSWindowController {

	IBOutlet NSManagedObjectContext* managedObjectContext;
}

@property BOOL notesmackWindowVisible;

@end
