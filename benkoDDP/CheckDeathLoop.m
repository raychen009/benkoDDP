//
//  CheckDeathLoop.m
//  benkoDDP
//
//  Created by kwan terry on 11-8-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "CheckDeathLoop.h"


@implementation CheckDeathLoop

@synthesize BlockSize;
@synthesize Block;
@synthesize promptnumber;
@synthesize prompt;

-(BOOL) isdead
{
    for(int i=0; i<BlockSize; i++)
    {
        for(int j=0; j<BlockSize; j++)
        {
                [self leftforwardI:i J:j];
                [self rightforwardI:i J:j];
                [self upforwardI:i J:j];
                [self downforwardI:i J:j];
        }
    }
    if(promptnumber != 0) return  NO;
    else return YES;
}

-(void) CheckDeathLoopWithSize:(int)Size Block:(NSMutableArray *)block
{
    promptnumber = 0;
    Block = block;
    BlockSize = Size;
    
    prompt = [[NSMutableArray alloc]init];
    for(int i=0; i<30; i++)
    {
        NSMutableArray* column = [[NSMutableArray alloc]init];
        for(int j=0; j<4; j++)
            [column addObject:[[NSNumber alloc]initWithInt:0]];
        [prompt addObject:column];
    }
}

-(NSMutableArray*) getprompt
{
    NSMutableArray* coordinate = [[NSMutableArray alloc]init];
    for(int i=0; i<2; i++)
    {
        NSMutableArray* column = [[NSMutableArray alloc]init];
        for(int j=0; j<2; j++)
            [column addObject:[[NSNumber alloc]initWithInt:0]];
        [coordinate addObject:column];
    }
    
    int random = rand()%promptnumber;
    [[coordinate objectAtIndex:0]replaceObjectAtIndex:0 withObject:[[prompt objectAtIndex:random]objectAtIndex:0]];
    [[coordinate objectAtIndex:0]replaceObjectAtIndex:1 withObject:[[prompt objectAtIndex:random]objectAtIndex:1]];
    [[coordinate objectAtIndex:1]replaceObjectAtIndex:0 withObject:[[prompt objectAtIndex:random]objectAtIndex:2]];
    [[coordinate objectAtIndex:1]replaceObjectAtIndex:1 withObject:[[prompt objectAtIndex:random]objectAtIndex:3]];
    
    return coordinate;
}

-(void) catchpromptx1:(int)x1 y1:(int)y1 x2:(int)x2 y2:(int)y2
{
    if(promptnumber < 30)
    {
        [[prompt objectAtIndex:promptnumber]replaceObjectAtIndex:0 withObject:[NSNumber numberWithInt:x1]];
        [[prompt objectAtIndex:promptnumber]replaceObjectAtIndex:1 withObject:[NSNumber numberWithInt:y1]];
        [[prompt objectAtIndex:promptnumber]replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:x2]];
        [[prompt objectAtIndex:promptnumber]replaceObjectAtIndex:3 withObject:[NSNumber numberWithInt:y2]];
    }
    else
        return;
}

-(void) leftforwardI:(int)i J:(int)j
{
    if((j-2) >= 0)
    {
        if([[[Block objectAtIndex:i]objectAtIndex:j-1]gettingType] == [[[Block objectAtIndex:i]objectAtIndex:j]gettingType])
        {
            if((j-3)>=0 && [[[Block objectAtIndex:i]objectAtIndex:j-1]gettingType] == [[[Block objectAtIndex:i]objectAtIndex:j-3]gettingType])
            {
                [self catchpromptx1:i y1:j-3 x2:i y2:j-2];
                if(promptnumber < 30)
                    promptnumber++;
            }
            if((i-1)>=0 && [[[Block objectAtIndex:i]objectAtIndex:j-1]gettingType] == [[[Block objectAtIndex:i-1]objectAtIndex:j-2]gettingType] && (j-2)>=0)
            {
                [self catchpromptx1:i-1 y1:j-2 x2:i y2:j-2];
                if(promptnumber < 30)
                    promptnumber++;
            }
            if((i+1)<BlockSize && [[[Block objectAtIndex:i]objectAtIndex:j-1]gettingType] == [[[Block objectAtIndex:i+1]objectAtIndex:j-2]gettingType] && (j-2)>=0)
            {
                [self catchpromptx1:i+1 y1:j-2 x2:i y2:j-2];
                if(promptnumber < 30)
                    promptnumber++;
            }
            if((j+2)<BlockSize && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i]objectAtIndex:j+2]gettingType])
            {
                [self catchpromptx1:i y1:j+2 x2:i y2:j+1];
                if(promptnumber < 30)
                    promptnumber++;
            }
            if((j+1)<BlockSize && (i-1)>=0 && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i-1]objectAtIndex:j+1]gettingType])
            {
                [self catchpromptx1:i-1 y1:j+1 x2:i y2:j+1];
                if(promptnumber < 30)
                    promptnumber++;
            }
            if((j+1)<BlockSize && (i+1)<BlockSize && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i+1]objectAtIndex:j+1]gettingType])
            {
                [self catchpromptx1:i+1 y1:j+1 x2:i y2:j+1];
                if(promptnumber < 30)
                    promptnumber++;
            }
        }
        if([[[Block objectAtIndex:i]objectAtIndex:j-2]gettingType] == [[[Block objectAtIndex:i]objectAtIndex:j]gettingType])
        {
            if((j-3)>=0 && (i+1)<BlockSize && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i+1]objectAtIndex:j-1]gettingType])
            {
                [self catchpromptx1:i y1:j-1 x2:i+1 y2:j-1];
                if(promptnumber<30)
                    promptnumber++;
            }
            if((i-1)>=0 && (j-1)>=0 && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i-1]objectAtIndex:j-1]gettingType])
            {
                [self catchpromptx1:i y1:j-1 x2:i-1 y2:j-1];
                if(promptnumber<30)
                    promptnumber++;
            }
        }
    }
}

