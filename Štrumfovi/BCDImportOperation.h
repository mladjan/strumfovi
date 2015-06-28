//
//  BCDImportOperation.h
//  CDConcurrency
//
//  Created by Mladjan Antic on 4/3/15.
//  Copyright (c) 2015 iOSAkademija. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BCDImportOperation : NSOperation

typedef void (^ExecutionBlockForCD)(void);

- (id)initWithExecutionBlock:(ExecutionBlockForCD)block;

@end
