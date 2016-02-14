//
//  FSToStringTransformer.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 29.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSToStringTransformer.h"


@implementation FSToStringTransformer

+ (Class)transformedValueClass
{
	return [NSString class];
}

- (id)transformedValue:(id)value
{
	return [value description];
}

@end
