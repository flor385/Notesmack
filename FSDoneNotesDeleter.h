//
//  FSDoneNotesDeleter.h
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 10 19.
//  Copyright 2009 FloCo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>
#import "Notesmack_AppDelegate.h"

@interface FSDoneNotesDeleter : NSObject {
}

+(void)checkAndDeleteAsNecessary:(Notesmack_AppDelegate*)nsad;

@end
