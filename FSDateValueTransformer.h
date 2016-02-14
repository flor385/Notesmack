//
//  FSDateValueTransformer.h
//  Notesmack
//
//  Created by Florijan Stamenkovic on 2009 09 14.
//  Copyright 2009 FloCo. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FSDateValueTransformer : NSValueTransformer {

	NSDateFormatter* formatter;
}

+(FSDateValueTransformer*)transformerWithDateFormatter:(NSDateFormatter*)aFormatter;
-(id)initWithDateFormatter:(NSDateFormatter*)aFormatter;

@end
