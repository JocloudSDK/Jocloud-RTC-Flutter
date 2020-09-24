#import "FlutterthunderPlugin.h"
#import "ThunderEngine.h"

static inline void dispatch_sync_on_main_queue(void (^block)(void))
{
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

static NSString *const kThunderChannel = @"flutterthunder";
static NSString *const kEventChannel = @"flutterthunder_event_channel";
static NSString *const kRenderViewType = @"ThunderRenderView";
static NSString *const kLog = @"FlutterthunderPlugin";
static NSString *const kImageAssetsName = @"images";

@interface ThunderRenderView()
@property (nonatomic, strong) UIView *renderView;
@property (nonatomic, assign) int64_t viewId;
@end

@implementation ThunderRenderView
- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId
{
    if (self = [super init]) {
        self.renderView = [[UIView alloc] initWithFrame:frame];
        self.renderView.backgroundColor = [UIColor blackColor];
        self.viewId = viewId;
    }
    return self;
}

- (nonnull UIView *)view
{
    return self.renderView;
}

@end


@interface FlutterthunderPlugin()<FlutterStreamHandler,ThunderRtcLogDelegate,ThunderRtcLogDelegate,ThunderEventDelegate,ThunderVideoCaptureFrameObserver,ThunderVideoDecodeFrameObserver>
@property (strong, nonatomic) ThunderEngine *thunderEngine;
@property (strong, nonatomic, readwrite) FlutterMethodChannel *methodChannel;
@property (strong, nonatomic) FlutterEventChannel *eventChannel;
@property (strong, nonatomic) FlutterEventSink eventSink;
@property (strong, nonatomic) NSMapTable *rendererViews;
@property (strong, nonatomic) NSString *imageAssetsPath;
@end


@implementation FlutterthunderPlugin

#pragma mark - renderer views

+ (instancetype)sharedPlugin
{
    static FlutterthunderPlugin* plugin = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        plugin = [[FlutterthunderPlugin alloc] init];
    });
    return plugin;
}

- (NSMapTable *)rendererViews
{
    if (!_rendererViews) {
        _rendererViews = [NSMapTable strongToWeakObjectsMapTable];
    }
    return _rendererViews;
}

+ (void)addView:(UIView *)view viewId:(NSNumber *)ID
{
    if (!ID) {
        return;
    }
    if (view) {
        [[[FlutterthunderPlugin sharedPlugin] rendererViews] setObject:view forKey:ID];
    } else {
        [self removeViewForId:ID];
    }
}

+ (void)removeViewForId:(NSNumber *)viewId
{
    if (!viewId) {
        return;
    }
    [[[FlutterthunderPlugin sharedPlugin] rendererViews] removeObjectForKey:viewId];
}

+ (UIView *)viewForId:(NSNumber *)viewId
{
    if (!viewId) {
        return nil;
    }
    return [[[FlutterthunderPlugin sharedPlugin] rendererViews] objectForKey:viewId];
}

#pragma mark - flutter

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar
{
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:kThunderChannel
                                                                binaryMessenger:[registrar messenger]];
    FlutterEventChannel *eventChannel = [FlutterEventChannel eventChannelWithName:kEventChannel
                                                                  binaryMessenger:registrar.messenger];
    FlutterthunderPlugin *instance = [FlutterthunderPlugin sharedPlugin];
    instance.eventChannel = eventChannel;
    instance.methodChannel = channel;
    [registrar addMethodCallDelegate:instance channel:channel];
    [eventChannel setStreamHandler:instance];
    instance.imageAssetsPath = [registrar lookupKeyForAsset:kImageAssetsName];

    //liveView
    ThunderRenderViewFactory *renderViewFactory = [[ThunderRenderViewFactory alloc] init];
    [registrar registerViewFactory:renderViewFactory withId:kRenderViewType];

}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result
{
    NSString *method = call.method;
    NSDictionary *params = call.arguments;
    NSLog(@"%@ - plugin handleMethodCall: %@, argus: %@", kLog, method, params);

    if (method.length == 0) {
        result(FlutterMethodNotImplemented);
        return;
    }

    //带params, result参数的方法
    NSString *methodName = [NSString stringWithFormat:@"%@:result:",method];
    SEL nativeSEL = NSSelectorFromString(methodName);
    if ([self respondsToSelector:nativeSEL]) {
        IMP imp = [self methodForSelector:nativeSEL];
        void (*func)(id, SEL, NSDictionary *, FlutterResult) = (void *)imp;
        func(self, nativeSEL, params, result);
        return;
    }

    //带一个参数
    methodName = [NSString stringWithFormat:@"%@:",method];
    nativeSEL = NSSelectorFromString(methodName);
    if ([self respondsToSelector:nativeSEL]) {
        IMP imp = [self methodForSelector:nativeSEL];
        //有params参数
        if ([params isKindOfClass:NSDictionary.class]) {
            IMP imp = [self methodForSelector:nativeSEL];
            void (*func)(id, SEL, NSDictionary *) = (void *)imp;
            func(self, nativeSEL, params);
        }else {
            void (*func)(id, SEL, FlutterResult) = (void *)imp;
            func(self, nativeSEL, result);
        }
        return;
    }

    //不带任何参数的方法
    methodName = [NSString stringWithFormat:@"%@",method];
    nativeSEL = NSSelectorFromString(methodName);
    if ([self respondsToSelector:nativeSEL]) {
        IMP imp = [self methodForSelector:nativeSEL];
        void (*func)(id, SEL) = (void *)imp;
        func(self, nativeSEL);
        return;
    }
    result(FlutterMethodNotImplemented);
}

#pragma mark - Core Method

- (void)createEngine:(NSDictionary *)params result:(FlutterResult)result
{
    if (!self.thunderEngine) {
        NSString *appId = [FlutterthunderPlugin stringFromArguments:params key:@"appId"];
        NSAssert(appId != nil, @"初始化参数不能为空");

        NSInteger area = [FlutterthunderPlugin intFromArguments:params key:@"area"];
        BOOL is64bitUid = [FlutterthunderPlugin boolFromArguments:params key:@"is64bitUid"];
        self.thunderEngine = [ThunderEngine createEngine:appId sceneId:0 delegate:self];
        [self.thunderEngine setArea:area];
        [self.thunderEngine setUse64bitUid:is64bitUid];
        // Debug模式下直接打印日志
    #ifdef DEBUG
        [self.thunderEngine setLogCallback:self];
    #endif
    }
    //处理手动杀掉App后SDK没有退出房间，导致其他用户进入时还显示当前用户黑屏画面，app退出后后端会自动退出房间，SDK不会
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillTerminateNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self.thunderEngine leaveRoom];
        [self destroyEngine];
    }];
    result(nil);
}

