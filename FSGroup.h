//
//  FSGroup.h
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 15.
//  Copyright 2009 FloCo. All rights reserved.
//

#import <CoreData/CoreData.h>

@class FSNote;

@interface FSGroup :  NSManagedObject  
{
	NSNumber* notDoneNotesCount;
}

@property (retain) NSNumber * isExpanded;
@property (retain) NSString * name;
@property (retain) NSNumber * sortIndex;
@property (retain) NSSet* children;
@property (retain) FSGroup * parent;
@property (retain) NSSet* items;

// custom properties
@property (retain) NSNumber* notDoneNotesCount;

@end

@interface FSGroup (CoreDataGeneratedAccessors)
- (void)addChildrenObject:(FSGroup *)value;
- (void)removeChildrenObject:(FSGroup *)value;
- (void)addChildren:(NSSet *)value;
- (void)removeChildren:(NSSet *)value;
- (NSUInteger)countOfChildren;

- (void)addItemsObject:(FSNote *)value;
- (void)removeItemsObject:(FSNote *)value;
- (void)addItems:(NSSet *)value;
- (void)removeItems:(NSSet *)value;
-(NSUInteger)countOfItems;

@end

