//
//  NSString+Extensions.h
//  Merchant
//
//  Created by Mladjan Antic on 2/8/15.
//  Copyright (c) 2015 BLGRD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)

-(NSString *)stringWithUppercaseFirstLetter;
-(NSString *)urlEncode;
+(NSString *)randomAlphanumericStringWithLength:(NSInteger)length;
+(NSString *)apiURL;

@end