- (void)leaveRoom:(NSDictionary *)params result:(FlutterResult)result
{
    int code = [self.thunderEngine leaveRoom];
    NSLog(@"%@ - leaveRoom code: %d", kLog, code);
    result([NSNumber numberWithInt:code]);
}

- (void)joinRoom:(NSDictionary *)params result:(FlutterResult)result
{
    NSString *token = [FlutterthunderPlugin stringFromArguments:params key:@"token"];
    NSString *roomName = [FlutterthunderPlugin stringFromArguments:params key:@"roomName"];
    NSString *uid = [FlutterthunderPlugin stringFromArguments:params key:@"uid"];
    NSAssert(roomName != nil, @"failed: joinRoom roomName is nil");
    NSAssert(uid != nil, @"failed: joinRoom uid is nil");
    int code = [self.thunderEngine joinRoom:token roomName:roomName uid:uid];
    NSLog(@"%@ - joinRoom token:%@, roomName: %@, uid:%@, code: %d", kLog, token, roomName, uid, code);
    result([NSNumber numberWithInt:code]);
}

- (void)addSubscribe:(NSDictionary *)params result:(FlutterResult)result
{
    NSString *roomId = [FlutterthunderPlugin stringFromArguments:params key:@"roomId"];
    NSAssert(roomId != nil, @"failed: addSubscribe roomId is nil");
    NSString *uid = [FlutterthunderPlugin stringFromArguments:params key:@"uid"];
    NSAssert(uid != nil, @"failed: addSubscribe uid is nil");
    NSLog(@"%@ - addSubscribe roomId: %@, uid: %@", kLog, roomId, uid);
    int code = [self.thunderEngine addSubscribe:roomId uid:uid];
    result([NSNumber numberWithInt:code]);
}

- (void)removeSubscribe:(NSDictionary *)params result:(FlutterResult)result
{
    NSString *roomId = [FlutterthunderPlugin stringFromArguments:params key:@"roomId"];
    NSString *uid = [FlutterthunderPlugin stringFromArguments:params key:@"uid"];
    NSAssert(roomId != nil, @"failed: removeSubscribe roomId is nil");
    NSAssert(uid != nil, @"failed: removeSubscribe uid is nil");
    int code = [self.thunderEngine removeSubscribe:roomId uid:uid];
    NSLog(@"%@ - addSubscribe roomId: %@, uid: %@, code: %d", kLog, roomId, uid, code);
    result([NSNumber numberWithInt:code]);
}

- (void)updateToken:(NSDictionary *)params result:(FlutterResult)result
{
    NSString *token = [FlutterthunderPlugin stringFromArguments:params key:@"token"];
    NSAssert(token != nil, @"failed: updateToken token is nil");
    int code = [self.thunderEngine updateToken:token];
    NSLog(@"%@ - update token: %@, code: %d", kLog, token,code);
    result([NSNumber numberWithInt:code]);
}

- (void)setRoomMode:(NSDictionary *)params result:(FlutterResult)result
{
    NSInteger roomConfig = [FlutterthunderPlugin intFromArguments:params key:@"roomConfig"];
    int code = [self.thunderEngine setRoomMode:roomConfig];
    NSLog(@"%@ - setRoomMode: %ld code: %d", kLog,(long)roomConfig, code);
    result([NSNumber numberWithInt:code]);
}

- (void)setMediaMode:(NSDictionary *)params result:(FlutterResult)result
{
    NSInteger rtcConfig = [FlutterthunderPlugin intFromArguments:params key:@"rtcConfig"];
    int code = [self.thunderEngine setMediaMode:rtcConfig];
    NSLog(@"%@ - setMediaMode rtcConfig: %ld,code: %d", kLog, (long)rtcConfig,  code);
    result([NSNumber numberWithInt:code]);
}

- (void)removeNativeView:(NSDictionary *)params result:(FlutterResult)result
{
    NSNumber *viewId = [FlutterthunderPlugin numberFromArguments:params key:@"viewId"];
    if (viewId != nil) {
        [self.rendererViews removeObjectForKey:viewId];
    }
}

- (void)setLogFilePath:(NSDictionary *)params result:(FlutterResult)result
{
    NSString *path = [FlutterthunderPlugin stringFromArguments:params key:@"path"];
    int code = [self.thunderEngine setLogFilePath:path];
    NSLog(@"%@ - setLogFilePath: %@, code: %d", kLog, path,code);
    result([NSNumber numberWithInt:code]);
}


#pragma mark - Core Video

- (void)setVideoEncoderConfig:(NSDictionary *)params result:(FlutterResult)result
{
    NSNumber *playType = [FlutterthunderPlugin numberFromArguments:params key:@"playType"];
    NSAssert(playType != nil, @"failed: setVideoEncoderConfig playType is nil");

    NSNumber *publishMode = [FlutterthunderPlugin numberFromArguments:params key:@"mode"];
    NSAssert(publishMode != nil, @"failed: setVideoEncoderConfig publishMode is nil");

    ThunderVideoEncoderConfiguration *config = [ThunderVideoEncoderConfiguration new];
    config.playType = [playType intValue];
    config.publishMode = [publishMode intValue];
    int code = [self.thunderEngine setVideoEncoderConfig:config];
    NSLog(@"%@ - setVideoEncoderConfig playType: %@ publishMode: %@, code:%d", kLog, playType, publishMode, code);
    result([NSNumber numberWithInt:code]);
}

- (void)setLocalVideoCanvas:(NSDictionary *)params result:(FlutterResult)result
{
    NSNumber *viewId = [FlutterthunderPlugin numberFromArguments:params key:@"viewId"];
    NSInteger renderMode = [FlutterthunderPlugin intFromArguments:params key:@"renderMode"];
    NSString *uid = [FlutterthunderPlugin stringFromArguments:params key:@"uid"];
    NSAssert(uid != nil, @"failed :setLocalVideoCanvas uid is nil");
    UIView *renderView = [FlutterthunderPlugin viewForId:viewId];

    NSAssert(renderView != nil, @"setLocalVideoCanvas renderView is nil");
    ThunderVideoCanvas *canvas = [[ThunderVideoCanvas alloc] init];
    canvas.view = renderView;
    canvas.renderMode = renderMode;
    canvas.uid = uid;
    int code = [self.thunderEngine setLocalVideoCanvas:canvas];
    NSLog(@"%@ - setLocalVideoCanvas viewId: %@, renderMode: %zd, uid: %@, code: %d", kLog,viewId, renderMode, uid, code);
    result([NSNumber numberWithInt:code]);
}

