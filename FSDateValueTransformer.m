//
//  FSDateValueTransformer.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 14.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSDateValueTransformer.h"


@implementation FSDateValueTransformer

+ (Class)transformedValueClass
{
	return [NSString class];
}

+(FSDateValueTransformer*)transformerWithDateFormatter:(NSDateFormatter*)aFormatter
{
	return [[[FSDateValueTransformer alloc] initWithDateFormatter:aFormatter] autorelease];
}

-(id)initWithDateFormatter:(NSDateFormatter*)aFormatter
{
	if(self == [super init]){
		
		formatter = [aFormatter retain];
	}
	
	return self;
}

- (id)transformedValue:(id)value
{
	if(value == nil) return nil;
	
	return [formatter stringForObjectValue:value];
}

-(void)dealloc
{
	[formatter release];
	[super dealloc];
}

@end
