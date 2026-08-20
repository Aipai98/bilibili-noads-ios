//
//  NJSettingCache.m
//  BiliBiliTweak
//
//  Created by touchWorld on 2026/1/17.
//

#import "NJSettingCache.h"

/// 默认播放速度
#define NJ_SETTING_DEFAULT_PLAYBACK_RATE_KEY @"SETTING_DEFAULT_PLAYBACK_RATE"
#define NJ_SETTING_DEFAULT_PLAYBACK_RATE_VALUE @"1.0"
/// 关注的默认版块
#define NJ_SETTING_FOLLOW_DEFAULT_TAB_KEY @"SETTING_FOLLOW_DEFAULT_TAB"
#define NJ_SETTING_FOLLOW_DEFAULT_TAB_VALUE @"all"

@implementation NJSettingCache

#pragma mark - Life Cycle Methods

+ (instancetype)sharedInstance {
    static NJSettingCache *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NJSettingCache alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self doInit];
    }
    return self;
}



#pragma mark - Do Init

- (void)doInit {
    // [修复 v3.1.6] 原来这里用 NSClassFromString(@"YYCache") 建 YYCache，
    // 但工程从未编译 YYCache 实现（只有头文件），运行时拿到 nil -> 设置全失效。
    // 改用系统自带的 NSUserDefaults（持久化、必然可用）。
    self.cache = [NSUserDefaults standardUserDefaults];
}


#pragma mark - Override Methods

#pragma mark - Public Methods

#pragma mark 默认播放速度

/// 获取默认播放速度
- (NSString *)defaultPlaybackRate {
    NSString *rate = (NSString *)[self.cache objectForKey:NJ_SETTING_DEFAULT_PLAYBACK_RATE_KEY];
    // 使用默认值
    if (rate.length == 0) {
        rate = NJ_SETTING_DEFAULT_PLAYBACK_RATE_VALUE;
        // 保存
        [self.cache setObject:rate forKey:NJ_SETTING_DEFAULT_PLAYBACK_RATE_KEY];
    }
    return rate;
}

/// 获取默认播放速度
- (double)defaultPlaybackRateValue {
    return [[self defaultPlaybackRate] doubleValue];
}

/// 保存默认播放速度
- (void)saveDefaultPlaybackRate:(NSString *)rate {
    [self.cache setObject:rate
                   forKey:NJ_SETTING_DEFAULT_PLAYBACK_RATE_KEY];
}

#pragma mark 关注的默认版块

/// 关注的默认版块
- (NSString *)followDefaultTab {
    NSString *tab = (NSString *)[self.cache objectForKey:NJ_SETTING_FOLLOW_DEFAULT_TAB_KEY];
    // 使用默认值
    if (tab.length == 0) {
        tab = NJ_SETTING_FOLLOW_DEFAULT_TAB_VALUE;
        // 保存
        [self.cache setObject:tab forKey:NJ_SETTING_FOLLOW_DEFAULT_TAB_KEY];
    }
    return tab;
}

/// 保存关注的默认版块
- (void)saveFollowDefaultTab:(NSString *)tab {
    [self.cache setObject:tab
                   forKey:NJ_SETTING_FOLLOW_DEFAULT_TAB_KEY];
}

#pragma mark - Private Methods

#pragma mark - Property Methods
@end

@implementation NSUserDefaults (NJSettingCache)

- (BOOL)containsObjectForKey:(NSString *)key {
    return [self objectForKey:key] != nil;
}

@end
