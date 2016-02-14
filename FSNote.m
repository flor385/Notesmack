// 
//  FSNote.m
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 8.
//  Copyright 2009 FloCo. All rights reserved.
//

#import "FSNote.h"

@implementation FSNote 

@dynamic details;
@dynamic lastModified;
@dynamic title;
@dynamic created;
@dynamic priority;
@dynamic group;
@dynamic done;

static NSDateFormatter* dateFormatter;

+(void)initialize
{
	if(self == [FSNote class]){
		
		dateFormatter = [NSDateFormatter new];
		[dateFormatter setDateStyle:NSDateFormatterLongStyle];
		[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}
}

-(void)awakeFromInsert
{
	NSUndoManager* um = [[self managedObjectContext] undoManager];
	[um disableUndoRegistration];
	
	self.created = [NSDate date];
	self.lastModified = self.created;
	
	[um enableUndoRegistration];
}

-(void)didChangeValueForKey:(NSString*)key
{
	if(![@"lastModified" isEqualToString:key])
		self.lastModified = [NSDate date];
	
	[super didChangeValueForKey:key];
}

+(NSArray*)keysToBeCopied
{
    
	static NSArray *keysToBeCopied = nil;
    
	if(keysToBeCopied == nil){
        keysToBeCopied = [[NSArray alloc] initWithObjects:
						  @"title", @"created", @"lastModified", @"priority", @"details", nil];
    }
   
	return keysToBeCopied;
}

-(NSDictionary*)dictRepresentation
{
	return [self dictionaryWithValuesForKeys:[[self class] keysToBeCopied]];
}

-(NSString*)stringRepresentation
{
	return [NSString stringWithFormat:@"%@, (priority: %d), created on: %@, last modified on: %@",
			self.title, [self.priority intValue], [dateFormatter stringFromDate:self.created],
			[dateFormatter stringFromDate:self.lastModified]];
}

@end