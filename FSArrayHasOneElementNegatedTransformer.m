//
//  FSSelectionToSingleSelectionValueTransformer.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 14.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSArrayHasOneElementNegatedTransformer.h"


@implementation FSArrayHasOneElementNegatedTransformer

+ (Class)transformedValueClass
{
	return [NSNumber class];
}

static NSNumber* noNumber = nil;
static NSNumber* yesNumber = nil;

+(void)initialize
{
	if(self == [FSArrayHasOneElementNegatedTransformer class]){
		noNumber = [NSNumber numberWithBool:NO];
		yesNumber = [NSNumber numberWithBool:YES];
	}
}

- (id)transformedValue:(id)value
{
	if(value == nil) return nil;
	
	if([((NSArray*)value) count] == 1)
		return noNumber;
	else
		return yesNumber;
}

@end
