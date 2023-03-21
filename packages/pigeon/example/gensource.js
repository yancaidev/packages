var fs = require("fs");

var code = `
  #ifndef __FLUTTER__

    /**
     * Error object representing an unsuccessful outcome of invoking a method
     * on a \`FlutterMethodChannel\`, or an error event on a \`FlutterEventChannel\`.
     */
    @interface FlutterError : NSObject
    /**
     * Creates a \`FlutterError\` with the specified error code, message, and details.
     *
     * @param code An error code string for programmatic use.
     * @param message A human-readable error message.
     * @param details Custom error details.
     */
    + (instancetype)errorWithCode:(NSString*)code
                          message:(NSString* _Nullable)message
                          details:(id _Nullable)details;
    /**
     The error code.
     */
    @property(readonly, nonatomic) NSString* code;
    
    /**
     The error message.
     */
    @property(readonly, nonatomic, nullable) NSString* message;
    
    /**
     The error details.
     */
    @property(readonly, nonatomic, nullable) id details;
    @end
    
    
        #endif
  `;

code = `
#ifndef __FLUTTER__
  @implementation FlutterError
+ (instancetype)errorWithCode:(NSString*)code message:(NSString*)message details:(id)details {
  return [[FlutterError alloc] initWithCode:code message:message details:details];
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
  if (![object isKindOfClass:[FlutterError class]]) {
    return NO;
  }
  FlutterError* other = (FlutterError*)object;
  return [self.code isEqual:other.code] &&
         ((!self.message && !other.message) || [self.message isEqual:other.message]) &&
         ((!self.details && !other.details) || [self.details isEqual:other.details]);
}

- (NSUInteger)hash {
  return [self.code hash] ^ [self.message hash] ^ [self.details hash];
}
@end
#endif
  `;

const lines = code.split("\n");
console.log(lines);
const target = "source.txt";
fs.writeFileSync(target, "");
lines.forEach((it) => {
  console.log(it);

  //   const content = it == "" ? "\n" : `indent.writeln('${it}');\n`;
  const content = `indent.writeln('${it}');\n`;
  fs.appendFileSync(target, content);
});
