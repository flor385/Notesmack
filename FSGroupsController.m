//
//  FSGroupsController.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 27.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSGroupsController.h"


@implementation FSGroupsController

-(id)initWithCoder:(NSCoder*)coder
{
	if(self == [super initWithCoder:coder]){
		NSLog(@"Init");
		[self observeValueForKeyPath:@"selection.items" ofObject:self change:0 context:nil];
	}
	
	return self;
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if(object == self && [@"selection.items" isEqualToString:keyPath]){
		
		NSLog(@"Observing change in self for selection.items");
		
		[self willChangeValueForKey:@"selectionItemsCount"];
		
		NSArray* selectedObjects = [self selectedObjects];
		int count = [selectedObjects count] == 0 ? 0 : [[[selectedObjects objectAtIndex:0] items] count];
		[selectionItemsCount release];
		selectionItemsCount = [[NSNumber numberWithInt:count] retain];
		
		[self didChangeValueForKey:@"selectionItemsCount"];
	}
}


-(NSNumber*)selectionItemsCount
{
	return selectionItemsCount;
}

@end