-(void) rightforwardI:(int)i J:(int)j
{
    if((j+2) < BlockSize)
    {
        if([[[Block objectAtIndex:i]objectAtIndex:j+1]gettingType] == [[[Block objectAtIndex:i]objectAtIndex:j]gettingType])
        {
            if((j+3)<BlockSize && [[[Block objectAtIndex:i]objectAtIndex:j+1]gettingType] == [[[Block objectAtIndex:i]objectAtIndex:j+3]gettingType])
            {
                [self catchpromptx1:i y1:j+3 x2:i y2:j+2];
                if(promptnumber<30)
                    promptnumber++;
            }
            if((j+2)<BlockSize && (i-1)>=0 && [[[Block objectAtIndex:i]objectAtIndex:j+1]gettingType] == [[[Block objectAtIndex:i-1]objectAtIndex:j+2]gettingType])
            {
                [self catchpromptx1:i-1 y1:j+2 x2:i y2:j+2];
                if(promptnumber<30)
                    promptnumber++;
            }
            if((j+2)<BlockSize && (i+1)<BlockSize &&
               [[[Block objectAtIndex:i]objectAtIndex:j+1]gettingType] == [[[Block objectAtIndex:i+1]objectAtIndex:j+2]gettingType])
            {
                [self catchpromptx1:i+1 y1:j+2 x2:i y2:j+2];
                if(promptnumber<30)
                    promptnumber++;
            }
            if((j-2)>=0 && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i]objectAtIndex:j-2]gettingType])
            {
                [self catchpromptx1:i y1:j-2 x2:i y2:j-1];
                if(promptnumber<30)
                    promptnumber++;
            }
            if((j-1)>=0 && (i-1)>=0 && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i-1]objectAtIndex:j-1]gettingType])
            {
                [self catchpromptx1:i-1 y1:j-1 x2:i y2:j-1];
                if(promptnumber<30)
                    promptnumber++;
            }
            if((j-1)>=0 && (i+1)<BlockSize && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i+1]objectAtIndex:j-1]gettingType])
            {
                [self catchpromptx1:i+1 y1:j-1 x2:i y2:j-1];
                if(promptnumber<30)
                    promptnumber++;
            }
        }
        if([[[Block objectAtIndex:i]objectAtIndex:j+2]gettingType] == [[[Block objectAtIndex:i]objectAtIndex:j]gettingType])
        {
            if((j+3)<BlockSize && (i+1)<BlockSize &&[[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i+1]objectAtIndex:j+1]gettingType])
            {
                [self catchpromptx1:i+1 y1:j+1 x2:i y2:j+1];
                if(promptnumber<30)
                    promptnumber++;
            }
            if((i-1)>=0 && (j+1)<BlockSize && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i-1]objectAtIndex:j+1]gettingType])
            {
                [self catchpromptx1:i-1 y1:j+1 x2:i y2:j+1];
                if(promptnumber<30)
                    promptnumber++;
            }
        }
    }
}

