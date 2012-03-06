//
//  DdpMenu.m
//  benkoDDP
//
//  Created by kwan terry on 11-8-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DdpMenu.h"
#import "DdpHelp.h"
#import "DdpScoreSort.h"
#import "DdpSetting.h"
#import "DdpGameView.h"
@implementation DdpMenu

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	DdpMenu *layer = [DdpMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
    if((self = [super init])){
        //数据库操作
        sqldata = [[DdpData alloc]init];
        //打开数据库
        [sqldata openDB];
        [sqldata createTable];
        name =[[NSString alloc]init];
        name = [sqldata selectLastName];
        score = [sqldata gettingScore];
        
        self.isTouchEnabled = YES;
        //检查用户是不是第一次进入游戏，如果用户还没有已经选择了的用户名的话，就提示进入游戏设置选择或者创建用户名
        if (name == nil) {
            //显示提示的信息
            id act1 = [CCFadeOut actionWithDuration:1.5f];
            tips1 = [CCLabelTTF labelWithString:@"请进入游戏设置创建用户" fontName:@"Marker Felt" fontSize:20.0f];
            tips1.anchorPoint = CGPointZero;
            tips1.color = ccBLACK;
            tips1.position = CGPointMake(30.0f, 150.0f);
            action = [CCFadeIn actionWithDuration:1.5f];
            action2 = [CCFadeOut actionWithDuration:1.5f];
            [tips1 runAction:[CCSequence actions:action,action2,nil]];
            //[tips1 runAction:act1];
            [self addChild:tips1 z:1];
            
            id act2 = [CCFadeOut actionWithDuration:1.5f];
            tips2 = [CCLabelTTF labelWithString:@"先创建用户才能开始游戏哟！" fontName:@"Marker Felt" fontSize:20.0f];
            tips2.anchorPoint = CGPointZero;
            tips2.color = ccBLACK;
            tips2.position = CGPointMake(30.0f, 120.0f);
            tips2.visible = NO;
            action = [CCFadeIn actionWithDuration:1.5f];
            action2 = [CCFadeOut actionWithDuration:1.5f];
            [tips2 runAction:[CCSequence actions:action,action2,nil]];
            //[tips2 runAction:act2];
            [self addChild:tips2 z:1];
        }else{
            //显示欢迎信息的label
            
            id act3 = [CCFadeOut actionWithDuration:1.5f];
            nameDiscription = [CCLabelTTF labelWithString:@"欢迎你回来" fontName:@"Marker Felt" fontSize:20.0f];
            nameDiscription.color = ccBLACK;
            nameDiscription.anchorPoint = CGPointZero;
            nameDiscription.position = CGPointMake(30.0f, 150.0f);
            action = [CCFadeIn actionWithDuration:1.5f];
            action2 = [CCFadeOut actionWithDuration:1.5f];
            [nameDiscription runAction:[CCSequence actions:action,action2,nil]];
            //[nameDiscription runAction:act3];
            [self addChild:nameDiscription z:1];
            
            id act4 = [CCFadeOut actionWithDuration:1.5f];
            userName = [CCLabelTTF labelWithString:name fontName:@"Marker Felt" fontSize:20.0f];
            userName.color = ccBLUE;
            userName.anchorPoint = CGPointZero;
            userName.position = CGPointMake(230.0f, 150.0f);
            action = [CCFadeIn actionWithDuration:1.5f];
            action2 = [CCFadeOut actionWithDuration:1.5f];
            [userName runAction:[CCSequence actions:action,action2,nil]];
            //[userName runAction:act4];
            [self addChild:userName z:1];
            
            id act5 = [CCFadeOut actionWithDuration:1.5f];
            scoreDiscription = [CCLabelTTF labelWithString:@"你目前的最高分数是" fontName:@"Marker Felt" fontSize:20.0f];
            scoreDiscription.color = ccBLACK;
            scoreDiscription.anchorPoint = CGPointZero;
            scoreDiscription.position = CGPointMake(30.0f, 120.0f);
            action = [CCFadeIn actionWithDuration:1.5f];
            action2 = [CCFadeOut actionWithDuration:1.5f];
            [scoreDiscription runAction:[CCSequence actions:action,action2,nil]];
            //[scoreDiscription runAction:act5];
            [self addChild:scoreDiscription z:1];
            
            id act6 = [CCFadeOut actionWithDuration:1.5f];
            userScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",score] fontName:@"Marker Felt" fontSize:20.0f];
            userScore.color = ccBLUE;
            userScore.anchorPoint = CGPointZero;
            userScore.position = CGPointMake(230.0f, 120.0f);
            action = [CCFadeIn actionWithDuration:1.5f];
            action2 = [CCFadeOut actionWithDuration:1.5f];
            [userScore runAction:[CCSequence actions:action,action2,nil]];
            //[userScore runAction:act6];
            [self addChild:userScore z:1];
        }
        //-----------//
        
        //声明存储menu背景图的sprite
        CCSprite *menu = [CCSprite spriteWithFile:@"menu.png"];
        //设定sprite的参照点
        menu.anchorPoint = CGPointZero;
        //将menu添加到当前层的子列表中
        [self addChild:menu z:0 tag:1];
        
        //下面添加按钮项目
        //开始游戏
        CCSprite *start_off = [CCSprite spriteWithFile:@"bt_start.png"];
        CCSprite *start_on = [CCSprite spriteWithFile:@"bt_start_on.png"];
        
        CCMenuItemImage *startGame = [CCMenuItemSprite itemFromNormalSprite:start_off selectedSprite:start_on target:self selector:@selector(clickStart:)];
            
        //游戏设置
        CCSprite *setting_off = [CCSprite spriteWithFile:@"bt_setting.png"];
        CCSprite *setting_on = [CCSprite spriteWithFile:@"bt_setting_on.png"];
        CCMenuItemImage *gameSetting = [CCMenuItemImage itemFromNormalSprite:setting_off selectedSprite:setting_on target:self selector:@selector(clickSetting:)]; 
        
        //游戏帮助
        CCSprite *help_off = [CCSprite spriteWithFile:@"bt_help.png"];
        CCSprite *help_on = [CCSprite spriteWithFile:@"bt_help_on.png"];
        CCMenuItemImage *gameHelp = [CCMenuItemImage itemFromNormalSprite:help_off selectedSprite:help_on target:self selector:@selector(clickHelp:)];
        
        //分数排名
        CCSprite *score_off = [CCSprite spriteWithFile:@"bt_score.png"];
        CCSprite *score_on = [CCSprite spriteWithFile:@"bt_score_on.png"];
        CCMenuItemImage *scoreSort = [CCMenuItemImage itemFromNormalSprite:score_off selectedSprite:score_on target:self selector:@selector(clickSort:)];
        
        //将项目添加到菜单列表中
        CCMenu *sysMenu = [CCMenu menuWithItems:startGame, gameSetting, gameHelp, scoreSort, nil];
             
        //将项目纵向对齐
        
        [sysMenu alignItemsVertically];
        sysMenu.anchorPoint = CGPointZero;
        sysMenu.scale = 0.7f;
        sysMenu.position = CGPointMake(90.0f, 260.0f);
        //将菜单添加到层的子列表中
        [self addChild:sysMenu z:1 tag:2];
        
    }
    return self;
}

