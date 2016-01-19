//
//  PPEmotionModel.h
//  PPZone
//
//  Created by jiaguanglei on 16/1/19.
//  Copyright © 2016年 roseonly. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  <key>chs</key>
 <string>[笑哈哈]</string>
 <key>cht</key>
 <string>[笑哈哈]</string>
 <key>gif</key>
 <string>lxh_xiaohaha.gif</string>
 <key>png</key>
 <string>lxh_xiaohaha.png</string>
 */
@interface PPEmotionModel : NSObject
// 文字描述
PROPERTYCOPY(NSString, chs)
// 图片名称
PROPERTYCOPY(NSString, png)
// emoj - 编码
PROPERTYCOPY(NSString, code)
@end
