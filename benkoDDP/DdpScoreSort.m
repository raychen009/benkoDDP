//
//  DdpScoreSort.m
//  benkoDDP
//
//  Created by kwan terry on 11-8-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DdpScoreSort.h"
#import "DdpMenu.h"

@implementation DdpScoreSort

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	DdpScoreSort *layer = [DdpScoreSort node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init
{
    if((self = [super init]))
    {
        sqldata = [[DdpData alloc]init];
        [sqldata openDB];
        [sqldata createScorePlace];
        sqlite3_stmt *statement = [sqldata scoreStatement];
        //存储背景图片的sprite
        CCSprite * background = [CCSprite spriteWithFile:@"menu.png"];
        CCSprite * background_on = [CCSprite spriteWithFile:@"menu.png"];
        CCMenuItemImage *score = [CCMenuItemImage itemFromNormalSprite:background selectedSprite:background_on target:self selector:@selector(clickSort:)];
        CCMenu * sort = [CCMenu menuWithItems:score, nil];
        sort.anchorPoint = CGPointZero;
        sort.position = CGPointMake(160.0f, 240.0f);
        
        [self addChild:sort z:1 tag:2];
        
        CCLabelTTF * tip = [CCLabelTTF labelWithString:@"前十排行榜" fontName:@"Marker Felt" fontSize:20.0f];
        tip.position = CGPointMake(160.0f, 345.0f);
        tip.color = ccBLACK;
        [self addChild:tip z:1];
        NSLog(@"分数排名");
        //进入排名的最低分数
        int leastScore;
        int count = 0;
        int po_x = 100.0f;
        int po_y = 30.0f;
        int score_x = 200.0f;
        while (count <=9 && sqlite3_step(statement) == SQLITE_ROW) {
            count ++;
            NSString * name = [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 0) encoding:NSUTF8StringEncoding];
            int score = sqlite3_column_int(statement, 1);
            leastScore = score;
            //显示提示的信息
            CCLabelTTF * sortName = [CCLabelTTF labelWithString:name fontName:@"Marker Felt" fontSize:20.0f];
            sortName.color = ccBLACK;
            sortName.position = CGPointMake(po_x, 350.0f - po_y * count);
            [self addChild:sortName z:1];
            
            CCLabelTTF * sortScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", score] fontName:@"Marker Felt" fontSize:20.0f];
            sortScore.color = ccBLUE;
            sortScore.position = CGPointMake(score_x, 350.0f - po_y * count);
            [self addChild:sortScore z:1];
        }
        sqlite3_finalize(statement);
        if (count == 10) {
            [sqldata deleteScore:leastScore];
        }
    }
    return self;
}

- (void) clickSort: (id) sender
{
    //退出之前关闭数据库
    [sqldata closeDB];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInB transitionWithDuration:0.3f scene:[DdpMenu scene]]];
}
- (void) dealloc
{
	//这里添加需要释放的对象
    [sqldata release];
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
