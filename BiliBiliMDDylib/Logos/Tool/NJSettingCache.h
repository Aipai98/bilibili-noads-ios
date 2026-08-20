//
//  NJSettingCache.h
//  BiliBiliTweak
//
//  Created by touchWorld on 2026/1/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// [修复 v3.1.6] 原实现依赖 YYCache，但工程里只有 YYCache.h 头文件、.m 实现
/// 从未被编进 dylib（pbxproj 无引用、磁盘上也无 .m），NSClassFromString(@"YYCache")
/// 返回 nil，导致 self.cache = nil，所有设置读写全部空转、功能失效。
/// 现改用系统自带且必然可用的 NSUserDefaults，设置持久化行为不变。
@interface NSUserDefaults (NJSettingCache)

/// 判断是否包含某个 key（兼容 NJ_SETTING_CACHE 宏里的 containsObjectForKey:）
- (BOOL)containsObjectForKey:(NSString *)key;

@end

@interface NJSettingCache : NSObject

/// 设置缓存（NSUserDefaults 持久化）
@property (nonatomic, strong) NSUserDefaults *cache;

/// 单例
+ (instancetype)sharedInstance;

/// 获取默认播放速度
- (NSString *)defaultPlaybackRate;

/// 获取默认播放速度
- (double)defaultPlaybackRateValue;

/// 保存默认播放速度
- (void)saveDefaultPlaybackRate:(NSString *)rate;

/// 关注的默认版块
- (NSString *)followDefaultTab;

/// 保存关注的默认版块
- (void)saveFollowDefaultTab:(NSString *)tab;

@end

NS_ASSUME_NONNULL_END
