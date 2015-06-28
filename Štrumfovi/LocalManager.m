//
//  LocalManager.m
//  Buy Master
//
//  Created by Mladjan Antic on 15/1/15.
//  Copyright (c) 2015 BLGRD. All rights reserved.
//


#import "LocalManager.h"
#import "NSDate+CupertinoYankee.h"
#import <AFNetworking/AFNetworking.h>
#import "BCDImportOperation.h"
#import "General.h"
#import "Position.h"

@implementation LocalManager

NSString * const PositionsSyncDone = @"PositionsSyncDone";


#pragma mark Singleton Methods

/**
 *  Class method for leazy SharedManager initialization
 *
 *  @return Singleton instance of LocalManager
 */
+ (id)sharedManager {
    static LocalManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

/**
 *  Initialization of the object, handled by sharedManager method
 *
 *  @return LocalManager object
 */
- (id)init {
    if (self = [super init]) {
        self.syncQueue = [[NSOperationQueue alloc] init];
        
        if([self.syncQueue respondsToSelector:@selector(setQualityOfService:)]){
            [self.syncQueue setQualityOfService:NSQualityOfServiceBackground];
        }
        self.syncQueue.maxConcurrentOperationCount = 1;
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        
        
        self.timeFormater = [[NSDateFormatter alloc] init];
        [self.timeFormater setTimeZone:[NSTimeZone localTimeZone]];
        [self.timeFormater setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"jj:mm a" options:0 locale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]]];
        self.timeFormater.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
		
		
    }
    return self;
}

#pragma mark - Sync

-(void)syncPositions{
    NSLog(@"Positions sync - START");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *lastSync = [defaults objectForKey:@"lastSync"];
    if(!lastSync){
        lastSync = [NSNumber numberWithInteger:1];
        [defaults setObject:[NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]] forKey:@"lastSync"];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:[NSString stringWithFormat:@"http://strumfovi.herokuapp.com/api/positions"] parameters:@{@"from":lastSync} success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSLog(@"Positions JSON: %@", responseObject);
        if([responseObject count] > 0){
            
            BCDImportOperation *importOperatoin = [[BCDImportOperation alloc] initWithExecutionBlock:^{
                for(NSDictionary *positionDic in responseObject){
                    [Position addOrUpdateObjectFromDictionary:positionDic];
                }
                
            }];
            importOperatoin.completionBlock = ^{
                NSLog(@"Positions sync - DONE");
                [[NSNotificationCenter defaultCenter] postNotificationName:PositionsSyncDone object:self];
                [self.managedObjectContext save:nil];
            };
            
            [self.syncQueue addOperation:importOperatoin];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@" 💥 ********* Positions sync - Error: %@", error);
            NSLog(@" 💥 ********* Response: %@", operation.responseString);
            
     }];

}




#pragma mark - Generics

-(id)getObjectWithClass:(NSString *)className withId:(NSString *)objectId{
    NSError *error;
    
    NSThread *currentThread = [NSThread currentThread];
    NSManagedObjectContext *privateContext = [[currentThread threadDictionary] objectForKey:@"managedObjectContext"];

    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[className stringByReplacingOccurrencesOfString:@"BCD" withString:@""] inManagedObjectContext:privateContext?privateContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];
    NSPredicate *combinedPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"id == %@", objectId],[NSPredicate predicateWithFormat:@"removed == NO"]]];
    [fetchRequest setPredicate:combinedPredicate];
    
    NSArray *fetchedObjects = [privateContext?privateContext:self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for(NSManagedObject *obj in fetchedObjects){
        [privateContext?privateContext:self.managedObjectContext refreshObject:obj mergeChanges:YES];
    }
    
    return [fetchedObjects lastObject];
}


-(id)getUnfilteredObjectWithClass:(NSString *)className withId:(NSString *)objectId{
    NSError *error;
    
    NSThread *currentThread = [NSThread currentThread];
    NSManagedObjectContext *privateContext = [[currentThread threadDictionary] objectForKey:@"managedObjectContext"];

    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[className stringByReplacingOccurrencesOfString:@"BCD" withString:@""] inManagedObjectContext:privateContext?privateContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", objectId]];
    
    NSArray *fetchedObjects = [privateContext?privateContext:self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for(NSManagedObject *obj in fetchedObjects){
        [privateContext?privateContext:self.managedObjectContext refreshObject:obj mergeChanges:YES];
    }
    
    return [fetchedObjects lastObject];
}

-(id)getFirstObjectWithClass:(NSString *)className{
    return [[self getAllObjectsWithClass:className sortedBy:@"id" withPredicate:nil] firstObject];
}

-(NSArray *)getAllObjectsWithClass:(NSString *)className sortedBy:(NSString *)sortParam withPredicate:(NSPredicate *)predicate{
    NSError *error;
    
    NSThread *currentThread = [NSThread currentThread];
    NSManagedObjectContext *privateContext = [[currentThread threadDictionary] objectForKey:@"managedObjectContext"];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[className stringByReplacingOccurrencesOfString:@"BCD" withString:@""] inManagedObjectContext:privateContext?privateContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    if(predicate){
        [fetchRequest setPredicate:predicate];
    }
    
    if(sortParam){
        if([sortParam isEqualToString:@"created_at"] || [sortParam isEqualToString:@"updated_at"]){
            [fetchRequest setSortDescriptors:@[[NSSortDescriptor
                                                sortDescriptorWithKey:sortParam
                                                ascending:NO]]];
        }else if([sortParam isEqualToString:@"id"]){
            [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:sortParam ascending:YES]]];
        }else{
            NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortParam
                                                                               ascending:YES
                                                                                selector:@selector(localizedCaseInsensitiveCompare:)];
            [fetchRequest setSortDescriptors:@[nameSortDescriptor]];
            
        }
    }
    NSArray *fetchedObjects = [privateContext?privateContext:self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "co.blgrd.BUMModel" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"S_trumfovi" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {

    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"S_trumfovi.sqlite"];

    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @(YES),
                               NSInferMappingModelAutomaticallyOption : @(YES) };

    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;

    
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

@end
