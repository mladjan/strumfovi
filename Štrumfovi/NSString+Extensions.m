//
//  NSString+Extensions.m
//  Merchant
//
//  Created by Mladjan Antic on 2/8/15.
//  Copyright (c) 2015 BLGRD. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

-(NSString *)stringWithUppercaseFirstLetter{
    NSString *firstChar = [self substringToIndex:1];
    return [[firstChar uppercaseString] stringByAppendingString:[self substringFromIndex:1]];
}

-(NSString *)urlEncode{
    NSString *newString = [self stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    return newString;
}

+ (NSString *)randomAlphanumericStringWithLength:(NSInteger)length
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }
    
    return randomString;
}


+ (NSString *)apiURL{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults objectForKey:@"production"]){
        if([defaults boolForKey:@"production"]){
            return @"https://app.buymaster.co";
        }else{
            return @"https://devapi.buymaster.co";
        }
    }else{
        return @"https://devapi.buymaster.co";
    }
    
}


@end
