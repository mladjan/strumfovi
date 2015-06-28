//
//  NSManagedObject+SafeSetValues.m
//  Merchant
//
//  Created by Mladjan Antic on 2/8/15.
//  Copyright (c) 2015 BLGRD. All rights reserved.
//

#import "NSManagedObject+SafeSetValues.h"
#import "NSString+Extensions.h"
#import "NSDictionary+Utilities.h"


#define SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING(code)                        \
_Pragma("clang diagnostic push")                                        \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")     \
code;                                                                   \
_Pragma("clang diagnostic pop")                                         \

@implementation NSManagedObject (SafeSetValues)

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    
    //    if([[self valueForKey:@"syncDone"] boolValue]){
    NSDictionary *cleanKeyedValues = [NSManagedObject dataFromResponseData:[keyedValues dictionaryByReplacingNullsWithStrings]];
    
    NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *attribute in attributes) {
        id value = [cleanKeyedValues objectForKey:attribute];
        if (value == nil) {
            continue;
        }
        NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
        if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
            value = [value stringValue];
        } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithInteger:[value integerValue]];
        } else if ((attributeType == NSFloatAttributeType) &&  ([value isKindOfClass:[NSString class]])) {
            value = [NSNumber numberWithDouble:[value doubleValue]];
        } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]])) {
            value = [[[LocalManager sharedManager] dateFormatter] dateFromString:value];
        }
        
        [self setValue:value forKey:attribute];


    }

    NSDictionary *relationships = [[self entity] relationshipsByName];
    for(NSString *key in relationships.allKeys){
        NSRelationshipDescription *desc = [relationships objectForKey:key];
        if(desc.isToMany){
            // Multiple objects, ToMany relation
            NSArray *rawObjects = [cleanKeyedValues objectForKey:key];
            for(NSDictionary *rawObj in rawObjects){
                General *cdObj = [General addOrUpdateObjectFromDictionary:rawObj withClassName:[[desc destinationEntity] name]];
                SEL customSelector = NSSelectorFromString([NSString stringWithFormat:@"add%@Object:", [key stringWithUppercaseFirstLetter]]);
                if([self respondsToSelector:customSelector]){
                    SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING(
                                                           [self performSelector:customSelector withObject:cdObj];
                                                           );
                    
                }else{
                    NSLog(@"CDParserError: Can't perform selector: %@ on objectWithClass: %@",NSStringFromSelector(customSelector), [[self class] description]);
                }
                
            }
        }else{
            // One object, ToOne relation
            NSDictionary *rawObject = [cleanKeyedValues objectForKey:key];
            if(rawObject && [rawObject isKindOfClass:[NSDictionary class]]){
                General *cdObj = [General addOrUpdateObjectFromDictionary:rawObject withClassName:[[desc destinationEntity] name]];
                
                SEL customSelector = NSSelectorFromString([NSString stringWithFormat:@"set%@:", [key stringWithUppercaseFirstLetter]]);
                if([self respondsToSelector:customSelector]){
                    SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING(
                                                           [self performSelector:customSelector withObject:cdObj];
                                                           );
                }else{
                    NSLog(@"CDParserError: Can't perform selector: %@ on objectWithClass: %@",NSStringFromSelector(customSelector), [[self class] description]);
                }
            }
        }
    }

    
}


+(NSMutableDictionary *)dataFromResponseData:(NSDictionary *)response{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:response];
    mDic[@"created_at"] = [[[LocalManager sharedManager] dateFormatter] dateFromString:mDic[@"created_at"]];
    mDic[@"updated_at"] = [[[LocalManager sharedManager] dateFormatter] dateFromString:mDic[@"updated_at"]];

    for(NSString *key in response.allKeys){
        id obj = [response objectForKey:key];
        if([obj isKindOfClass:[NSArray class]]){
            // to many relation
        }else if([obj isKindOfClass:[NSDictionary class]]){
            // to one relation
        }
    }
    return mDic;
}

+(BOOL)isEmptyString:(NSString *)str{
    if(str.length > 1){
        return NO;
    }else{
        return YES;
    }
}

@end
