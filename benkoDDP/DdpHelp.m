//
//  DdpHelp.m
//  benkoDDP
//
//  Created by kwan terry on 11-8-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DdpHelp.h"
#import "DdpMenu.h"

@implementation DdpHelp

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	DdpHelp *layer = [DdpHelp node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init
{
    if((self = [super init]))
    {
//        //存储背景图的sprite
//        CCSprite *background = [CCSprite spriteWithFile:@"menu.png"];
//        background.anchorPoint = CGPointZero;
//        [self addChild:background z:0 tag:1];
        
        //帮助的图片按钮
        CCSprite *help = [CCSprite spriteWithFile:@"help.png"];
        CCSprite *help_on = [CCSprite spriteWithFile:@"help.png"];
        CCMenuItemImage *helpView = [CCMenuItemImage itemFromNormalSprite:help selectedSprite:help_on target:self selector:@selector(clickHelp:)];
        CCMenu * helpMenu = [CCMenu menuWithItems:helpView, nil];
        helpMenu.anchorPoint = CGPointZero;
        [helpMenu alignItemsVertically];
        helpMenu.position = CGPointMake(160.0f, 240.0f);
        helpMenu.scaleX = 0.7f;
        helpMenu.scaleY = 0.6f;
        [self addChild:helpMenu z:1 tag:2];
    }
    return self;
}

//点击help的图片
- (void) clickHelp: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeUp transitionWithDuration:0.6f scene:[DdpMenu scene]]];
}

- (void) dealloc
{
	//这里添加需要释放的对象
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
