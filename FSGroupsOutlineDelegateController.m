//
//  FSGroupsOutlineDelegate.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 21.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSGroupsOutlineDelegateController.h"
#import "FSGroup.h"

@implementation FSGroupsOutlineDelegateController

static NSImage* leafIcon;
static NSImage* branchIcon;
static NSImage* leafIconDisabled;
static NSImage* branchIconDisabled;

static NSFont* smallSystemFont;
static NSFont* smallSystemFontBold;

+(void)initialize
{
	if(self == [FSGroupsOutlineDelegateController class]){
		leafIcon = [[NSImage imageNamed:@"LeafGroupSmall"] retain];
		branchIcon = [[NSImage imageNamed:@"BranchGroupSmall"] retain];
		leafIconDisabled = [[NSImage imageNamed:@"LeafGroupSmallDisabled"] retain];
		branchIconDisabled = [[NSImage imageNamed:@"BranchGroupSmallDisabled"] retain];
		
		CGFloat size = [NSFont systemFontSizeForControlSize:NSSmallControlSize];
		smallSystemFont = [[NSFont systemFontOfSize:size] retain];
		smallSystemFontBold = [[NSFont boldSystemFontOfSize:size] retain]; 
	}
}

- (void)outlineView:(NSOutlineView *)olv 
	willDisplayCell:(NSCell*)cell 
	 forTableColumn:(NSTableColumn *)tableColumn 
			   item:(id)item

{
	// the outline column gets an icon
	if((outlineColumn == tableColumn)){
		FSGroup* group = [item representedObject];
		
		if([group countOfChildren] == 0)
			[cell setImage:[olv isEnabled] ? leafIcon : leafIconDisabled];
		else
			[cell setImage:[olv isEnabled] ? branchIcon : branchIconDisabled];
	}
	
	// if the cell is selected, set the bold font
	BOOL isSelected = [olv selectedRow] == [olv rowForItem:item];
	[cell setFont:isSelected ? smallSystemFontBold : smallSystemFont];
	
	// set the text color appropriate for cell enabled / disabled state
	if([cell isKindOfClass:[NSTextFieldCell class]]){
		NSColor* toSet = [olv isEnabled] ? [NSColor controlTextColor] : [NSColor disabledControlTextColor];
		[((NSTextFieldCell*)cell)setTextColor:toSet];
	}
		
}

- (void)outlineViewItemDidCollapse:(NSNotification *)notification;
{
	FSGroup *collapsedItem = [[[notification userInfo] valueForKey:@"NSObject"] representedObject];
	if([collapsedItem.isExpanded boolValue])
		collapsedItem.isExpanded = [NSNumber numberWithBool:NO];
}

- (void)outlineViewItemDidExpand:(NSNotification *)notification;
{
	FSGroup *expandedItem = [[[notification userInfo] valueForKey:@"NSObject"] representedObject];
	if(![expandedItem.isExpanded boolValue])
		expandedItem.isExpanded = [NSNumber numberWithBool:YES];
}

@end
