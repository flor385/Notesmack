//
//  FSArrayHasOneElementeTransformer.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 17.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSArrayHasOneElementTransformer.h"


@implementation FSArrayHasOneElementTransformer

+ (Class)transformedValueClass
{
	return [NSNumber class];
}

static NSNumber* noNumber = nil;
static NSNumber* yesNumber = nil;

+(void)initialize
{
	if(self == [FSArrayHasOneElementTransformer class]){
		noNumber = [NSNumber numberWithBool:NO];
		yesNumber = [NSNumber numberWithBool:YES];
	}
}

- (id)transformedValue:(id)value
{
	if(value == nil) return nil;
	
	if([((NSArray*)value) count] == 1)
		return yesNumber;
	else
		return noNumber;
}

@end
