// 版块广告

#import <UIKit/UIKit.h>
#import "NJCommonDefine.h"

%group App

// 首页搜索框的关键字
@interface BAPIAppInterfaceV1DefaultWordsReply : NSObject

/// 显示的字
@property (copy, nonatomic) NSString *show;
// 关键字
@property (copy, nonatomic) NSString *word;

@end

%hook BAPIAppInterfaceV1DefaultWordsReply

- (id)initWithData:(id)data extensionRegistry:(id)registry error:(id *)error {
    BAPIAppInterfaceV1DefaultWordsReply *ret = %orig;
    ret.show = @"";
    ret.word = @"";
    return ret;
}

%end

%end

// ---- 底部栏隐藏：加号 / 会员购（UI 层兜底，独立于网络拦截）----
// 网络拦截（NJTabDataBottomHandler）在某些 B 站版本/构建下不生效，
// 这里直接在 UITabBar 上兜底，保证加号与会员购不会出现在主界面。
%hook UITabBar
- (void)setItems:(NSArray<UITabBarItem *> *)items animated:(BOOL)animated {
    if (!items) {
        %orig(nil, animated);
        return;
    }
    NSMutableArray<UITabBarItem *> *filtered = [NSMutableArray arrayWithCapacity:items.count];
    for (UITabBarItem *item in items) {
        NSString *t = item.title;
        // 会员购是 tabBar.items 里的一个 UITabBarItem，按标题过滤
        if (t && [t rangeOfString:@"会员购"].location != NSNotFound) {
            continue;
        }
        [filtered addObject:item];
    }
    %orig(filtered, animated);
}

- (void)layoutSubviews {
    %orig;
    // 加号(publish) 通常是 tabBar 上直接添加的 UIButton（非标准 tab 按钮）。
    // 隐藏所有非标准 tab 按钮的 UIButton（即中间的发布按钮）。
    Class tabBtn = NSClassFromString(@"UITabBarButton");
    for (UIView *sub in self.subviews) {
        if ([sub isKindOfClass:[UIButton class]] && (!tabBtn || ![sub isKindOfClass:tabBtn])) {
            sub.hidden = YES;
        }
    }
}
%end

// 加号(publish)：B 站真实类 BBTabBar 的 publishButton（类不存在则自动跳过，不会崩溃）
%hook BBTabBar
- (void)setPublishButton:(id)button {
    return; // 不把发布按钮加入 tabBar
}
- (id)publishButton {
    return nil;
}
%end

%ctor {
    if (NJ_MASTER_SWITCH_VALUE) {
        %init(App);
    }
}