- (void)unbindLocalVideoCanvas:(NSDictionary *)params result:(FlutterResult)result
{
    NSString *uid = [FlutterthunderPlugin stringFromArguments:params key:@"uid"];
    ThunderVideoCanvas *canvas = [[ThunderVideoCanvas alloc] init];
    canvas.view = nil;
    canvas.uid = uid;
    int code = [self.thunderEngine setLocalVideoCanvas:canvas];
    NSLog(@"%@ - unbindLocalVideoCanvas uid: %@, code: %d", kLog,uid, code);
    result([NSNumber numberWithInt:code]);
}

- (void)setRemoteVideoCanvas:(NSDictionary *)params result:(FlutterResult)result;
{
    NSNumber *viewId = [FlutterthunderPlugin numberFromArguments:params key:@"viewId"];
    NSInteger renderMode = [FlutterthunderPlugin intFromArguments:params key:@"renderMode"];
    NSString *uid = [FlutterthunderPlugin stringFromArguments:params key:@"uid"];
    NSNumber *index = [FlutterthunderPlugin numberFromArguments:params key:@"seatIndex"]; //多人连麦场景下设置
    NSAssert(uid != nil, @"failed :setRemoteVideoCanvas uid is nil");

    UIView *renderView = [FlutterthunderPlugin viewForId:viewId];
    NSAssert(renderView != nil, @"setRemoteVideoCanvas renderView is nil");
    ThunderVideoCanvas *canvas = [[ThunderVideoCanvas alloc] init];
    canvas.view = renderView;
    canvas.renderMode = renderMode;
    canvas.uid = uid;
    if (index != nil) {
        canvas.seatIndex = index.intValue;
    }
    int code = [self.thunderEngine setRemoteVideoCanvas:canvas];
    NSLog(@"%@ - setRemoteVideoCanvas viewId: %@, renderMode: %zd, uid: %@ ,index: %@, code:%d", kLog,viewId, renderMode, uid, index, code);
    result([NSNumber numberWithInt:code]);
}

- (void)unbindRemoteVideoCanvas:(NSDictionary *)params result:(FlutterResult)result
{
    NSString *uid = [FlutterthunderPlugin stringFromArguments:params key:@"uid"];
    ThunderVideoCanvas *canvas = [[ThunderVideoCanvas alloc] init];
    canvas.view = nil;
    canvas.uid = uid;
    int code = [self.thunderEngine setRemoteVideoCanvas:canvas];
    NSLog(@"%@ - unbindRemoteVideoCanvas uid: %@, code: %d", kLog,uid, code);
    result([NSNumber numberWithInt:code]);
}

- (void)setLocalCanvasScaleMode:(NSDictionary *)params result:(FlutterResult)result
{
    NSInteger renderMode = [FlutterthunderPlugin intFromArguments:params key:@"mode"];
    int code = [self.thunderEngine setLocalCanvasScaleMode:renderMode];
    NSLog(@"%@ - setLocalCanvasScaleMode renderMode: %zd, code: %d", kLog, renderMode, code);
    result([NSNumber numberWithInt:code]);
}

- (void)setRemoteCanvasScaleMode:(NSDictionary *)params result:(FlutterResult)result
{
    NSInteger renderMode = [FlutterthunderPlugin intFromArguments:params key:@"mode"];
    NSString *uid = [FlutterthunderPlugin stringFromArguments:params key:@"uid"];
    NSAssert(uid != nil, @"failed :setRemoteCanvasScaleMode uid is nil");
    int code = [self.thunderEngine setRemoteCanvasScaleMode:uid mode:renderMode];
    NSLog(@"%@ - setRemoteCanvasScaleMode renderMode: %zd, uid: %@, code:%d", kLog, renderMode, uid, code);
    result([NSNumber numberWithInt:code]);
}

- (void)startVideoPreview:(FlutterResult)result
{
    int code = [self.thunderEngine startVideoPreview];
    NSLog(@"%@ - startVideoPreview code:%d", kLog, code);
    result([NSNumber numberWithInt:code]);
}

- (void)stopVideoPreview:(FlutterResult)result
{
    int code = [self.thunderEngine stopVideoPreview];
    NSLog(@"%@ - stopVideoPreview code:%d", kLog, code);
    result([NSNumber numberWithInt:code]);
}

- (void)enableLocalVideoCapture:(NSDictionary *)params result:(FlutterResult)result
{
    BOOL enable = [FlutterthunderPlugin boolFromArguments:params key:@"enable"];
    int code = [self.thunderEngine enableLocalVideoCapture:enable];
    NSLog(@"%@ - enableLocalVideoCapture enable:%d, code:%d", kLog, enable, code);
    result([NSNumber numberWithInt:code]);
}

- (void)stopLocalVideoStream:(NSDictionary *)params result:(FlutterResult)result
{
    BOOL stopped = [FlutterthunderPlugin boolFromArguments:params key:@"stopped"];
    int code = [self.thunderEngine stopLocalVideoStream:stopped];
    NSLog(@"%@ - enableLocalVideoCapture stopped:%d, code:%d", kLog, stopped, code);
    result([NSNumber numberWithInt:code]);
}

- (void)stopRemoteVideoStream:(NSDictionary *)params result:(FlutterResult)result
{
    NSString *uid = [FlutterthunderPlugin stringFromArguments:params key:@"uid"];
    BOOL stopped = [FlutterthunderPlugin boolFromArguments:params key:@"stopped"];
    NSAssert(uid != nil, @"failed :stopRemoteVideoStream uid is nil");
    int code = [self.thunderEngine stopRemoteVideoStream:uid stopped:stopped];
    NSLog(@"%@ - stopRemoteVideoStream stopped: %d, uid: %@, code: %d", kLog, stopped, uid, code);
    result([NSNumber numberWithInt:code]);
}

- (void)stopAllRemoteVideoStreams:(NSDictionary *)params result:(FlutterResult)result
{
    BOOL stopped = [FlutterthunderPlugin boolFromArguments:params key:@"stopped"];
    int code = [self.thunderEngine stopAllRemoteVideoStreams:stopped];
    NSLog(@"%@ - stopAllRemoteVideoStreams stopped:%d, code:%d", kLog, stopped, code);
    result([NSNumber numberWithInt:code]);
}

- (void)registerVideoCaptureFrameObserver:(NSDictionary *)params result:(FlutterResult)result
{
   int code = [self.thunderEngine registerVideoCaptureFrameObserver:self];
   result([NSNumber numberWithInt:code]);
}

- (void)registerVideoDecodeFrameObserver:(NSDictionary *)params result:(FlutterResult)result
{
    NSString *uid = [FlutterthunderPlugin stringFromArguments:params key:@"uid"];
    int code = [self.thunderEngine registerVideoDecodeFrameObserver:self uid:uid];
    result([NSNumber numberWithInt:code]);
}

