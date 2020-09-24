#import <Flutter/Flutter.h>


typedef NS_ENUM(NSInteger, FlutterThunderVideoCaptureFrameDataType)
{
  FLUTTER_THUNDER_VIDEO_CAPTURE_DATATYPE_PIXELBUFFER = 0,
    FLUTTER_THUNDER_VIDEO_CAPTURE_DATATYPE_TEXTURE = 1,
};

/**
 @protocol
 @brief Proxy interface for video frame preprocessing
 */
@protocol FlutterThunderVideoCaptureFrameObserver <NSObject>

@required
/**
 @brief Declaration is made to SDK on which format of data will be used. The following two methods will be called in accordance with the format set.
 @return Use which format to callback
 */
- (FlutterThunderVideoCaptureFrameDataType)needThunderVideoCaptureFrameDataType;

/**
 @brief Receive a frame of data from capture for processing and return processed data
 @param [OUT] pixelBuf  buf pointer of current frame
 @return Return the processed pixelbuff. If the data is not processed, return pixelbuffer in the parameter directly.
 */
- (CVPixelBufferRef _Nullable)onVideoCaptureFrame:(EAGLContext *_Nonnull)glContext
                                      PixelBuffer:(CVPixelBufferRef _Nonnull)pixelBuf;

/**
 @brief Return src texture and dst texture
 @param [OUT] context EAGLContext
 @param [OUT] pixelBuffer Original image pixelBuffer
 @param [OUT] srcTextureID ID of source texture
 @param [OUT] dstTextureID ID of destination texture
 @param [OUT] textureFormat Texture format
 @param [OUT] textureTarget texture target
 @param [OUT] width Texture width
 @param [OUT] height Texture height
 @return bool
 */
- (BOOL)onVideoCaptureFrame:(EAGLContext *_Nonnull)context
                PixelBuffer:(CVPixelBufferRef _Nonnull)pixelBuffer
            SourceTextureID:(unsigned int)srcTextureID
       DestinationTextureID:(unsigned int)dstTextureID
              TextureFormat:(int)textureFormat
              TextureTarget:(int)textureTarget
               TextureWidth:(int)width
              TextureHeight:(int)height;

@end

/**
 @protocol
 @brief Proxy interface for decoded frame data
 */
@protocol FlutterThunderVideoDecodeFrameObserver <NSObject>

@required
/**
 @brief Receive decoded frame data from decoder
 @param [OUT] pixelBuf buf pointer of current frame
 @param [OUT] pts Time shown in current frame
 @param [OUT] uid View the other's uid
*/
- (void)onVideoDecodeFrame:(CVPixelBufferRef _Nonnull) pixelBuf pts:(uint64_t)pts uid:(NSString* _Nonnull)uid;

@end

@interface FlutterthunderPlugin : NSObject<FlutterPlugin>
@property (strong, nonatomic, readonly) FlutterMethodChannel *methodChannel;

@property (strong, nonatomic, readwrite) id<FlutterThunderVideoCaptureFrameObserver> _Nullable flutterThunderVideoCaptureFrameObserver;
@property (strong, nonatomic, readwrite) id<FlutterThunderVideoDecodeFrameObserver> _Nullable flutterThunderVideoDecodeFrameObserver;


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



