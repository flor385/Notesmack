//
//  FSValueTransformers.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 29.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSValueTransformers.h"
#import "FSDateValueTransformer.h"
#import "FSArrayHasOneElementNegatedTransformer.h"
#import "FSArrayHasOneElementTransformer.h"
#import "FSToStringTransformer.h"
#import "FSArrayCountValueTransformer.h"

@implementation FSValueTransformers

+(void)registerValueTransformers
{
	NSValueTransformer* transformer;
	
	// the date formatting transformers
	NSDateFormatter* formatter = [[NSDateFormatter new] autorelease];
	[formatter setDateStyle:NSDateFormatterMediumStyle];
	[formatter setTimeStyle:NSDateFormatterNoStyle];
	transformer = [FSDateValueTransformer transformerWithDateFormatter:formatter];
	[NSValueTransformer setValueTransformer:transformer forName:@"FSMediumDateNoTimeValueTransformer"];
	
	formatter = [[NSDateFormatter new] autorelease];
	[formatter setDateStyle:NSDateFormatterFullStyle];
	[formatter setTimeStyle:NSDateFormatterNoStyle];
	transformer = [FSDateValueTransformer transformerWithDateFormatter:formatter];
	[NSValueTransformer setValueTransformer:transformer forName:@"FSFullDateNoTimeValueTransformer"];
	
	// single selection transformers
	transformer = [[FSArrayHasOneElementNegatedTransformer new] autorelease];
	[NSValueTransformer setValueTransformer:transformer 
									forName:@"FSArrayHasOneElementNegatedTransformer"];
	transformer = [[FSArrayHasOneElementTransformer new] autorelease];
	[NSValueTransformer setValueTransformer:transformer
									forName:@"FSArrayHasOneElementTransformer"];
	
	// to string value transformer
	transformer = [[FSToStringTransformer new] autorelease];
	[NSValueTransformer setValueTransformer:transformer forName:@"FSToStringValueTransformer"];
	
	// array count value transformer
	transformer = [[FSArrayCountValueTransformer new] autorelease];
	[NSValueTransformer setValueTransformer:transformer forName:@"FSArrayCountValueTransformer"];
}

@end
