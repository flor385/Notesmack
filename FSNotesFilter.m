//
//  FSNotesFiler.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 24.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSNotesFilter.h"
#import "FSNotesmackPrefs.h"

@implementation FSNotesFilter

@synthesize searchFieldPredicate;
@synthesize selectedGroupNodes;
@synthesize showDoneNotes;
@synthesize showAllNotes;

#pragma mark -
#pragma mark Initialization

-(void)awakeFromNib
{
	// bind the show done notes and show all notes values
	NSUserDefaultsController* udController = [NSUserDefaultsController sharedUserDefaultsController];
	[self bind:@"showDoneNotes" 
	  toObject:udController 
   withKeyPath:[NSString stringWithFormat:@"values.%@", FSShowDoneNotesPref] 
	   options:nil];
	[self bind:@"showAllNotes" 
	  toObject:udController 
   withKeyPath:[NSString stringWithFormat:@"values.%@", FSViewAllNotesPref] 
	   options:nil];
	
	// bind the selected group
	[self bind:@"selectedGroupNodes" 
	  toObject:groupsController 
   withKeyPath:@"selectedNodes" 
	   options:nil];
	
	// bind the search field
	NSMutableDictionary* searchFieldBindingOptions = [[NSMutableDictionary new] autorelease];
	[searchFieldBindingOptions setValue:@"All" forKey:NSDisplayNameBindingOption];
	[searchFieldBindingOptions setValue:@"(title contains[c] $value) or (details contains[c] $value) or (group.name contains[c] $value)" 
								 forKey:NSPredicateFormatBindingOption];
	[toolbarSearchField bind:@"predicate" 
					toObject:self 
				 withKeyPath:@"searchFieldPredicate" 
					 options:searchFieldBindingOptions];

	[searchFieldBindingOptions setValue:@"Title" forKey:NSDisplayNameBindingOption];
	[searchFieldBindingOptions setValue:@"title contains[c] $value" forKey:NSPredicateFormatBindingOption];
	[toolbarSearchField bind:@"predicate2" 
					toObject:self 
				 withKeyPath:@"searchFieldPredicate" 
					 options:searchFieldBindingOptions];

	[searchFieldBindingOptions setValue:@"Details" forKey:NSDisplayNameBindingOption];
	[searchFieldBindingOptions setValue:@"details contains[c] $value" forKey:NSPredicateFormatBindingOption];
	[toolbarSearchField bind:@"predicate3" 
					toObject:self 
				 withKeyPath:@"searchFieldPredicate" 
					 options:searchFieldBindingOptions];

	[searchFieldBindingOptions setValue:@"Group" forKey:NSDisplayNameBindingOption];
	[searchFieldBindingOptions setValue:@"group.name contains[c] $value" forKey:NSPredicateFormatBindingOption];
	[toolbarSearchField bind:@"predicate4" 
					toObject:self 
				 withKeyPath:@"searchFieldPredicate" 
					 options:searchFieldBindingOptions];
	
	[self updateControllerFilter];
}

#pragma mark -
#pragma mark Filter updating logic

-(void)setSearchFieldPredicate:(NSPredicate*)newPredicate
{
	if(newPredicate == searchFieldPredicate) return;
	
	[self willChangeValueForKey:@"searchFieldPredicate"];
	[newPredicate retain];
	[searchFieldPredicate release];
	searchFieldPredicate = newPredicate;
	[self didChangeValueForKey:@"searchFieldPredicate"];
	
	[self updateControllerFilter];
}

-(void)setSelectedGroupNodes:(NSArray*)newNodes
{
	if(newNodes == selectedGroupNodes) return;
	
	[self willChangeValueForKey:@"selectedGroupNodes"];
	[newNodes retain];
	[selectedGroupNodes release];
	selectedGroupNodes = newNodes;
	[self didChangeValueForKey:@"selectedGroupNodes"];
	
	[self updateControllerFilter];
}

-(void)setShowAllNotes:(NSNumber*)newValue
{
	[self willChangeValueForKey:@"showAllNotes"];
	[showAllNotes release];
	showAllNotes = [newValue copy];
	[self didChangeValueForKey:@"showAllNotes"];
	
	[self updateControllerFilter];
}

-(void)setShowDoneNotes:(NSNumber*)newValue
{
	[self willChangeValueForKey:@"showDoneNotes"];
	[showDoneNotes release];
	showDoneNotes = [newValue copy];
	[self didChangeValueForKey:@"showDoneNotes"];
	
	[self updateControllerFilter];
}

-(void)updateControllerFilter
{
	NSMutableArray* predicates = [NSMutableArray arrayWithCapacity:4];
	
	// show done notes predicate
	if(![showDoneNotes boolValue]){
		NSPredicate* doneNotesPredicate = 
		[NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"done"] 
										   rightExpression:[NSExpression expressionForConstantValue:[NSNumber numberWithBool:NO]] 
												  modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType 
												   options:0];
		[predicates addObject:doneNotesPredicate];
	}
	
	// search field predicate
	if(searchFieldPredicate != nil)
		[predicates addObject:searchFieldPredicate];
	
	// selected group predicate
	if(![showAllNotes boolValue]){
		id firstSelectedGroup = [selectedGroupNodes count] == 0 ? nil : 
		[((NSTreeNode*)[selectedGroupNodes objectAtIndex:0]) representedObject];
		
		NSPredicate* selectedGroupPredicate = 
		[NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"group"] 
										   rightExpression:[NSExpression expressionForConstantValue:firstSelectedGroup] 
												  modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType 
												   options:0];
		[predicates addObject:selectedGroupPredicate];
	}
	
	// we have both predicates, so do both
	if([predicates count] > 0)
		[toFilter setFilterPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:predicates]];
	else
		[toFilter setFilterPredicate:nil];
}

#pragma mark -

-(void)dealloc
{
	[searchFieldPredicate release];
	[selectedGroupNodes release];
	[super dealloc];
}

@end
