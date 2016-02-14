//
//  FSVisuals.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 14.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSVisuals.h"


@implementation FSVisuals

@synthesize grayColor;
@synthesize lightGrayColor;

-(id)init
{
	if(self == [super init]){
		grayColor = [[NSColor grayColor] retain];
		lightGrayColor = [[NSColor colorWithCalibratedWhite:0.75 alpha:1.0] retain];
	}
	
	return self;
}

-(void)awakeFromNib
{
	NSFont* systemSmallFont = [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSSmallControlSize]];
	[detailsTextView setFont:systemSmallFont];
	[detailsTextView setTextContainerInset:NSMakeSize(11.0f, 6.0f)];
}

-(void)dealloc
{
	[grayColor release];
	[lightGrayColor release];
	[super dealloc];
}

@end
