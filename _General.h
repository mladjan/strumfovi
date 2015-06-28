// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to General.h instead.

#import <CoreData/CoreData.h>

extern const struct GeneralAttributes {
	__unsafe_unretained NSString *created_at;
	__unsafe_unretained NSString *updated_at;
} GeneralAttributes;

@interface GeneralID : NSManagedObjectID {}
@end

@interface _General : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) GeneralID* objectID;

@property (nonatomic, strong) NSDate* created_at;

//- (BOOL)validateCreated_at:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* updated_at;

//- (BOOL)validateUpdated_at:(id*)value_ error:(NSError**)error_;

@end

@interface _General (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreated_at;
- (void)setPrimitiveCreated_at:(NSDate*)value;

- (NSDate*)primitiveUpdated_at;
- (void)setPrimitiveUpdated_at:(NSDate*)value;

@end
