//
//  StoreView.m
//  BGProject
//
//  Created by zhuozhong on 14-10-10.
//  Copyright (c) 2014年 zhuozhong. All rights reserved.
//

#import "StoreView.h"
#import "EGOImageView.h"
#import "ChuChuangModel.h"


#define kupViewHeight 0.6
#define kGoodReviewFont     [UIFont systemFontOfSize:15]

#define kStoreTitleFont   [UIFont systemFontOfSize:14]
@implementation StoreView
{
    //两个背景view
    UIImageView* _upperBgView; // 高度占了3/5
    UIImageView* _lowerBgView;
    
    EGOImageView* _storeIconView;//商店头像
    UILabel*    _storeTitleLable;//商店名称
    UILabel*    _goodReviewLable;//好评
    
    UIImageView*    _levelLable;//信用值或等级
    
    UIButton* _recomProductBtn; //显示推荐
    UIButton* _allProductBtn;//显示所有商品
    
    UIButton* selectedButton;
    
    
}


-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        //开启交互
        self.userInteractionEnabled = YES;
        
        //创建背景View，干啥呢？
        CGFloat viewHeight = frame.size.height;
        CGFloat viewWidth = frame.size.width;
        CGFloat upH = viewHeight* kupViewHeight;
        _upperBgView = [[UIImageView alloc]initWithFrame:(CGRect){{0,0},{viewWidth,upH}}];
        
        //下面那块？
        CGFloat lowY = upH;
        CGFloat lowH = viewHeight - lowY;
        _lowerBgView = [[UIImageView alloc]initWithFrame:(CGRect){{0,lowY},{viewWidth,lowH}}];
        _lowerBgView.userInteractionEnabled = YES;
        [self addSubview:_upperBgView];
        [self addSubview:_lowerBgView];
        
        //下面那个view被分成三部分
        CGFloat squareWidth = _lowerBgView.bounds.size.width*0.33;
        
        //用户头像
        CGSize iconSize = CGSizeMake(70, 70);
        CGFloat iconY = _upperBgView.frame.size.height-iconSize.height*0.5;
        CGFloat iconX = (squareWidth - iconSize.width)*0.5;
        _storeIconView = [[EGOImageView alloc]initWithFrame:(CGRect){{iconX,iconY},iconSize}];
        [self addSubview:_storeIconView];
        
        //设置橱窗，为啥没名字呢？
        _storeTitleLable = [[UILabel alloc]init];
        [_storeTitleLable setFont:kStoreTitleFont];
        [self addSubview:_storeTitleLable];
        
        //好评？
        _goodReviewLable = [[UILabel alloc]init];
        [_goodReviewLable setFont:kGoodReviewFont];
        [self addSubview:_goodReviewLable];
        
        //等级
        _levelLable = [[UIImageView alloc]init];
        [self addSubview:_levelLable];
        
        //推荐产品按钮
        CGFloat recomX = squareWidth*1;
        CGFloat recomY = 0;
        CGSize recomSize = CGSizeMake(squareWidth, _lowerBgView.bounds.size.height);
        _recomProductBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recomProductBtn.adjustsImageWhenHighlighted = NO;
        [_recomProductBtn setFrame:(CGRect ){{recomX,recomY},recomSize}];
        [_recomProductBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_recomProductBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_recomProductBtn setFont:[UIFont systemFontOfSize:14]];
        //一开始就选中
        _recomProductBtn.selected = YES;
        //记录选中的按钮
        selectedButton = _recomProductBtn;
        [_recomProductBtn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_lowerBgView addSubview:_recomProductBtn];
        
        [self onBtnClick:_recomProductBtn];

        //所有产品按钮
        CGFloat allProducX = squareWidth*2;
        CGFloat allProducY = 0;
        CGSize allProducSize = CGSizeMake(squareWidth, _lowerBgView.bounds.size.height);
        _allProductBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allProductBtn.userInteractionEnabled = YES;
        [_allProductBtn setFrame:(CGRect ){{allProducX,allProducY},allProducSize}];
        [_allProductBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_allProductBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_allProductBtn setFont:[UIFont systemFontOfSize:14]];
                [_allProductBtn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_lowerBgView addSubview:_allProductBtn];
        
        
        //两条分割线
        UIImage* rawImg = [UIImage imageNamed:@"separator_h.png"];//size:10, 1
        CGFloat rawImgHeight = [rawImg size].height;
        UIImageView* separatorView1 = [[UIImageView alloc]initWithFrame:CGRectMake(squareWidth, 0, 1, lowH)];
        UIImageView* separatorView2 = [[UIImageView alloc]initWithFrame:CGRectMake(squareWidth*2, 0, 1, lowH)];
        
        UIImage* resizeImg = [rawImg resizableImageWithCapInsets:UIEdgeInsetsMake(rawImgHeight*0.5-1, 0,rawImgHeight*0.5, 0)
                                                    resizingMode:UIImageResizingModeStretch];
        [separatorView1 setImage:resizeImg];
        [separatorView2 setImage:resizeImg];
        [_lowerBgView addSubview:separatorView1];
        [_lowerBgView addSubview:separatorView2];
        
        

    }
    return self;
}

//设置上下两块的背景颜色
-(void)setSytle:(UIColor *)color
{
    [_upperBgView setBackgroundColor:color];
    [_lowerBgView setBackgroundColor:[UIColor colorWithRed:250/255.0
                                                     green:250/255.0
                                                      blue:250/255.0
                                                     alpha:1]];
    
    
}

//通过模型为子控件设置数据
-(void)showInfo:(ChuChuangModel*)model
{
    //商店头像
    [_storeIconView setImageURL:[NSURL URLWithString:model.logo]];
    
    //取出产品数组
    int count = [model.recommend_list count];
    
    //设置产品推荐按钮的标题
    NSString* title = [NSString stringWithFormat:@"产品推荐(%d)",count];
    [_recomProductBtn setTitle:title forState:UIControlStateNormal];
   
    //取出所有产品的数量
    count = [model.product_count integerValue];
    
    //设置所有产品按钮的标题
    title = [NSString stringWithFormat:@"所有产品(%d)",count];
    [_allProductBtn setTitle:title forState:UIControlStateNormal];
    
    //商店名字
    CGSize titleSize = [model.shop_name sizeWithFont:kStoreTitleFont forWidth:180 lineBreakMode:NSLineBreakByTruncatingTail];
    CGFloat titleX =CGRectGetMaxX(_storeIconView.frame)+5;
    CGFloat titleY =_storeIconView.frame.origin.y + 7;
    [_storeTitleLable setFrame:(CGRect){{titleX,titleY}, titleSize}];
    [_storeTitleLable setText:model.shop_name];
    
    
//    [_goodReviewLable setText:model.credit];

}


-(void)onBtnClick:(UIButton*)sender
{
    selectedButton.selected = NO;
    selectedButton = sender;
    selectedButton.selected = YES;
    
    if([_delegate respondsToSelector:@selector(storeView:buttonClick:)])
    {
        [_delegate storeView:self buttonClick:sender];
    }
}

//设置按钮的状态
-(void)removeAllButtonSelectedState
{
    //改变选中按钮的状态为不选中
    selectedButton.selected = NO;
    
}

@end
