// 
//  FSGroup.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 15.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSGroup.h"
#import "FSNote.h"

@interface FSGroup (NotDoneNoteCounting)

-(NSNumber*)doneNotesCountManual;
-(void)startObservingNotes;
-(void)stopObservingNotes;

@end

@implementation FSGroup (NotDoneNoteCounting)

-(void)awakeFromInsertion
{
	[super awakeFromInsert];
	notDoneNotesCount = [[NSNumber numberWithInt:0] retain];
	[self startObservingNotes];
}

-(void)awakeFromFetch
{
	[super awakeFromFetch];
	notDoneNotesCount = [[self doneNotesCountManual] retain];
	[self startObservingNotes];
}

-(NSNumber*)doneNotesCountManual
{
	int count = 0;
	for(FSNote* note in self.items)
		if(![note.done boolValue])
			count++;
	
	return count == 0 ? nil : [NSNumber numberWithInt:count];
}

-(void)startObservingNotes
{
	for(FSNote* note in self.items)
		[note addObserver:self forKeyPath:@"done" options:0 context:nil];
}

-(void)stopObservingNotes
{
	for(FSNote* note in self.items)
		[note removeObserver:self forKeyPath:@"done"];
}

- (void)observeValueForKeyPath:(NSString*)keyPath 
					  ofObject:(id)object 
						change:(NSDictionary *)change 
					   context:(void *)context
{
	// if an observed note changed for the done keypath, update the count of done notes
	if([object isKindOfClass:[FSNote class]] && [@"done" isEqualToString:keyPath])
		self.notDoneNotesCount = [self doneNotesCountManual];
}

- (void)willChangeValueForKey:(NSString *)key
{
	if([@"items" isEqualToString:key])
		[self stopObservingNotes];
	
	[super willChangeValueForKey:key];
}

-(void)willChange:(NSKeyValueChange)change 
  valuesAtIndexes:(NSIndexSet *)indexes 
		   forKey:(NSString *)key
{
	if([@"items" isEqualToString:key])
		[self stopObservingNotes];
	
	[super willChange:change valuesAtIndexes:indexes forKey:key];
}

- (void)willChangeValueForKey:(NSString *)key 
			  withSetMutation:(NSKeyValueSetMutationKind)mutationKind 
				 usingObjects:(NSSet *)objects
{
	if([@"items" isEqualToString:key])
		[self stopObservingNotes];
	
	[super willChangeValueForKey:key withSetMutation:mutationKind usingObjects:objects];
}

-(void)didChange:(NSKeyValueChange)change 
 valuesAtIndexes:(NSIndexSet *)indexes 
		  forKey:(NSString *)key
{
	[super didChange:change valuesAtIndexes:indexes forKey:key];
	
	if([@"items" isEqualToString:key]){
		[self startObservingNotes];
		self.notDoneNotesCount = [self doneNotesCountManual];
	}
}

-(void)didChangeValueForKey:(NSString*)key
{
	[super didChangeValueForKey:key];
	
	if([@"items" isEqualToString:key]){
		[self startObservingNotes];
		self.notDoneNotesCount = [self doneNotesCountManual];
	}
}

- (void)didChangeValueForKey:(NSString *)key 
			 withSetMutation:(NSKeyValueSetMutationKind)mutationKind 
				usingObjects:(NSSet *)objects
{
	[super didChangeValueForKey:key withSetMutation:mutationKind usingObjects:objects];
	
	if([@"items" isEqualToString:key]){
		[self startObservingNotes];
		self.notDoneNotesCount = [self doneNotesCountManual];
	}
}

@end

@implementation FSGroup 

@dynamic isExpanded;
@dynamic name;
@dynamic sortIndex;
@dynamic children;
@dynamic parent;
@dynamic items;

-(NSNumber*)notDoneNotesCount
{
	return notDoneNotesCount;
}

-(void)setNotDoneNotesCount:(NSNumber*)newValue
{
	[self willChangeValueForKey:@"notDoneNotesCount"];
	[newValue retain];
	[notDoneNotesCount release];
	notDoneNotesCount = newValue;
	[self didChangeValueForKey:@"notDoneNotesCount"];
}

- (NSUInteger)countOfChildren
{
    return [self.children count];
}

- (NSUInteger)countOfItems
{
    return [self.items count];
}

-(NSComparisonResult)compare:(FSGroup*)aGroup
{
	return [self.sortIndex compare:aGroup.sortIndex];
}

-(void)dealloc
{
	[notDoneNotesCount release];
	[super dealloc];
}

@end
