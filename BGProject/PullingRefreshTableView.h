//
//  PullingRefreshTableView.h
//  BGProject
//
//  Created by zhuozhong on 14-7-31.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kPRStateNormal = 0,
    kPRStatePulling = 1,
    kPRStateLoading = 2,
    kPRStateHitTheEnd = 3
} PRState;

@interface LoadingView : UIView {
    UILabel *_stateLabel;
    UILabel *_dateLabel;
    UIImageView *_arrowView;
    UIActivityIndicatorView *_activityView;
    CALayer *_arrow;
    BOOL _loading;
}
@property (nonatomic,getter = isLoading) BOOL loading;
@property (nonatomic,getter = isAtTop) BOOL atTop;
@property (nonatomic) PRState state;

- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top;

- (void)updateRefreshDate:(NSDate *)date;

@end

@protocol PullingRefreshTableViewDelegate;

@interface PullingRefreshTableView : UITableView <UIScrollViewDelegate>{
    LoadingView *_headerView;
    LoadingView *_footerView;
    UILabel *_msgLabel;
    BOOL _loading;
    BOOL _isFooterInAction;
    NSInteger _bottomRow;
}
@property (assign,nonatomic) id <PullingRefreshTableViewDelegate> pullingDelegate;
@property (nonatomic) BOOL autoScrollToNextPage;
@property (nonatomic) BOOL reachedTheEnd;
@property (nonatomic,getter = isHeaderOnly) BOOL headerOnly;

- (id)initWithFrame:(CGRect)frame pullingDelegate:(id<PullingRefreshTableViewDelegate>)aPullingDelegate;

- (void)tableViewDidScroll:(UIScrollView *)scrollView;

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView;

- (void)tableViewDidFinishedLoading;

- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg;

- (void)launchRefreshing;

@end



@protocol PullingRefreshTableViewDelegate <NSObject>

@required
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView;

@optional
//Implement this method if headerOnly is false
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView;
//Implement the follows to set date you want,Or Ignore them to use current date
- (NSDate *)pullingTableViewRefreshingFinishedDate;
- (NSDate *)pullingTableViewLoadingFinishedDate;
@end
