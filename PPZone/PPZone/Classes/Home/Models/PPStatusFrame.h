//
//  PPStatusFrame.h
//  黑马微博2期
//
//  Created by apple on 14-10-14.
//  Copyright (c) 2014年 heima. All rights reserved.
//  一个PPStatusFrame模型里面包含的信息
//  1.存放着一个cell内部所有子控件的frame数据
//  2.存放一个cell的高度
//  3.存放着一个数据模型PPStatus

#import <Foundation/Foundation.h>

// 昵称字体
#define PPStatusCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define PPStatusCellTimeFont [UIFont systemFontOfSize:12]
// 来源字体
#define PPStatusCellSourceFont PPStatusCellTimeFont
// 正文字体
#define PPStatusCellContentFont [UIFont systemFontOfSize:14]

// 被转发微博的正文字体
#define PPStatusCellRetweetContentFont [UIFont systemFontOfSize:13]

// cell之间的间距
#define PPStatusCellMargin 15

// cell的边框宽度
#define PPStatusCellBorderW 10

@class PPStatus;

@interface PPStatusFrame : NSObject
@property (nonatomic, strong) PPStatus *status;

/** 原创微博整体 */
@property (nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 会员图标 */
@property (nonatomic, assign) CGRect vipViewF;
/** 配图 */
@property (nonatomic, assign) CGRect photoViewF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 来源 */
@property (nonatomic, assign) CGRect sourceLabelF;
/** 正文 */
@property (nonatomic, assign) CGRect contentLabelF;

/** 转发微博整体 */
@property (nonatomic, assign) CGRect retweetViewF;
/** 转发微博正文 + 昵称 */
@property (nonatomic, assign) CGRect retweetContentLabelF;
/** 转发配图 */
@property (nonatomic, assign) CGRect retweetPhotoViewF;

/** 底部工具条 */
@property (nonatomic, assign) CGRect toolbarF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@end
