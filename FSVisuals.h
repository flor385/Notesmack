//
//  FSVisuals.h
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 14.
//  Copyright 2009 FloCo. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FSVisuals : NSObject {

	NSColor* grayColor;
	NSColor* lightGrayColor;
	IBOutlet NSTextView* detailsTextView;
}

@property(readonly) NSColor* grayColor;
@property(readonly) NSColor* lightGrayColor;

@end
