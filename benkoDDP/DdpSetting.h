//
//  DdpSetting.h
//  benkoDDP
//
//  Created by kwan terry on 11-8-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DdpData.h"
@interface DdpSetting : CCLayer {
    UITextField *myTextField;
    //音量调节的拖动条
    UISlider * musicVolumn;
    UISlider * effectVolumn;
    //数据
    NSData *jsonData;
    NSDictionary *jsonDict;
    
    //sqlite数据库数据
    DdpData *sqldata;
    
    //一些提示的标签
    CCLabelTTF * tips;
}

@property (retain) UITextField * myTextField;
@property (retain) UISlider *musicVolumn;
@property (retain) UISlider *effectVolumn;
@property (retain) NSData * jsonData;
@property (retain) NSDictionary *jsonDict;
+(CCScene *) scene;

- (void) changeMusicVol:(id) sender;
-(void) changeEffectVol:(id) sender;
//各种数据库操作的函数
-(void) nextAction;
-(void) deleteAction;
-(void) updateAction;
@end
