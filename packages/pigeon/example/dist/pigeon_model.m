// Autogenerated from Pigeon (v9.1.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import <Foundation/Foundation.h>
#import "pigeon_model.h"

NS_ASSUME_NONNULL_BEGIN
#ifndef __FLUTTER__
#endif

  @implementation ACError
+ (instancetype)errorWithCode:(NSString*)code message:(NSString* _Nullable)message details:(id _Nullable)details {
  return [[ACError alloc] initWithCode:code message:message details:details];
}

- (instancetype)initWithCode:(NSString*)code message:(NSString*)message details:(id)details {
  NSAssert(code, @"Code cannot be nil");
  self = [super init];
  NSAssert(self, @"Super init cannot be nil");
  _code = [code copy];
  _message = [message copy];
  _details = details;
  return self;
}

- (BOOL)isEqual:(id)object {
  if (self == object) {
    return YES;
  }
  if (![object isKindOfClass:[ACError class]]) {
    return NO;
  }
  ACError* other = (ACError*)object;
  return [self.code isEqual:other.code] &&
         ((!self.message && !other.message) || [self.message isEqual:other.message]) &&
         ((!self.details && !other.details) || [self.details isEqual:other.details]);
}

- (NSUInteger)hash {
  return [self.code hash] ^ [self.message hash] ^ [self.details hash];
}
@end
  
#ifndef __FLUTTER__
@implementation Hello
+ (instancetype)makeWithName:(NSString *)name {
  Hello* pigeonResult = [[Hello alloc] init];
  pigeonResult.name = name;
  return pigeonResult;
}
@end

#endif
NS_ASSUME_NONNULL_END
