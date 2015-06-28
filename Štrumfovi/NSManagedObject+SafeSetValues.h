//
//  NSManagedObject+SafeSetValues.h
//  Merchant
//
//  Created by Mladjan Antic on 2/8/15.
//  Copyright (c) 2015 BLGRD. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (SafeSetValues)

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues;
+(NSMutableDictionary *)dataFromResponseData:(NSDictionary *)response;


@end
