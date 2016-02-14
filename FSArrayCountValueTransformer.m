//
//  FSArrayCountValueTransformer.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 10 2.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSArrayCountValueTransformer.h"


@implementation FSArrayCountValueTransformer

+ (Class)transformedValueClass
{
	return [NSNumber class];
}

- (id)transformedValue:(id)value
{
	if(value == nil) return nil;
	
	return [NSNumber numberWithInt:[((NSArray*)value) count]];
}

@end
