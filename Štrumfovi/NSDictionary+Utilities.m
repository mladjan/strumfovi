//
//  NSDictionary+Utilities
//  Merchant
//
//  Created by Mladjan Antic on 2/8/15.
//  Copyright (c) 2015 BLGRD. All rights reserved.
//


#import "NSDictionary+Utilities.h"

@implementation NSDictionary (Utilities)

- (NSDictionary *) dictionaryByReplacingNullsWithStrings {
    const NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in self) {
        const id object = [self objectForKey: key];
        if (object == nul) {
            [replaced setObject: blank forKey: key];
        }
        else if ([object isKindOfClass: [NSDictionary class]]) {
            [replaced setObject: [(NSDictionary *) object dictionaryByReplacingNullsWithStrings] forKey: key];
        }
    }
    return [NSDictionary dictionaryWithDictionary: [replaced copy]];
}

@end
