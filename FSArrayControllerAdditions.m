//
//  FSArrayControllerAdditions.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 27.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSArrayControllerAdditions.h"


@implementation NSArrayController (FSArrayControllerAdditions)

-(NSNumber*)arrangedObjectsCount
{
	return [NSNumber numberWithInt:[[self arrangedObjects] count]];
}

-(void)willChangeValueForKey:(NSString*)key
{
	[super willChangeValueForKey:key];
	if([@"arrangedObjects" isEqualToString:key])
		[self willChangeValueForKey:@"arrangedObjectsCount"];
}

-(void)didChangeValueForKey:(NSString*)key
{
	[super didChangeValueForKey:key];
	if([@"arrangedObjects" isEqualToString:key])
		[self didChangeValueForKey:@"arrangedObjectsCount"];
}

@end