- (void)setLocalVideoMirrorMode:(NSDictionary *)params result:(FlutterResult)result
{
    NSInteger mirrorMode = [FlutterthunderPlugin intFromArguments:params key:@"mode"];
    int code = [self.thunderEngine setLocalVideoMirrorMode:mirrorMode];
    NSLog(@"%@ - setLocalVideoMirrorMode mirrorMode: %zd , code: %d", kLog, mirrorMode, code);
    result([NSNumber numberWithInt:code]);
}

- (void)setVideoCaptureOrientation:(NSDictionary *)params result:(FlutterResult)result
{
    NSInteger orientation = [FlutterthunderPlugin intFromArguments:params key:@"orientation"];
    int code = [self.thunderEngine setVideoCaptureOrientation:orientation];
    NSLog(@"%@ - setVideoCaptureOrientation orientation: %zd, code:%d", kLog, orientation, code);
    result([NSNumber numberWithInt:code]);
}

- (void)switchFrontCamera:(NSDictionary *)params result:(FlutterResult)result
{
    BOOL bFront = [FlutterthunderPlugin boolFromArguments:params key:@"bFront"];
    int code = [self.thunderEngine switchFrontCamera:bFront];
    NSLog(@"%@ - switchFrontCamera orientation: %d, code: %d", kLog, bFront, code);
    result([NSNumber numberWithInt:code]);
}

- (void)setMultiVideoViewLayout:(NSDictionary *)params result:(FlutterResult)result
{
    NSArray *videoPositions = [FlutterthunderPlugin arrayFromArguments:params key:@"videoPositions"];
    NSMutableArray *postionsM = [NSMutableArray new];
    [videoPositions enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ThunderMultiVideoViewCoordinate *coodinate = [self map2Coordinate:obj];
        if (coodinate) {
            [postionsM addObject:coodinate];
        }
    }];

    NSDictionary *bgCoodinateMap = [FlutterthunderPlugin dictionaryFromArguments:params key:@"bgCoodinate"];
    ThunderMultiVideoViewParam *viewParam = [ThunderMultiVideoViewParam new];
    viewParam.bgCoordinate = [self map2Coordinate:bgCoodinateMap];
    viewParam.bgImageName =  [self.imageAssetsPath stringByAppendingPathComponent:[FlutterthunderPlugin stringFromArguments:params key:@"bgImageName"]];
    viewParam.videoPositions = postionsM.copy;

    //多视图模式：viewId是flutter创建plateformView时分配的与UIView是唯一对应
    NSNumber *viewKey = [FlutterthunderPlugin numberFromArguments:params key:@"viewId"];
    viewParam.view = [FlutterthunderPlugin viewForId:viewKey];
    //坐标是要设置在哪个view上
    viewParam.viewId = [[FlutterthunderPlugin numberFromArguments:params key:@"viewIndex"] intValue];

    int code = [self.thunderEngine setMultiVideoViewLayout: viewParam];
    NSLog(@"%@ - setMultiVideoViewLayout videoPositions: %@, bgCoordinate: %@, bgImageName:%@, viewId: %d, view:%@, code: %d", kLog, videoPositions, viewParam.bgCoordinate,viewParam.bgImageName,viewParam.viewId,viewParam.view, code);
    result([NSNumber numberWithInt:code]);
}

- (void)setRemotePlayType:(NSDictionary *)params result:(FlutterResult)result
{
    NSInteger playType = [FlutterthunderPlugin intFromArguments:params key:@"remotePlayType"];
    int code = [self.thunderEngine setRemotePlayType:playType];
    NSLog(@"%@ - setRemotePlayType code: %d", kLog, code);
    result([NSNumber numberWithInt:code]);
}

#pragma mark - Core Audio

- (void)setAudioConfig:(NSDictionary *)params result:(FlutterResult)result
{
    NSInteger config = [FlutterthunderPlugin intFromArguments:params key:@"config"];
    NSInteger commutMode = [FlutterthunderPlugin intFromArguments:params key:@"commutMode"];
    NSInteger scenarioMode = [FlutterthunderPlugin intFromArguments:params key:@"scenarioMode"];
    int code = [self.thunderEngine setAudioConfig:config commutMode:commutMode scenarioMode:scenarioMode];
    NSLog(@"%@ - setAudioConfig config:%zd, commutMode:%zd, scenarioMode:%zd, code: %d", kLog, config, commutMode, scenarioMode, code);
    result([NSNumber numberWithInt:code]);
}

- (void)setAudioSourceType:(NSDictionary *)params result:(FlutterResult)result
{
    NSInteger sourceType = [FlutterthunderPlugin intFromArguments:params key:@"sourceType"];
    NSLog(@"%@ - setAudioSourceType sourceType:%zd", kLog, sourceType);
    [self.thunderEngine setAudioSourceType:sourceType];
    result(nil);
}

- (void)setAudioVolumeIndication:(NSDictionary *)params result:(FlutterResult)result
{
    NSInteger interval = [FlutterthunderPlugin intFromArguments:params key:@"interval"];
    NSInteger moreThanThd = [FlutterthunderPlugin intFromArguments:params key:@"moreThanThd"];
    NSInteger lessThanThd = [FlutterthunderPlugin intFromArguments:params key:@"lessThanThd"];
    NSInteger smooth = [FlutterthunderPlugin intFromArguments:params key:@"smooth"];
    int code = [self.thunderEngine setAudioVolumeIndication:interval moreThanThd:moreThanThd lessThanThd:lessThanThd smooth:smooth];
    NSLog(@"%@ - setAudioVolumeIndication interval:%zd, moreThanThd:%zd, lessThanThd:%zd, smooth:%zd, code: %d", kLog, interval, moreThanThd, lessThanThd, smooth, code);
    result([NSNumber numberWithInt:code]);
}

- (void)stopLocalAudioStream:(NSDictionary *)params result:(FlutterResult)result
{
    BOOL stopped = [FlutterthunderPlugin boolFromArguments:params key:@"stopped"];
    int code = [self.thunderEngine stopLocalAudioStream:stopped];
    NSLog(@"%@ - stopLocalAudioStream stopped:%d, code: %d", kLog, stopped, code);
    result([NSNumber numberWithInt:code]);
}

- (void)stopRemoteAudioStream:(NSDictionary *)params result:(FlutterResult)result
{
    NSString *uid = [FlutterthunderPlugin stringFromArguments:params key:@"uid"];
    BOOL stopped = [FlutterthunderPlugin boolFromArguments:params key:@"stopped"];
    NSAssert(uid != nil, @"failed: stopRemoteAudioStream uid is nil");
    int code= [self.thunderEngine stopRemoteAudioStream:uid stopped:stopped];
    NSLog(@"%@ - stopRemoteAudioStream uid:%@, stopped:%d, code: %d", kLog, uid, stopped, code);
    result([NSNumber numberWithInt:code]);
}

