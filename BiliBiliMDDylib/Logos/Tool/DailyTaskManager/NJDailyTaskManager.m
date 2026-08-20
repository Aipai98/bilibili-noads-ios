//
//  NJDailyTaskManager.m
//  BiliBiliMDDylib
//
//  Created by touchWorld on 2026/3/7.
//

#import "NJDailyTaskManager.h"

@interface NJDailyTaskManager ()

@property (nonatomic, strong) NSUserDefaults *cache;

@end

@implementation NJDailyTaskManager

+ (instancetype)shared {
    static NJDailyTaskManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NJDailyTaskManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // [修复 v3.1.6] 原用 NSClassFromString(@"YYCache")，工程未编译 YYCache 实现，
        // 运行时拿到 nil -> 每日任务（自动领福利等）全部失效。改用 NSUserDefaults。
        _cache = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

#pragma mark - Public

/// 是否可以执行每日任务
- (BOOL)canRunTask:(NSString *)taskKey {

    NSTimeInterval todayStart = [self todayStartTimestamp];

    NSNumber *savedTime = (NSNumber *)[self.cache objectForKey:taskKey];

    if (!savedTime) {
        return YES;
    }

    return savedTime.doubleValue != todayStart;
}

/// 标记任务完成
- (void)markTaskDone:(NSString *)taskKey {
    NSTimeInterval todayStart = [self todayStartTimestamp];

    [self.cache setObject:@(todayStart) forKey:taskKey];
}

/// 重置任务
- (void)resetTask:(NSString *)taskKey {
    [self.cache removeObjectForKey:taskKey];
}

#pragma mark - Private

/// 获取当天0点时间戳
- (NSTimeInterval)todayStartTimestamp {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDate *startDate;
    [calendar rangeOfUnit:NSCalendarUnitDay
                startDate:&startDate
                 interval:NULL
                  forDate:now];

    return [startDate timeIntervalSince1970];
}

@end