-(void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
    [super registerWithTouchDispatcher];
}

//触摸时间：点击开始
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:[touch view]];
    //NSLog(@"%f",touchPoint.x);
    //NSLog(@"%f",touchPoint.y);
    if (touchPoint.x>0 && touchPoint.x<320 && touchPoint.y>240 && touchPoint.y<480) 
    {
        if(name == nil)
        {
            tips2.visible =  NO;
            action = [CCFadeIn actionWithDuration:1.5f];
            action2 = [CCFadeOut actionWithDuration:1.5f];
            [tips1 runAction:[CCSequence actions:action,action2,nil]];
            action = [CCFadeIn actionWithDuration:1.5f];
            action2 = [CCFadeOut actionWithDuration:1.5f];
            [tips2 runAction:[CCSequence actions:action,action2,nil]];
             
        }
        else
        {
            action = [CCFadeIn actionWithDuration:1.5f];
            action2 = [CCFadeOut actionWithDuration:1.5f];
            [nameDiscription runAction:[CCSequence actions:action,action2,nil]];
            action = [CCFadeIn actionWithDuration:1.5f];
            action2 = [CCFadeOut actionWithDuration:1.5f];
            [userName runAction:[CCSequence actions:action,action2,nil]];
            action = [CCFadeIn actionWithDuration:1.5f];
            action2 = [CCFadeOut actionWithDuration:1.5f];
            [scoreDiscription runAction:[CCSequence actions:action,action2,nil]];
            action = [CCFadeIn actionWithDuration:1.5f];
            action2 = [CCFadeOut actionWithDuration:1.5f];
            [userScore runAction:[CCSequence actions:action,action2,nil]];
        }
    }
    
    return YES;
}

//当用户点击“开始游戏”按钮的时候
- (void) clickStart: (id) sender
{
    //先判断有没有已经选择了的用户名
    if (name == nil) {
        tips2.visible = YES;
        action = [CCFadeIn actionWithDuration:1.5f];
        action2 = [CCFadeOut actionWithDuration:1.5f];
        [tips1 runAction:[CCSequence actions:action,action2,nil]];
        action = [CCFadeIn actionWithDuration:1.5f];
        action2 = [CCFadeOut actionWithDuration:1.5f];
        [tips2 runAction:[CCSequence actions:action,action2,nil]];
    }else{
        //关闭数据库
        [sqldata closeDB];
        CCScene *sc = [CCScene node];
        [sc addChild:[DdpGameView node]];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.5f scene:sc]];
    }
}

//当用户点击“游戏设置”按钮的时候
- (void) clickSetting: (id)sender
{
    //关闭数据库
    [sqldata closeDB];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.3f scene:[DdpSetting scene]]];
}

//当用户点击“游戏帮助”按钮的时候
- (void) clickHelp:(id)sender
{
    //关闭数据库
    [sqldata closeDB];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.3f scene:[DdpHelp scene]]];
}

//当用户点击“分数排名”按钮的时候
- (void) clickSort:(id)sender
{
    //关闭数据库
    [sqldata closeDB];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT transitionWithDuration:0.3f scene:[DdpScoreSort scene]]];
}

- (void) dealloc
{
	//这里添加需要释放的对象
	[sqldata release];
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