- (void)stopAllRemoteAudioStreams:(NSDictionary *)params result:(FlutterResult)result
{
    BOOL stopped = [FlutterthunderPlugin boolFromArguments:params key:@"stopped"];
    int code = [self.thunderEngine stopAllRemoteAudioStreams:stopped];
    NSLog(@"%@ - stopAllRemoteAudioStreams stopped:%d, code: %d", kLog, stopped, code);
    result([NSNumber numberWithInt:code]);
}

- (void)enableCaptureVolumeIndication:(NSDictionary *)params result:(FlutterResult)result
{
    NSInteger interval = [FlutterthunderPlugin intFromArguments:params key:@"interval"];
    NSInteger moreThanThd = [FlutterthunderPlugin intFromArguments:params key:@"moreThanThd"];
    NSInteger lessThanThd = [FlutterthunderPlugin intFromArguments:params key:@"lessThanThd"];
    NSInteger smooth = [FlutterthunderPlugin intFromArguments:params key:@"smooth"];
    int code = [self.thunderEngine enableCaptureVolumeIndication:interval moreThanThd:moreThanThd lessThanThd:lessThanThd smooth:smooth];
    NSLog(@"%@ - enableCaptureVolumeIndication interval:%zd, moreThanThd:%zd, lessThanThd:%zd, smooth:%zd, code: %d", kLog, interval, moreThanThd, lessThanThd, smooth, code);
    result([NSNumber numberWithInt:code]);
}

- (void)enableLoudspeaker:(NSDictionary *)params result:(FlutterResult)result
{
    BOOL enable = [FlutterthunderPlugin boolFromArguments:params key:@"enable"];
    int code = [self.thunderEngine enableLoudspeaker:enable];
    NSLog(@"%@ - enableLoudspeaker enable:%d, code: %d", kLog, enable, code);
    result([NSNumber numberWithInt:code]);
}

- (void)isLoudspeakerEnabled:(FlutterResult)result
{
    BOOL enable = [self.thunderEngine isLoudspeakerEnabled];
    NSLog(@"%@ - isLoudspeakerEnabled enable:%d", kLog, enable);
    result([NSNumber numberWithBool:enable]);
}

- (void)setLoudSpeakerVolume:(NSDictionary *)params result:(FlutterResult)result
{
    NSInteger volume = [FlutterthunderPlugin intFromArguments:params key:@"volume"];
    int code = [self.thunderEngine setLoudSpeakerVolume:volume];
    NSLog(@"%@ - setLoudSpeakerVolume volume:%zd, code: %d", kLog, volume, code);
    result([NSNumber numberWithInt:code]);
}

- (void)setMicVolume:(NSDictionary *)params result:(FlutterResult)result
{
    NSInteger volume = [FlutterthunderPlugin intFromArguments:params key:@"volume"];
    int code = [self.thunderEngine setMicVolume:volume];
    NSLog(@"%@ - setMicVolume volume:%zd, code: %d", kLog, volume, code);
    result([NSNumber numberWithInt:code]);
}

- (void)setPlayVolume:(NSDictionary *)params result:(FlutterResult)result
{
    NSString *uid = [FlutterthunderPlugin stringFromArguments:params key:@"uid"];
    NSAssert(uid != nil, @"failed :setPlayVolume uid is nil");
    NSInteger volume = [FlutterthunderPlugin intFromArguments:params key:@"volume"];
    int code = [self.thunderEngine setPlayVolume:uid volume:volume];
    NSLog(@"%@ - setPlayVolume uid:%@, volume:%zd, code: %d", kLog, uid, volume, code);
    result([NSNumber numberWithInt:code]);
}

- (void)destroyEngine
{
    NSLog(@"%@ - destroyEngine !!!", kLog);
    [ThunderEngine destroyEngine];
    [self.rendererViews removeAllObjects];
}

#pragma mark - motouch录屏上传文件的配置

- (void)setUploadConfig:(NSDictionary *)params result:(FlutterResult)result
{
    NSString *groupId = [FlutterthunderPlugin stringFromArguments:params key:@"groupId"];
    if (groupId == nil) {
        result(@(-1));
        return;
    }

    NSString *key = [FlutterthunderPlugin stringFromArguments:params key:@"key"];
    if (key == nil) {
        result(@(-1));
        return;
    }
    NSString *value = [FlutterthunderPlugin stringFromArguments:params key:@"value"];
    NSLog(@"%@ - setUploadConfig groupId: %@, key: %@, value: %@", kLog, groupId, key, value);
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:groupId];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
    result(@(0));
}

#pragma mark - 回声、ai 降噪

- (void)setRecordingAudioFrameParameters:(NSDictionary *)params result:(FlutterResult)result
{
    NSInteger sampleRate = [FlutterthunderPlugin intFromArguments:params key:@"sampleRate"];
    NSInteger channel = [FlutterthunderPlugin intFromArguments:params key:@"channel"];
    ThunderAudioRawFrameOperationMode mode = [FlutterthunderPlugin intFromArguments:params key:@"mode"];
    NSInteger samplesPerCall = [FlutterthunderPlugin intFromArguments:params key:@"samplesPerCall"];

    NSInteger code = [self.thunderEngine setRecordingAudioFrameParameters:sampleRate channel:channel mode:mode samplesPerCall:samplesPerCall];
    NSLog(@"%@ - setRecordingAudioFrameParametersWithSampleRate smapleRate:%zd, channel:%zd, mode: %zd, smaplesPerCall:%zd", kLog, sampleRate, channel, mode, samplesPerCall);
    result(@(code));
}

- (void)setPlaybackAudioFrameParameters:(NSDictionary *)params result:(FlutterResult)result
{
     NSInteger sampleRate = [FlutterthunderPlugin intFromArguments:params key:@"sampleRate"];
     NSInteger channel = [FlutterthunderPlugin intFromArguments:params key:@"channel"];
     ThunderAudioRawFrameOperationMode mode = [FlutterthunderPlugin intFromArguments:params key:@"mode"];
     NSInteger samplesPerCall = [FlutterthunderPlugin intFromArguments:params key:@"samplesPerCall"];

     NSInteger code = [self.thunderEngine setPlaybackAudioFrameParameters:sampleRate channel:channel mode:mode samplesPerCall:samplesPerCall];
     NSLog(@"%@ - setPlaybackAudioFrameParametersWithSampleRate smapleRate:%zd, channel:%zd, mode: %zd, smaplesPerCall:%zd", kLog, sampleRate, channel, mode, samplesPerCall);
      result(@(code));
}


#pragma mark - log delegate

- (void)onThunderLogWithLevel:(ThunderLogLevel)level message:(nonnull NSString*)msg
{
    NSLog(@"%@ - logLevel: %d, msg: %@", kLog, level, msg);
}

- (void)onThunderRtcLogWithLevel:(ThunderRtcLogLevel)level message:(NSString *)msg
{
    NSLog(@"%@ - rtcLogLevel: %ld, msg: %@", kLog, (long)level, msg);
}

