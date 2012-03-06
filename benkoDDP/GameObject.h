//
//  GameObject.h
//  benkoDDP
//
//  Created by kwan terry on 11-8-5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameObject : CCSprite {
    int type;   //元素的类型
    int prop_type;
    BOOL hasprop;
    BOOL hasadd;
    CGPoint destination;    //元素的目标位置
    BOOL scale;         //元素是否放缩
    int scaleTimes;     //元素放缩的倍数
    BOOL objectMoving;      //元素是否在移动
    int frameCount;     //帧率记数器
    BOOL isfading;     //是否正在被消除
}

@property (readwrite)int type;
@property (readwrite)int prop_type;
@property (readwrite)BOOL hasprop;
@property (readwrite)BOOL hasadd;
@property (readwrite)CGPoint destination;
@property (readwrite)BOOL scale;
@property (readwrite)int scaleTimes;
@property (readwrite)BOOL objectMoving;
@property (readwrite)int frameCount;
@property (readwrite)BOOL isfading;

-(id) initObjectWithType:(int)objectType;
- (void) settingDes:(CGPoint) xy;
- (int) gettingType;
- (CGPoint) gettingDes;
- (BOOL) playingAnimation;
- (BOOL) gettingFading;
- (void) settingFading:(BOOL)b;
@end
