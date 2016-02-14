//
//  FSPriorityView.h
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 15.
//  Copyright 2009 FloCo. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FSPriorityCell.h"

@interface FSPriorityView : NSControl {
	
	id observedObjectForObjectValue;
    NSString *observedKeyPathForObjectValue;
}

-(void)initCell;

@end
