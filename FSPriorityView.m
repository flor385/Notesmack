//
//  FSPriorityView.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 15.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSPriorityView.h"


@implementation FSPriorityView

-(id)initWithFrame:(NSRect)frame
{
	if(self == [super initWithFrame:frame]){
		[self performSelector:@selector(initCell)];
	}
	
	return self;
}

-(void)awakeFromNib
{
	[self initCell];
}

-(void)initCell
{
	FSPriorityCell* cell = [[FSPriorityCell new] autorelease];
	[self setCell:cell];
	[self calcSize];
	
}

-(BOOL)acceptsFirstResponder
{
	return NO;
}

-(void)mouseDown:(NSEvent*)event
{
	NSPoint pointInSelf = [self convertPoint:[event locationInWindow] fromView:nil];
	NSRect selfBounds = [self bounds];
	float oneRatingWidth = selfBounds.size.height;
	
	// determine the priority that was clicked
	int rating = (int)((pointInSelf.x - selfBounds.origin.x) / oneRatingWidth) + 1;
	
	// update the observed object
	NSDictionary* infoForBinding = [self infoForBinding:@"objectValue"];
	NSString* observedKeyPath = [infoForBinding valueForKey:NSObservedKeyPathKey];
	NSObject* observedObject = [infoForBinding valueForKey:NSObservedObjectKey];
	[observedObject setValue:[NSNumber numberWithInt:rating] forKeyPath:observedKeyPath];
}

-(void)mouseDragged:(NSEvent*)event
{
	NSPoint pointInSelf = [self convertPoint:[event locationInWindow] fromView:nil];
	NSRect selfBounds = [self bounds];
	float oneRatingWidth = selfBounds.size.height;
	
	// determine the priority that was clicked
	int rating = (int)((pointInSelf.x - selfBounds.origin.x) / oneRatingWidth);
	[self setObjectValue:[NSNumber numberWithInt:rating]];
	[self setNeedsDisplay:YES];
}

@end
