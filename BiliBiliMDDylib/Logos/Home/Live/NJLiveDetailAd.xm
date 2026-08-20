// 主页-直播详情页广告

#import <UIKit/UIKit.h>
#import "NJCommonDefine.h"

%group App

// 收入面板，包含礼物面板
%hook BBLiveRevenueCardsContentView

- (id)initWithDataSource:(id)source viewModel:(id)model {
    return nil;
}

%end

// 预约
// 预约按钮
%hook BBLiveBaseAppointmentEntryView

- (id)initWithFrame:(CGRect)frame {
    return nil;
}

%end

// 预约弹窗
@interface BBLiveBaseAppointmentCardView : NSObject

@end

%hook BBLiveBaseAppointmentCardView

- (id)initWithEntryFrame:(CGRect)frame {
    return nil;
}

%end



// 人气榜
%hook BBLiveBasePopularHotRankEntryView

- (id)initWithFrame:(CGRect)frame {
    return nil;
}

%end


// 人气榜
%hook BBLiveBasePopularRankEntryView

- (id)initWithFrame:(CGRect)frame {
    return nil;
}

%end

%hook BBLiveVerticalPanelViewController

- (id)popularRankEntryViews {
    return nil;
}

%end

// 分区排行，比如娱乐新人
%hook BBLiveBaseAreaRankEntryView

- (id)initWithFrame:(CGRect)frame {
    return nil;
}

%end

%hook BBLiveBaseMixedRankEntryView

- (id)initWithFrame:(CGRect)frame {
    return nil;
}

%end

// 右下角活动，比如LOL投稿有奖
%hook BBLiveChainView

- (id)initWithFrame:(CGRect)frame {
    return nil;
}


%end

// 弹幕下面的功能卡，比如游戏赛程卡
%hook BBLiveFunctionCardTaskManager

- (id)init {
    return nil;
}

%end

// 弹幕下面的购物说明卡，比如热门抢购卡
%hook BBLiveShoppingExplainCardViewModel

- (id)initWithDataSource:(id)source tracker:(id)tracker {
    return nil;
}

%end

//  顶部吊坠，比如LOL观赛福利入口、红包、心愿单
@interface BBLiveVerticalCenterBar : NSObject

@property (retain, nonatomic) UIView *topPendantContainerView;

@end

%hook BBLiveVerticalCenterBar

// 顶部吊坠
- (void)layoutTopPendantContainerView {
    [self.topPendantContainerView removeFromSuperview];
    self.topPendantContainerView = nil;
}

// 弹幕下面的购物推荐卡
- (void)_showShoppingRecommendViewWithInfo:(id)info completion:(id)completion {
}

%end


// 礼物动画
// BBLiveBaseMP4AnimationView
// BBLiveBaseSpineAnimationView
// BBLiveBaseSVGAAnimationView
%hook BBLiveBaseAnimationView

- (id)initWithFrame:(CGRect)frame {
    return nil;
}

%end

// 关注弹窗
%hook BBLiveFollowCardAlertComponent

- (id)initWithDataSource:(id)source {
    return nil;
}

%end

%hook BBLiveFullScreenFloatPanelView

// 修复8.76.0奔溃
- (void)registerComponent:(id)component {
    if (!component) {
        return;
    }
    %orig;
}

%end

// [已移除] 原先这里有一段针对 LynxView 的 hook 块，把 LynxView 的所有 init
// (initWithCoder: / init / initWithFrame: / initWithBuilderBlock: / initWithoutRender)
// 一律 return nil，用来干掉「热门榜、人气榜」。
//
// 问题：直播间右上角的「人气值 / 在线人数」同样由 Lynx 渲染，被这一刀切一起干掉了，
// 导致进入直播间后右上角人数不显示。
//
// 现状：热门榜 / 人气榜入口的移除已由上方这几个具体类的 hook 负责，删掉 LynxView
// 一刀切不会让榜单回来：
//   - BBLiveBasePopularHotRankEntryView  initWithFrame: -> nil
//   - BBLiveBasePopularRankEntryView     initWithFrame: -> nil
//   - BBLiveVerticalPanelViewController  popularRankEntryViews -> nil
//   - BBLiveBaseAreaRankEntryView / BBLiveBaseMixedRankEntryView  initWithFrame: -> nil
//
// 后续维护提醒：若某个新版本把人气榜改成纯 Lynx 渲染、导致上面的具体类 hook 失效，
// 请用 Lookin / Reveal 定位人气榜对应的具体容器类或 Lynx 模板名单独 hook，
// 不要再退回「hook 所有 LynxView」这种一刀切做法，否则会再次误伤人气值。

// [已移除 v3.1.4] BBLiveTopRightEntranceManager 的 init -> nil hook。
// 该管理器负责创建直播间「右上角」整块 UI（含 人气值/在线人数 的原生组件
// BBLiveScrollNumberView / BBLiveRoomPopularityInfo），init 返回 nil 会把
// 人数一起干掉。移除后右上角人数恢复显示；代价是「观赛活动、更多直播入口」
// 这类右上角广告入口也会回来。若后续要单独去掉这些入口，用 Lookin/Reveal
// 定位具体入口组件类，不要用 manager 一刀切。

// [已移除 v3.1.5] BBLivePoliticalFullScreenTopBar / BBLiveVerticalTopBar 的
// layoutSubviews remove userRankListEntryView + _updateUserRankListEntryViewIfNeed
// 这两个 hook。注释里说 userRankListEntryView 是「用户排名列表」，但在
// B 站 8.89.0 该位置实际显示的是「人气值/在线人数」（即直播间顶部 bar
// 关注按钮右侧的「489」类数字），hook 直接把它从视图树里 removeFromSuperview
// 并阻止重建，导致右上角人数不显示。移除后人气值恢复。热门榜/人气榜
// 是 Lynx 渲染的（具体类 hook 拦不住），不受这两个 hook 控制；若要保留
// 顶部 rank 入口但不要误伤人数，需用 Lookin/Reveal 定位 8.89.0 中实际
// 承载「排名入口」的具体子视图类，单独 hook 那个子视图。

// 直播详情-弹幕底部的功能卡
%hook BBLChronFunctionCard

- (id)initWithStore:(id)store {
    return nil;
}

- (id)init {
    return nil;
}

%end

%end

%ctor {
    if (NJ_MASTER_SWITCH_VALUE) {
        %init(App);
    }
}