#pragma mark - ThunderEventDelegate

- (void)thunderEngine:(ThunderEngine *)engine onJoinRoomSuccess:(NSString *)room withUid:(NSString *)uid elapsed:(NSInteger)elapsed
{
    NSLog(@"%@ - onJoinRoomSuccess engin: %@, room: %@  uid: %@", kLog, engine, room, uid);
    [self sendEventWithName:@"onJoinRoomSuccess" params:@{@"roomName":room ? room : @"", @"uid":uid ? uid : @""}];
}

- (void)thunderEngine:(ThunderEngine *)engine onLeaveRoomWithStats:(ThunderRtcRoomStats * _Nonnull)stats
{
    NSLog(@"%@ - onLeaveRoomWithStats engin: %@,  stats: %@", kLog, engine, stats);
    [self sendEventWithName:@"onLeaveRoomWithStats" params:@{}];
    if(self.flutterThunderEventDelegate != nil){
        [self.flutterThunderEventDelegate onLeaveRoom];
    }
}

/*!
 @brief sdk鉴权结果
 @param sdkAuthResult 参见ThunderRtcSdkAuthResult
 */
- (void)thunderEngine:(ThunderEngine * _Nonnull)engine sdkAuthResult:(ThunderRtcSdkAuthResult)sdkAuthResult
{
    NSLog(@"%@ - sdkAuthResult engin: %@,  result: %ld", kLog, engine, (long)sdkAuthResult);
    [self sendEventWithName:@"sdkAuthResult" params:@{@"result":@(sdkAuthResult)}];
}

/*!
 @brief 业务鉴权结果
 @param bizAuthResult 由业务鉴权服务返回，0表示成功；
 */
- (void)thunderEngine:(ThunderEngine * _Nonnull)engine bPublish:(BOOL)bPublish bizAuthResult:(NSInteger)bizAuthResult
{
    NSLog(@"%@ - bizAuthResult engin: %@,  bPublish:%d, result: %ld", kLog, engine,bPublish,(long)bizAuthResult);
    [self sendEventWithName:@"bizAuthResult" params:@{@"bizAuthResult":@(bizAuthResult),
                                                      @"bPublish":[NSNumber numberWithBool:bPublish]}];
}

/*!
 @brief 说话声音音量提示回调
 @param speakers 用户Id-用户音量（未实现，音量=totalVolume）
 @param totalVolume 混音后总音量
 */
- (void)thunderEngine:(ThunderEngine * _Nonnull)engine onPlayVolumeIndication:(NSArray<ThunderRtcAudioVolumeInfo *> * _Nonnull)speakers
      totalVolume:(NSInteger)totalVolume
{
    NSLog(@"%@ - onPlayVolumeIndication engin: %@,  totalVolume:%ld, speakers: %@", kLog, engine, (long)totalVolume, speakers);
    NSMutableArray *inofs = [NSMutableArray new];
    [speakers enumerateObjectsUsingBlock:^(ThunderRtcAudioVolumeInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *map = @{@"uid":obj.uid ? obj.uid :@"", @"volume":@(obj.volume), @"pts":@(obj.pts)};
        [inofs addObject:map];
    }];
    [self sendEventWithName:@"onPlayVolumeIndication" params:@{@"totalVolume":@(totalVolume), @"speakers":inofs.copy}];
}

/*!
 @brief 采集声音音量提示回调
 @param totalVolume 采集总音量（包含麦克风采集和文件播放）
 @param cpt 采集时间戳
 @param micVolume 麦克风采集音量
 @
 */
- (void)thunderEngine:(ThunderEngine * _Nonnull)engine onCaptureVolumeIndication:(NSInteger)totalVolume cpt:(NSUInteger)cpt micVolume:(NSInteger)micVolume
{
    NSLog(@"%@ - onCaptureVolumeIndication engin: %@,  totalVolume:%ld, micVolume: %ld, cpt: %lu", kLog, engine, (long)totalVolume,(long)micVolume, (unsigned long)cpt);
    [self sendEventWithName:@"onCaptureVolumeIndication" params:@{@"totalVolume":@(totalVolume), @"cpt":@(cpt), @"micVolume":@(micVolume)}];
}

/*!
 @brief 音频播放数据回调
 @param uid 用户id
 @param duration 时长
 @param cpt 采集时间戳
 @param pts 播放时间戳
 @data 解码前数据
 */
- (void)thunderEngine:(ThunderEngine * _Nonnull)engine onAudioPlayData:(nonnull NSString*)uid duration:(NSUInteger)duration cpt:(NSUInteger)cpt pts:(NSUInteger)pts data:(nullable NSData*)data
{
//    NSLog(@"%@ - onAudioPlayData engin: %@, uid: %@, cpt: %lu", kLog, engine,uid,(unsigned long)cpt);
}

/*!
 @brief 远端用户音频流停止/开启回调
 @param stopped 停止/开启，YES=停止 NO=开启
 @param uid 远端用户uid
 */
- (void)thunderEngine:(ThunderEngine * _Nonnull)engine onRemoteAudioStopped:(BOOL)stopped byUid:(nonnull NSString*)uid
{
    NSLog(@"%@ - onRemoteAudioStopped engin: %@,  uid: %@", kLog, engine, uid);
    [self sendEventWithName:@"onRemoteAudioStopped" params:@{@"stopped":[NSNumber numberWithBool:stopped], @"uid":uid ? uid : @""}];
}

/*!
 @brief 某个Uid用户的视频流状态变化回调
 @param stopped 流是否已经断开（YES:断开 NO:连接）
 @param uid 对应的uid
 */
- (void)thunderEngine:(ThunderEngine * _Nonnull)engine onRemoteVideoStopped:(BOOL)stopped byUid:(nonnull NSString*)uid
{
    NSLog(@"%@ - onRemoteVideoStopped engin: %@, stopped: %d, uid: %@", kLog, engine, stopped, uid);
    [self sendEventWithName:@"onRemoteVideoStopped" params:@{@"uid":uid ? uid : @"", @"stopped": [NSNumber numberWithBool:stopped]}];
}

/*!
 @brief 已显示远端视频首帧回调
 @param uid 对应的uid
 @param size 视频尺寸(宽和高)
 @param elapsed 从开始请求视频流到发生此事件过去的时间
 */
- (void)thunderEngine:(ThunderEngine *_Nonnull)engine onRemoteVideoPlay:(nonnull NSString *)uid size:(CGSize)size elapsed:(NSInteger)elapsed
{
    NSLog(@"%@ - onRemoteVideoPlay engin: %@,  uid: %@, size: %@", kLog, engine, uid, NSStringFromCGSize(size));
    NSDictionary *params = @{@"uid":uid ? uid : @"", @"height":[NSNumber numberWithFloat:size.height], @"width":[NSNumber numberWithFloat:size.width]};
    [self sendEventWithName:@"onRemoteVideoPlay" params:params];
}

