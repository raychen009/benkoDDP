//
//  DdpMenu.h
//  benkoDDP
//
//  Created by kwan terry on 11-8-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DdpData.h"
@interface DdpMenu : CCLayer {
    //数据库
    DdpData *sqldata;
    NSString *name;
    int score;
    CCLabelTTF * tips2;
    CCLabelTTF * tips1; 
    CCLabelTTF * nameDiscription;
    CCLabelTTF * userName;
    CCLabelTTF * scoreDiscription;
    CCLabelTTF * userScore;
    id action;
    id action2;
}
+(CCScene *) scene;
@end
