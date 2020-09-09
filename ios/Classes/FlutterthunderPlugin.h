#import <Flutter/Flutter.h>

@interface FlutterthunderPlugin : NSObject<FlutterPlugin>
@property (strong, nonatomic, readonly) FlutterMethodChannel *methodChannel;

+ (instancetype)sharedPlugin;

#pragma mark -

+ (BOOL)boolFromArguments:(NSDictionary *)params key:(NSString *)key;
+ (NSDictionary *)dictionaryFromArguments:(NSDictionary *)params key:(NSString *)key;
+ (NSArray *)arrayFromArguments:(NSDictionary *)params key:(NSString *)key;
+ (NSInteger)intFromArguments:(NSDictionary *)params key:(NSString *)key;
+ (NSString *)stringFromArguments:(NSDictionary *)params key:(NSString *)key;
+ (NSNumber *)numberFromArguments:(NSDictionary *)params key:(NSString *)key;


@end


/// PlatformView
@interface ThunderRenderView : NSObject<FlutterPlatformView>

@end

@interface ThunderRenderViewFactory : NSObject<FlutterPlatformViewFactory>
@end



