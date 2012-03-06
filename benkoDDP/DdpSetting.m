//
//  DdpSetting.m
//  benkoDDP
//
//  Created by kwan terry on 11-8-4.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "DdpSetting.h"
#import "DdpMenu.h"
#import "SimpleAudioEngine.h"
#import "CJSONDeserializer.h"
@implementation DdpSetting

@synthesize myTextField;
@synthesize musicVolumn;
@synthesize effectVolumn;
@synthesize jsonData;
@synthesize jsonDict;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	DdpSetting *layer = [DdpSetting node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init
{
    if((self = [super init]))
    {
        self.isTouchEnabled = YES;
        
        sqldata = [[DdpData alloc]init];
        //打开数据库
        [sqldata openDB];
        [sqldata createTable];
        //---------------//
                //存储背景图片的sprite
        CCSprite * background = [CCSprite spriteWithFile:@"setting.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background z:0 tag:1];
        //初始化输入文本框
        myTextField =[[UITextField alloc]initWithFrame:CGRectMake(140.0f, 180.0f, 150.0f, 25.0f)];
        [myTextField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [myTextField addTarget:self action:@selector(touchTextFieldAction:) forControlEvents:UIControlEventTouchDown];
        myTextField.backgroundColor = [UIColor whiteColor];
        myTextField.textColor = [UIColor blueColor];
        myTextField = [myTextField autorelease];
        [[[[CCDirector sharedDirector]openGLView]window]addSubview:myTextField];
        //选中用户和删除用户按钮
        //CCMenuItem * chooseUser = [CCMenuItemFont itemFromString:@"确定" target:self selector:@selector(chooseName:)];
        //用来选择下一位用户的按钮
        CCSprite * nextUser = [CCSprite spriteWithFile:@"nextUser.png"];
        CCSprite * nextUser_on = [CCSprite spriteWithFile:@"nextUser_on.png"];
        
        CCMenuItemImage * next = [CCMenuItemImage itemFromNormalSprite:nextUser selectedSprite:nextUser_on target:self selector:@selector(nextName:)];
        
//      CCMenuItem * next = [CCMenuItemFont itemFromString:@"下一位" target:self selector:@selector(nextName:)];
        CCMenuItem * space = [CCMenuItemFont itemFromString:@"     "];
        
        CCSprite * userDelete = [CCSprite spriteWithFile:@"userDelete.png"];
        CCSprite * userDelete_on = [CCSprite spriteWithFile:@"userDelete_on.png"];
        
        CCMenuItemImage * deleteUser = [CCMenuItemImage itemFromNormalSprite:userDelete selectedSprite:userDelete_on target:self selector:@selector(deleteName:)];
        
//      CCMenuItem * deleteUser = [CCMenuItemFont itemFromString:@"删除" target:self selector:@selector(deleteName:)];
        
//      chooseUser.scale = 0.7f;
//      next.scale = 1.0f;
//      deleteUser.scale = 0.7f;
        CCMenu * option = [CCMenu menuWithItems:next,space, deleteUser, nil];
        option.position = CGPointMake(150.0f, 230.0f);
        [option alignItemsHorizontally];
        [self addChild:option z:1];
        
//        //用来选择下一位用户的按钮
//        CCMenuItem * next = [CCMenuItemFont itemFromString:@"下一位" target:self selector:@selector(nextName:)];
//        next.scale = 0.7f;
//        CCMenu * nextMenu = [CCMenu menuWithItems:next, nil];
//        nextMenu.position = CGPointMake(280.0f, 290.0f);
//        [self addChild:nextMenu z:1];
        
        //用于给用户提示的标签
        tips = [CCLabelTTF labelWithString:@"请选择或者创建你的用户名，然后点击下面的勾" fontName:@"Marker Felt" fontSize:12.0f];
        tips.color = ccBLACK;
        tips.position = CGPointMake(160.0f, 260.0f);
        id action = [CCFadeIn actionWithDuration:1.5f];
        id action2 = [CCFadeOut actionWithDuration:1.5f];
        [tips runAction:[CCSequence actions:action,action2,nil]];
        [self addChild:tips z:1];
        
        //确定完成设置的操作，跳转到主菜单
        CCSprite * tick = [CCSprite spriteWithFile:@"tick.png"];
        CCSprite * tick_on = [CCSprite spriteWithFile:@"tick_on.png"];
        
        CCMenuItemImage * complete = [CCMenuItemImage itemFromNormalSprite:tick selectedSprite:tick_on target:self selector:@selector(completeSetting:)];
        
        //CCMenuItem * complete = [CCMenuItemFont itemFromString:@"完成" target:self selector:@selector(completeSetting:)];
        CCMenu * over = [CCMenu menuWithItems:complete, nil];
        over.position = CGPointMake(150.0f, 70.0f);
        
        [self addChild:over z:1];
        //初始化控制背景音乐声音的滚动条
        musicVolumn = [[UISlider alloc]initWithFrame:CGRectMake(140.0f, 300.0f , 150.0f, 20.0f)];
        [musicVolumn addTarget:self action:@selector(changeMusicVol:) forControlEvents:UIControlEventValueChanged];
        musicVolumn.maximumValue = 1.0f;
        musicVolumn.minimumValue = 0.0f;
        musicVolumn = [musicVolumn autorelease];
        [[[[CCDirector sharedDirector]openGLView] window] addSubview:musicVolumn];
        
        //初始化控制音效声音的滚动条
        effectVolumn = [[UISlider alloc] initWithFrame:CGRectMake(140.0f, 340.0f, 150.0f, 20.0f)];
        [effectVolumn addTarget:self action:@selector(changeEffectVol:) forControlEvents:UIControlEventValueChanged];
        effectVolumn.maximumValue = 1.0f;
        effectVolumn.minimumValue = 0.0f;
        effectVolumn = [effectVolumn autorelease];
        [[[[CCDirector sharedDirector] openGLView]window] addSubview:effectVolumn];
        
        //播放背景音乐
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"playing.wav" loop:1];
        
        //获取当前用户的信息
        
//        NSLog(@"next");
//        NSString * user = [sqldata nextUser];
//        if (user ==nil || [user isEqualToString:@""]) {
//            [tips setString:@"没有用户的记录"];
//            myTextField.text = @"";
//        }else{
//            myTextField.text = user;
//            [tips setString:@"请选择或者创建你的用户名"];
//        }
        
        myTextField.text = [sqldata selectLastName];
//      [self nextAction];
        musicVolumn.value = [sqldata gettingMvol];
        //设置背景音乐的音量大小
        [CDAudioManager sharedManager].backgroundMusic.volume = musicVolumn.value;
        //音效音乐的音量大小
        effectVolumn.value = [sqldata gettingEvol];
        //--------------------//
        
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
    //CGPoint touchPoint = [touch locationInView:[touch view]];
    //NSLog(@"%f",touchPoint.x);
    //NSLog(@"%f",touchPoint.y);
    
    //用于给用户提示的标签
    [tips setString:@"请选择或者创建你的用户名，然后点击下面的勾"];
    id action = [CCFadeIn actionWithDuration:1.5f];
    id action2 = [CCFadeOut actionWithDuration:1.5f];
    [tips runAction:[CCSequence actions:action,action2,nil]];    
    
    return YES;
}

- (void) changeMusicVol:(id) sender
{
    [CDAudioManager sharedManager].backgroundMusic.volume = musicVolumn.value;
}

- (void) changeEffectVol: (id) sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"bomb.wav" pitch:1.0f pan:1.0f gain:effectVolumn.value];
}

-(void) chooseName:(id) sender
{
    
}

-(void) deleteName:(id) sender
{
    [self deleteAction];
}

- (void) nextName:(id) sender
{
    [self nextAction];
}


-(void) completeSetting:(id) sender
{
    //必须先选择或者添加用户
    if (myTextField.text == nil || [myTextField.text isEqualToString:@""]) 
    {
        [tips setString:@"还没有选择或者添加用户名"];
        id action = [CCFadeIn actionWithDuration:1.5f];
        id action2 = [CCFadeOut actionWithDuration:1.5f];
        [tips runAction:[CCSequence actions:action,action2,nil]];
    }
    else
    {
        [sqldata updateUser:myTextField.text withMvol:musicVolumn.value andEvol:effectVolumn.value];
        [sqldata useName:myTextField.text];
        //这里移除输入框和滚动条
        [myTextField removeFromSuperview];
        [musicVolumn removeFromSuperview];
        [effectVolumn removeFromSuperview];
        
        
        //关闭数据库
        [sqldata closeDB];
        //这里关闭背景音乐
        [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        //切换到下一个场景
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.3f scene:[DdpMenu scene]]];
    }
}
//文本框回调函数
-(void) textFieldAction:(id)sender
{
    NSLog(@"textFieldAction");
    //--------------------//
    myTextField.text = [myTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //输入的用户名不为空则添加数据
    if ([myTextField.text isEqualToString:@""] || myTextField.text == nil) 
    {
        [tips setString:@"用户名不能为空"];
        id action = [CCFadeIn actionWithDuration:1.5f];
        id action2 = [CCFadeOut actionWithDuration:1.5f];
        [tips runAction:[CCSequence actions:action,action2,nil]];
    }
    else
    {
        [sqldata insertUserWithName:myTextField.text];
    }
    [sqldata displayRecord];
}

//点击文本框时
-(void) touchTextFieldAction:(id) sender
{
    NSLog(@"touchTextFieldAction");
    [tips setString:@"请选择或者创建你的用户名"];
    id action = [CCFadeIn actionWithDuration:1.5f];
    id action2 = [CCFadeOut actionWithDuration:1.5f];
    [tips runAction:[CCSequence actions:action,action2,nil]];
    [self updateAction];
    myTextField.text = @"";
    
}


//各种数据库操作的函数
-(void) nextAction
{
    NSLog(@"next");
    //更新数据
    [sqldata updateUser:myTextField.text withMvol:musicVolumn.value andEvol:effectVolumn.value];
    NSString * user = [sqldata nextUser];
    if (user ==nil || [user isEqualToString:@""]) 
    {
        [tips setString:@"没有用户的记录"];
        id action = [CCFadeIn actionWithDuration:1.5f];
        id action2 = [CCFadeOut actionWithDuration:1.5f];
        [tips runAction:[CCSequence actions:action,action2,nil]];
        myTextField.text = @"";
    }
    else
    {
        myTextField.text = user;
        musicVolumn.value = [sqldata gettingMvol];
        //设置背景音乐的音量大小
        [CDAudioManager sharedManager].backgroundMusic.volume = musicVolumn.value;
        //音效音乐的音量大小
        effectVolumn.value = [sqldata gettingEvol];
        [tips setString:@"请选择或者创建你的用户名"];
        id action = [CCFadeIn actionWithDuration:1.5f];
        id action2 = [CCFadeOut actionWithDuration:1.5f];
        [tips runAction:[CCSequence actions:action,action2,nil]];
    }
}

-(void) deleteAction
{
    if(myTextField.text == nil || [myTextField.text isEqualToString:@""])
    {
        [tips setString:@"此用户不存在"];
        id action = [CCFadeIn actionWithDuration:1.5f];
        id action2 = [CCFadeOut actionWithDuration:1.5f];
        [tips runAction:[CCSequence actions:action,action2,nil]];
    }
    else
    {
        [sqldata deleteUser:myTextField.text];
    }
    [self nextAction];
}

-(void) updateAction
{
    myTextField.text = [myTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //输入的用户名不为空则添加数据
    if ([myTextField.text isEqualToString:@""] || myTextField.text == nil) {
        //[tips setString:@"用户名不能为空"];
    }else{
        //更新数据
        [sqldata updateUser:myTextField.text withMvol:musicVolumn.value andEvol:effectVolumn.value];
    }
}

//-----------------//
- (void) dealloc
{
	//这里添加需要释放的对象
	[sqldata release];
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
