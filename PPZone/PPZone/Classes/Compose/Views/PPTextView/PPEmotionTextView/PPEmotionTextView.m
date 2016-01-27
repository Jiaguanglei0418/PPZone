//
//  PPEmotionTextView.m
//  PPZone
//
//  Created by jiaguanglei on 16/1/25.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import "PPEmotionTextView.h"
#import "PPEmotionModel.h"
#import "NSString+Extention.h" // 显示emoj
#import "UITextView+Extention.h" // 增加inserAttributeText方法

#import "PPEmotionAttachment.h" // 自定义attachment
@implementation PPEmotionTextView

- (void)insertEmotion:(PPEmotionModel *)emotion
{
    if (emotion.code) {// insertText emoj
        [self insertText:emotion.code.emoji];
        
    }else if (emotion.png){ // 插入图片
        // 拼接图片
        PPEmotionAttachment *attach = [[PPEmotionAttachment alloc] init];
        attach.emotion = emotion;

        // 设置图片尺寸
        CGFloat attachW = self.font.lineHeight;
        attach.bounds = CGRectMake(0, -4, attachW, attachW);
        
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attach];
        
        // 分类方法 - 插入图片文本
        [self insertAttributedText:imageStr settingBlock:^(NSMutableAttributedString *attributedText) {
            // 设置字号
            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        }];
    }
}

/**
 *  selectedRange
 *  1. 本来是用来控制textView的文字选中范围;
 2. 如果selectedRange.length 为 0, selectedRange.location就是光标位置;
 *
 *  textView文字的字体
 *  1. 如果是普通文字(text), 文字大小有textView.font控制;
 *  2. 如果是属性文字(attributeText), 文字大小不受textView.font, 应该用 addAttribute: Value: range: 来设置
 */

- (NSString *)fullText
{
    WS(weakSelf);
    NSMutableString *fullText = [NSMutableString string];
    
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
    
        // 判断
        PPEmotionAttachment *attach = attrs[@"NSAttachment"];
        if (attach) { // 图片表情
//            LogGreen(@"%@", attach.emotion.chs);
            [fullText appendString:attach.emotion.chs];
        }else { // 普通字符串, emoj
            // 获得这个范围内的文字
            NSAttributedString *str = [weakSelf.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    

    return fullText;
}
@end
