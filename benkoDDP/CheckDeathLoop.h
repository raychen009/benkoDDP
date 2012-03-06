//
//  CheckDeathLoop.h
//  benkoDDP
//
//  Created by kwan terry on 11-8-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface CheckDeathLoop : NSObject 
{
    int BlockSize;
    int promptnumber;
    
    NSMutableArray* prompt;
    NSMutableArray* Block;
}

@property (readwrite)int BlockSize;
@property (readwrite)int promptnumber;

@property (retain)NSMutableArray* prompt;
@property (retain)NSMutableArray* Block;

-(BOOL) isdead;
-(void) CheckDeathLoopWithSize:(int)Size Block:(NSMutableArray*)block;
-(NSMutableArray*) getprompt;
-(void) catchpromptx1:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2;
-(void) leftforwardI:(int)i J:(int)j;
-(void) rightforwardI:(int)i J:(int)j;
-(void) upforwardI:(int)i J:(int)j;
-(void) downforwardI:(int)i J:(int)j;

@end
