#import "General.h"

@interface General ()

// Private interface goes here.

@end

@implementation General


+(id)addOrUpdateObjectFromDictionary:(NSDictionary *)dictionary{
    
    if([dictionary isKindOfClass:[NSDictionary class]]){
        return [self addOrUpdateObjectFromDictionary:dictionary withClassName:[[[self class] description] stringByReplacingOccurrencesOfString:@"BCD" withString:@""]];
    }else if([dictionary isKindOfClass:[NSArray class]]){
        return [self addOrUpdateObjectFromDictionary:[(NSArray *)dictionary firstObject] withClassName:[[[self class] description] stringByReplacingOccurrencesOfString:@"BCD" withString:@""]];
    }else{
        return nil;
    }
}

+(id)addOrUpdateObjectFromDictionary:(NSDictionary *)dictionary withClassName:(NSString *)className{
    NSThread *currentThread = [NSThread currentThread];
    NSManagedObjectContext *privateContext = [[currentThread threadDictionary] objectForKey:@"managedObjectContext"];
    
    if(!privateContext){
        privateContext = [[LocalManager sharedManager] managedObjectContext];
    }
    id obj = [[LocalManager sharedManager] getUnfilteredObjectWithClass:[className stringByReplacingOccurrencesOfString:@"BCD" withString:@""] withId:[dictionary objectForKey:@"id"]];
    if(!obj){
        obj = [NSEntityDescription insertNewObjectForEntityForName:[className stringByReplacingOccurrencesOfString:@"BCD" withString:@""] inManagedObjectContext:privateContext];
    }
    
    [obj safeSetValuesForKeysWithDictionary:dictionary];
    return obj;
}


+(BOOL)doesObjectExistsWithClass:(NSString *)className withId:(NSString *)objectId{
    NSManagedObject *obj;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSThread *currentThread = [NSThread currentThread];
    NSManagedObjectContext *privateContext = [[currentThread threadDictionary] objectForKey:@"managedObjectContext"];
    
    request.entity = [NSEntityDescription entityForName:className inManagedObjectContext:privateContext];
    request.predicate = [NSPredicate predicateWithFormat:@"id = %@", objectId];
    NSError *executeFetchError = nil;
    obj = [[privateContext executeFetchRequest:request error:&executeFetchError] lastObject];
    
    if (executeFetchError) {
        return NO;
    } else if (!obj) {
        return NO;
    }else{
        return YES;
    }
}

@end
