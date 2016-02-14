//
//  FSNote.h
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 8.
//  Copyright 2009 FloCo. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FSGroup.h"

@interface FSNote :  NSManagedObject

@property (retain) NSString* details;
@property (retain) NSDate * lastModified;
@property (retain) NSString * title;
@property (retain) NSDate * created;
@property (retain) NSNumber * priority;
@property (retain) FSGroup * group;
@property (retain) NSNumber * done;

+(NSArray*)keysToBeCopied;
-(NSDictionary*)dictRepresentation;
-(NSString*)stringRepresentation;

@end


