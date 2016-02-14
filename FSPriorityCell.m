//
//  FSRatingCell.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 8.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSPriorityCell.h"


#define EMPTY_DOT_RADIUS_PERCENT 0.05f
#define FULL_DOT_RADIUS_PERCENT 0.2f
#define FULL_DOT_LINE_WIDTH_PERCENT 0.2f

@implementation FSPriorityCell

static NSDictionary* colorsForPriority;

+(void)initialize
{
	if(self == [FSPriorityCell class]){
		
		NSMutableDictionary* tempDict = [[NSMutableDictionary new] autorelease];
		[tempDict setObject:[NSColor blueColor] forKey:[NSNumber numberWithInt:1]];
		[tempDict setObject:[NSColor greenColor] forKey:[NSNumber numberWithInt:2]];
		[tempDict setObject:[NSColor yellowColor] forKey:[NSNumber numberWithInt:3]];
		[tempDict setObject:[NSColor orangeColor] forKey:[NSNumber numberWithInt:4]];
		[tempDict setObject:[NSColor redColor] forKey:[NSNumber numberWithInt:5]];
		
		colorsForPriority = [[NSDictionary dictionaryWithDictionary:tempDict] retain];
	}
}

-(void)setPlaceholderString:(NSString*)string{}

-(void)drawInteriorWithFrame:(NSRect)cellFrame 
					  inView:(NSView *)controlView
{
	// some measurements we will need
	float cellHeight = cellFrame.size.height;
	float halfCellHeight = cellHeight / 2;
	float emptyDotRadius = cellHeight * EMPTY_DOT_RADIUS_PERCENT;
	float emptyDotDiameter = emptyDotRadius * 2;
	
	// draw the empty dots
	// the color depends on the background
	if([self backgroundStyle] == NSBackgroundStyleDark)
		[[NSColor whiteColor] set];
	else
		[[NSColor grayColor] set];
	for(int i = 0 ; i < 5 ; i++){
		NSRect imageRect = NSMakeRect(cellFrame.origin.x + (i * cellHeight +
															halfCellHeight - emptyDotRadius),
									  cellFrame.origin.y + halfCellHeight - emptyDotRadius,
									  emptyDotDiameter, 
									  emptyDotDiameter);
		NSBezierPath* circle = [NSBezierPath bezierPathWithOvalInRect:imageRect];
		[circle fill];
	}
	
	// draw the full dot
	NSNumber* priority = [self objectValue];
	if(priority != nil && [priority intValue] > 0){
		
		float fullDotRadius = cellHeight * FULL_DOT_RADIUS_PERCENT;
		float fullDotDiameter = fullDotRadius * 2;
		float fullDotLineWidth = cellHeight * FULL_DOT_LINE_WIDTH_PERCENT;
		
		NSInteger priorityLocation = [priority integerValue] - 1;
		NSRect imageRect = NSMakeRect(cellFrame.origin.x + (priorityLocation * cellHeight + 
															halfCellHeight - fullDotRadius),
									  cellFrame.origin.y + halfCellHeight - fullDotRadius,
									  fullDotDiameter, 
									  fullDotDiameter);
		NSBezierPath* circle = [NSBezierPath bezierPathWithOvalInRect:imageRect];
		[circle setLineWidth:fullDotLineWidth];
		
		NSColor* priorityColor = [colorsForPriority objectForKey:priority];
		
		// if over a dark background, do a stroke of white
		if([self backgroundStyle] == NSBackgroundStyleDark){
			[[NSColor whiteColor] set];
			[circle stroke];
		}
			
		[priorityColor set];
		[circle fill];
	}
}

@end
