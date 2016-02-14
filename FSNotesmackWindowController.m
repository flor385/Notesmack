//
//  FSNotesmackWindowController.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2010 06 6.
//  Copyright 2010 FloCo. All rights reserved.
//

#import "FSNotesmackWindowController.h"


@implementation FSNotesmackWindowController

BOOL didAwakeFromNib;

-(void)awakeFromNib
{
	[[self window] setExcludedFromWindowsMenu:YES]; 
	didAwakeFromNib = YES;
}

-(BOOL)notesmackWindowVisible
{
	return !didAwakeFromNib || [[self window] isVisible];
}

-(void)setNotesmackWindowVisible:(BOOL)visible
{
	if(visible){
		[[self window] makeKeyAndOrderFront:self];
	}else
		[[self window] orderOut:self];
}

@end
