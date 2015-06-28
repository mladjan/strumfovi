//
//  LocalManager.m
//  Buy Master
//
//  Created by Mladjan Antic on 15/1/15.
//  Copyright (c) 2015 BLGRD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>






@interface LocalManager : NSObject

@property (nonatomic, strong) NSOperationQueue *syncQueue;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *timeFormater;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;



extern NSString * const PositionsSyncDone;



-(void)syncPositions;

- (NSURL *)applicationDocumentsDirectory;

+ (id)sharedManager;

#pragma mark - Helpers
#pragma mark - Generics
-(id)getObjectWithClass:(NSString *)className withId:(NSString *)objectId;
-(id)getUnfilteredObjectWithClass:(NSString *)className withId:(NSString *)objectId;
-(id)getFirstObjectWithClass:(NSString *)className;
-(NSArray *)getAllObjectsWithClass:(NSString *)className sortedBy:(NSString *)sortParam withPredicate:(NSPredicate *)predicate;

@end