/*!
 @brief 本地或远端视频大小和旋转信息发生改变回调
 @param uid 对应的uid
 @param size 视频尺寸(宽和高)
 @param rotation 旋转信息 (0 到 360)
 */
- (void)thunderEngine:(ThunderEngine *_Nonnull)engine onVideoSizeChangedOfUid:(nonnull NSString*)uid size:(CGSize)size rotation:(NSInteger)rotation
{
    NSLog(@"%@ - onVideoSizeChangedOfUid engin: %@,  uid: %@, size: %@, rotation: %zd", kLog, engine, uid, NSStringFromCGSize(size), rotation);
    NSDictionary *params = @{@"uid":uid ? uid : @"",
                             @"height":[NSNumber numberWithFloat:size.height],
                             @"width":[NSNumber numberWithFloat:size.width],
                             @"rotation":@(rotation)};
    [self sendEventWithName:@"onVideoSizeChangedOfUid" params:params];
}

/*!
 @brief sdk与服务器的网络连接状态回调
 @param status 连接状态，参见ThunderConnectionStatus
 */
- (void)thunderEngine:(ThunderEngine *_Nonnull)engine onConnectionStatus:(ThunderConnectionStatus)status
{
    NSLog(@"%@ - onConnectionStatus engin: %@,  status: %zd", kLog, engine, status);
    [self sendEventWithName:@"onConnectionStatus" params:@{@"status":@(status)}];
}

/*!
 @brief 已发送本地音频首帧的回调
 @param elapsed 从本地用户调用 joinRoom 方法直至该回调被触发的延迟（毫秒）
 */
- (void)thunderEngine:(ThunderEngine *_Nonnull)engine onFirstLocalAudioFrameSent:(NSInteger)elapsed
{
    NSLog(@"%@ - onFirstLocalAudioFrameSent engin: %@", kLog, engine);
    [self sendEventWithName:@"onFirstLocalAudioFrameSent" params:@{}];
}

/*!
 @brief 已发送本地视频首帧的回调
 @param elapsed 从本地用户调用 joinRoom 方法直至该回调被触发的延迟（毫秒）
 */
- (void)thunderEngine:(ThunderEngine *_Nonnull)engine onFirstLocalVideoFrameSent:(NSInteger)elapsed
{
    NSLog(@"%@ - onFirstLocalVideoFrameSent engin: %@", kLog, engine);
    [self sendEventWithName:@"onFirstLocalVideoFrameSent" params:@{}];
}

/*
 @brief 网络类型变化时回调
 @param type
 */
- (void)thunderEngine:(ThunderEngine *_Nonnull)engine onNetworkTypeChanged:(NSInteger)type
{
    NSLog(@"%@ - onNetworkTypeChanged engin: %@, type: %ld", kLog, engine, (long)type);
    [self sendEventWithName:@"onNetworkTypeChanged" params:@{@"type": @(type)}];
}

/*
 @brief 服务器网络连接中断通告，SDK 在调用 joinRoom 后无论是否加入成功，只要 10 秒和服务器无法连接就会触发该回调
 */
- (void)thunderEngineConnectionLost:(ThunderEngine *_Nonnull)engine
{
    NSLog(@"%@ - thunderEngineConnectionLost engin: %@", kLog, engine);
    [self sendEventWithName:@"thunderEngineConnectionLost" params:@{}];
}

/*!
 @brief 鉴权服务即将过期回调
 @param token 即将服务失效的Token
 */
- (void)thunderEngine:(ThunderEngine * _Nonnull)engine onTokenWillExpire:(nonnull NSString*)token
{
    NSLog(@"%@ - onTokenWillExpire engin: %@ , token: %@", kLog, engine, token);
}

/*!
 @brief 鉴权过期回调
 */
- (void)thunderEngineTokenRequest:(ThunderEngine * _Nonnull)engine
{
    NSLog(@"%@ - thunderEngineTokenRequest engin: %@", kLog, engine);
    [self sendEventWithName:@"thunderEngineTokenRequest" params:@{}];
}

/*!
 @brief 远端用户加入回调
 @param uid 远端用户uid
 @param elapsed 加入耗时
 */
- (void)thunderEngine:(ThunderEngine * _Nonnull)engine onUserJoined:(nonnull NSString*)uid elapsed:(NSInteger)elapsed
{
    NSLog(@"%@ - onUserJoined engin: %@, uid: %@", kLog, engine, uid);
    NSDictionary *params = @{@"uid":uid ? uid : @""};
    [self sendEventWithName:@"onUserJoined" params:params];
}

/*!
 @brief 远端用户离开当前房间回调
 @param uid 离线用户uid
 @param reason 离线原因，参见ThunderLiveRtcUserOfflineReason
 */
- (void)thunderEngine:(ThunderEngine * _Nonnull)engine onUserOffline:(nonnull NSString*)uid reason:(ThunderLiveRtcUserOfflineReason)reason
{
    NSLog(@"%@ - onUserOffline engin: %@, uid: %@, reason: %zd", kLog, engine, uid, reason);
    NSDictionary *params = @{@"uid":uid ? uid : @"", @"reason":@(reason)};
    [self sendEventWithName:@"onUserJoined" params:params];
}

/*!
 @brief 网路上下行质量报告回调
 @param uid 表示该回调报告的是持有该id的用户的网络质量，当uid为0时，返回的是本地用户的网络质量
 @param txQuality 该用户的上行网络质量，参见ThunderLiveRtcNetworkQuality
 @param rxQuality 该用户的下行网络质量，参见ThunderLiveRtcNetworkQuality
 */
- (void)thunderEngine:(ThunderEngine * _Nonnull)engine onNetworkQuality:(nonnull NSString*)uid txQuality:(ThunderLiveRtcNetworkQuality)txQuality rxQuality:(ThunderLiveRtcNetworkQuality)rxQuality
{
    NSLog(@"%@ - onNetworkQuality engin: %@, uid: %@, txQuality: %zd, rxQuality: %zd", kLog, engine, uid, rxQuality, txQuality);
    NSDictionary *params = @{@"uid": uid ? uid : @"" , @"rxQuality": @(rxQuality), @"txQuality": @(txQuality)};
    [self sendEventWithName:@"onNetworkQuality" params:params];
}

/*!
@brief 质量问题请求反馈日志
@param description 反馈日志的文字描述
*/
- (void)thunderEngine:(ThunderEngine *)engine onQualityLogFeedback:(NSString *)description
{
    NSLog(@"%@ - onQualityLogFeedback engin: %@, description: %@", kLog, engine, description);
    NSDictionary *params = @{@"description":description ?: @""};
    [self sendEventWithName:@"onQualityLogFeedback" params:params];
}