-(void) upforwardI:(int)i J:(int)j
{
    if((i-2) > 0)
    {
        if([[[Block objectAtIndex:i-1]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i]objectAtIndex:j]gettingType])
        {
            if((i+2)<BlockSize && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i+2]objectAtIndex:j]gettingType])
            {
                [self catchpromptx1:i+2 y1:j x2:i+1 y2:j];
                if(promptnumber<30)
                    promptnumber++;
            }
        
            if((j+1)<BlockSize && (i+1)<BlockSize && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i+1]objectAtIndex:j+1]gettingType])
            {
                [self catchpromptx1:i+1 y1:j+1 x2:i+1 y2:j];
                if(promptnumber<30)
                    promptnumber++;
            }
            if((j-1)>=0 && (i+1)<BlockSize && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i+1]objectAtIndex:j-1]gettingType])
            {
                [self catchpromptx1:i+1 y1:j-1 x2:i+1 y2:j];
                if(promptnumber<30)
                    promptnumber++;
            }
            if((i-3)>=0 && [[[Block objectAtIndex:i-1]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i-3]objectAtIndex:j]gettingType])
            {
                [self catchpromptx1:i-3 y1:j x2:i-2 y2:j];
                if(promptnumber<30)
                    promptnumber++;
            }
            if((i-2)>=0 && (j-1)>=0 && [[[Block objectAtIndex:i-1]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i-2]objectAtIndex:j-1]gettingType])
            {
                [self catchpromptx1:i-2 y1:j-1 x2:i-2 y2:j];
                if(promptnumber<30)
                    promptnumber++;
            }
            if((j+1)<BlockSize && (i-2)>=0 && [[[Block objectAtIndex:i-1]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i-2]objectAtIndex:j+1]gettingType])
            {
                [self catchpromptx1:i-2 y1:j+1 x2:i-2 y2:j];
                if(promptnumber<30)
                    promptnumber++;
            }
        }
        if([[[Block objectAtIndex:i-2]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i]objectAtIndex:j]gettingType])
        {
            if((i-1)>=0 && (j+1)<BlockSize && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i-1]objectAtIndex:j+1]gettingType])
            {
                [self catchpromptx1:i-1 y1:j+1 x2:i-1 y2:j];
                if(promptnumber<30)
                    promptnumber++;
            }
            if((i-1)>=0 && (j-1)>=0 && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i-1]objectAtIndex:j-1]gettingType])
            {
                [self catchpromptx1:i-1 y1:j-1 x2:i-1 y2:j];
                if(promptnumber<30)
                    promptnumber++;
            }
        }
    }
}

-(void) downforwardI:(int)i J:(int)j
{
    if((i+2)<BlockSize)
    {
        if([[[Block objectAtIndex:i+1]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i]objectAtIndex:j]gettingType])
        {
            if((i-2)>=0 && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i-2]objectAtIndex:j]gettingType])
            {
                [self catchpromptx1:i-2 y1:j x2:i-1 y2:j];
                if(promptnumber<30)
                    promptnumber++;
            }
            if((j+1)<BlockSize && (i-1)>=0 && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i-1]objectAtIndex:j+1]gettingType])
            {
                [self catchpromptx1:i-1 y1:j+1 x2:i-1 y2:j];
                if(promptnumber<30)
                    promptnumber++;
            }
            if((j-1)>=0 && (i-1)>=0 && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i-1]objectAtIndex:j-1]gettingType])
            {
                [self catchpromptx1:i-1 y1:j-1 x2:i-1 y2:j];
                if(promptnumber<30)
                    promptnumber++;
            }
            if((i+3)<BlockSize && [[[Block objectAtIndex:i+1]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i+3]objectAtIndex:j]gettingType])
            {
                [self catchpromptx1:i+3 y1:j x2:i+2 y2:j];
                if(promptnumber<30)
                    promptnumber++;
            }
            if((i+2)<BlockSize && (j-1)>=0 && [[[Block objectAtIndex:i+1]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i+2]objectAtIndex:j-1]gettingType])
            {
                [self catchpromptx1:i+2 y1:j-1 x2:i+2 y2:j];
                if(promptnumber<30)
                    promptnumber++;
            }
            if((j+1)<BlockSize && (i+2)<BlockSize && [[[Block objectAtIndex:i+1]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i+2]objectAtIndex:j+1]gettingType])
            {
                [self catchpromptx1:i+2 y1:j+1 x2:i+2 y2:j];
                if(promptnumber<30)
                    promptnumber++;
            }
        }
        
        if([[[Block objectAtIndex:i+2]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i]objectAtIndex:j]gettingType])
        {
            if((i+1)<BlockSize && (j+1)<BlockSize && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i+1]objectAtIndex:j+1]gettingType])
            {
                [self catchpromptx1:i+1 y1:j+1 x2:i+1 y2:j];
                if(promptnumber<30)
                    promptnumber++;
            }
            if((i+1)<BlockSize && (j-1)>=0 && [[[Block objectAtIndex:i]objectAtIndex:j]gettingType] == [[[Block objectAtIndex:i+1]objectAtIndex:j-1]gettingType])
            {
                [self catchpromptx1:i+1 y1:j-1 x2:i+1 y2:j];
                if(promptnumber<30)
                    promptnumber++;
            }
        }
    }
}

@end
