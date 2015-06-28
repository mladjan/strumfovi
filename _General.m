// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to General.m instead.

#import "_General.h"

const struct GeneralAttributes GeneralAttributes = {
	.created_at = @"created_at",
	.updated_at = @"updated_at",
};

@implementation GeneralID
@end

@implementation _General

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"General" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"General";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"General" inManagedObjectContext:moc_];
}

- (GeneralID*)objectID {
	return (GeneralID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic created_at;

@dynamic updated_at;

@end

