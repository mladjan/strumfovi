#import "_General.h"

@interface General : _General {}

+(id)addOrUpdateObjectFromDictionary:(NSDictionary *)dictionary;
+(id)addOrUpdateObjectFromDictionary:(NSDictionary *)dictionary withClassName:(NSString *)className;


@end
