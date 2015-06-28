//
//  BCDImportOperation.m
//  CDConcurrency
//
//  Created by Mladjan Antic on 4/3/15.
//  Copyright (c) 2015 iOSAkademija. All rights reserved.
//

#import "BCDImportOperation.h"

@interface BCDImportOperation()

@property (strong, nonatomic) NSManagedObjectContext *privateManagedObjectContext;
@property (copy, nonatomic) ExecutionBlockForCD executionBlockCD;

@end

@implementation BCDImportOperation
@synthesize executionBlockCD = _executionBlockCD;


- (id)initWithExecutionBlock:(ExecutionBlockForCD)block
{
    self = [super init];
    if (self) {
        _executionBlockCD = block;
    }
    return self;
}


- (void)main {
    if (self.isCancelled) return;

    // Initialize Managed Object Context
    self.privateManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    // Configure Managed Object Context
    [self.privateManagedObjectContext setParentContext:[[LocalManager sharedManager] managedObjectContext]];
    NSThread *currentThread = [NSThread currentThread];
    [[currentThread threadDictionary] setObject:self.privateManagedObjectContext forKey:@"managedObjectContext"];
    
    if (_executionBlockCD && !self.cancelled) {
        _executionBlockCD();
    }

    if ([self.privateManagedObjectContext hasChanges]) {
        // Save Changes
        NSError *error = nil;
        [self.privateManagedObjectContext save:&error];
    }
}



@end
