//
//  PPEmotionAttachment.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/26.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPEmotionAttachment.h"
#import "PPEmotionModel.h"
@implementation PPEmotionAttachment

- (instancetype)init
{
    if (self = [super init]) {
        
        // init

        
    }
    return self;
}

- (void)setEmotion:(PPEmotionModel *)emotion
{
    _emotion = emotion;
    
    // 赋值
    self.image = [UIImage imageNamed:emotion.png];
}

//- (void)setSize:(CGSize)size
//{
//    _size = size;
//    
//    //
//    self.bounds = (CGRect){CGPointZero, size};
//}
@end