/**
@brief 音频设备采集状态回调
@param [OUT] status 采集状态
*/
- (void)thunderEngine:(ThunderEngine *)engine onAudioCaptureStatus:(NSInteger)status
{

}



#pragma mark - helper

+ (NSNumber *)numberFromArguments:(NSDictionary *)params key:(NSString *)key
{
    if (![params isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSNumber *value = [params valueForKey:key];
    if (![value isKindOfClass:[NSNumber class]]) {
        return nil;
    } else {
        return value;
    }
}

+ (NSString *)stringFromArguments:(NSDictionary *)params key:(NSString *)key
{
    if (![params isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    NSString *value = [params valueForKey:key];
    if (![value isKindOfClass:[NSString class]]) {
        return nil;
    } else {
        return value;
    }
}

+ (NSInteger)intFromArguments:(NSDictionary *)params key:(NSString *)key
{
    if (![params isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    NSNumber *value = [params valueForKey:key];
    if (![value isKindOfClass:[NSNumber class]]) {
        return 0;
    } else {
        return [value integerValue];
    }
}

+ (BOOL)boolFromArguments:(NSDictionary *)params key:(NSString *)key
{
    if (![params isKindOfClass:[NSDictionary class]]) {
        return NO;
    }

    NSNumber *value = [params valueForKey:key];
    if (![value isKindOfClass:[NSNumber class]]) {
        return NO;
    } else {
        return [value boolValue];
    }
}

+ (NSDictionary *)dictionaryFromArguments:(NSDictionary *)params key:(NSString *)key
{
    if (![params isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    NSDictionary *value = [params valueForKey:key];
    if (![value isKindOfClass:[NSDictionary class]]) {
        return nil;
    } else {
        return value;
    }
}

+ (NSArray *)arrayFromArguments:(NSDictionary *)params key:(NSString *)key
{
    if (![params isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    NSArray *value = [params valueForKey:key];
    if (![value isKindOfClass:[NSArray class]]) {
        return nil;
    } else {
        return value;
    }
}

- (void)sendEventWithName:(NSString *)name params:(NSDictionary *)params
{
    dispatch_sync_on_main_queue(^{
        if (name.length && self.eventSink) {
            self.eventSink(@{@"broadcastName":name, @"broadcastData":params ?: @{}});
        }
    });
}

- (ThunderMultiVideoViewCoordinate *)map2Coordinate:(NSDictionary *)map
{
    if (![map isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    CGFloat scale = UIScreen.mainScreen.scale;
    ThunderMultiVideoViewCoordinate *coordinate = [ThunderMultiVideoViewCoordinate new];
    coordinate.height = [[FlutterthunderPlugin numberFromArguments:map key:@"height"] intValue] * scale;
    coordinate.width = [[FlutterthunderPlugin numberFromArguments:map key:@"width"] intValue] * scale;
    coordinate.index = [[FlutterthunderPlugin numberFromArguments:map key:@"index"] intValue];
    NSLog(@"%@ - map2Coordinate: index=%d, width = %d, height=%d, x=%d, y=%d", kLog,coordinate.index, coordinate.width, coordinate.height, coordinate.x, coordinate.y);
    coordinate.x = [[FlutterthunderPlugin numberFromArguments:map key:@"x"] intValue] * scale;
    coordinate.y = [[FlutterthunderPlugin numberFromArguments:map key:@"y"] intValue] * scale;
    return coordinate;
}


#pragma mark - Flutter Stream Handler

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events
{
    if ([arguments isKindOfClass:NSString.class] && [kEventChannel isEqualToString:arguments]) {
        self.eventSink = events;
        return nil;
    }
    return [FlutterError errorWithCode:@"-1" message:[NSString stringWithFormat:@"%@ unable to handle listen event for %@",kEventChannel, arguments] details:nil];
}

- (FlutterError *)onCancelWithArguments:(id)arguments
{
    if ([arguments isKindOfClass:NSString.class] && [kEventChannel isEqualToString:arguments]) {
        self.eventSink = nil;
    }
    return nil;
}

- (ThunderVideoCaptureFrameDataType)needThunderVideoCaptureFrameDataType {
    FlutterThunderVideoCaptureFrameDataType type = [self.flutterThunderVideoCaptureFrameObserver needThunderVideoCaptureFrameDataType];
    if(type == THUNDER_VIDEO_CAPTURE_DATATYPE_PIXELBUFFER){
        return THUNDER_VIDEO_CAPTURE_DATATYPE_PIXELBUFFER;
    }else{
        return THUNDER_VIDEO_CAPTURE_DATATYPE_TEXTURE;
    }
}

- (CVPixelBufferRef _Nullable)onVideoCaptureFrame:(EAGLContext * _Nonnull)glContext PixelBuffer:(CVPixelBufferRef _Nonnull)pixelBuf {
    if(self.flutterThunderVideoCaptureFrameObserver != nil){
        return [self.flutterThunderVideoCaptureFrameObserver onVideoCaptureFrame:glContext PixelBuffer:pixelBuf];
    }
    return nil;
}

- (BOOL)onVideoCaptureFrame:(EAGLContext * _Nonnull)context PixelBuffer:(CVPixelBufferRef _Nonnull)pixelBuffer SourceTextureID:(unsigned int)srcTextureID DestinationTextureID:(unsigned int)dstTextureID TextureFormat:(int)textureFormat TextureTarget:(int)textureTarget TextureWidth:(int)width TextureHeight:(int)height {
    if(self.flutterThunderVideoCaptureFrameObserver != nil){
        return [self.flutterThunderVideoCaptureFrameObserver onVideoCaptureFrame:context PixelBuffer:pixelBuffer SourceTextureID:srcTextureID DestinationTextureID:dstTextureID TextureFormat:textureFormat TextureTarget:textureTarget TextureWidth:width TextureHeight:height];
    }
    return false;
}

- (void)onVideoDecodeFrame:(CVPixelBufferRef _Nonnull)pixelBuf pts:(uint64_t)pts uid:(NSString * _Nonnull)uid {
    if(self.flutterThunderVideoDecodeFrameObserver != nil){
        [self.flutterThunderVideoDecodeFrameObserver onVideoDecodeFrame:pixelBuf pts:pts uid:uid];
    }
}

@end

@implementation ThunderRenderViewFactory

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args
{
    NSLog(@"%@ - create renderView: viewId=%lld, args: %@", kLog,viewId, args);
    ThunderRenderView *rendererView = [[ThunderRenderView alloc] initWithFrame:frame viewIdentifier:viewId];
    [FlutterthunderPlugin addView:rendererView.view viewId:@(viewId)];
    return rendererView;
}

@end
