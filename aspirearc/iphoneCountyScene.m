//
//  iphoneCountyScene.m
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Created by Martin Rehder on 06.05.13.
//

//http://www.cocos2d-iphone.org/forums/topic/table-view/page/6/

#import "iphoneCountyScene.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"

@implementation iphoneCountyScene

+(id) scene
{
    CCScene *scene = [CCScene node];
	iphoneCountyScene *layer = [iphoneCountyScene node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
    if (( self = [super init]))
    {
        
        printf("county scene loading\n");
        
        items = [[NSMutableArray alloc] init];

        CGSize size = [[CCDirector sharedDirector] winSize];
        
        iphoneAddY = 0;
        
        if (IS_IPHONE5)
            iphoneAddY = 44.0;

        CCSprite *mainBack = [CCSprite spriteWithFile:@"county_menu_bg.pvr.gz"];
        mainBack.anchorPoint = ccp(0.5,1.0);
        mainBack.position = ccp(size.width*.5,size.height);
        [self addChild:mainBack z:2];

        CCSprite *mainBack2 = [CCSprite spriteWithFile:@"county_menu_bg_back.pvr.gz"];
        mainBack2.anchorPoint = ccp(0.5,1.0);
        mainBack2.position = ccp(size.width*.5,size.height);
        [self addChild:mainBack2 z:0];

        CCSprite *bottom = [CCSprite spriteWithFile:@"bottom_bar.pvr.gz"];
        bottom.anchorPoint = ccp(0.5,0.5);
        bottom.position = ccp(size.width*.5,bottom.contentSize.height*.5);
        [self addChild:bottom z:2];
        
        CCLabelBMFont *labelBottom = [CCLabelBMFont labelWithString:@"ASPIRE - County Selection" fntFile:@"bottom-menu-14.fnt"];
        labelBottom.anchorPoint = ccp(0.5,0.5);
        labelBottom.position = bottom.position;
        [self addChild:labelBottom z:3];
        
        // set up the scrolling layer
        isDragging = NO;
        lasty = 0.0f;
        yvel = 0.0f;
        contentHeight = 45*29-230; // whatever you want here for total height
        // main scrolling layer
        scrollLayer = [[CCLayer alloc] init];
        scrollLayer.position = ccp(0.0,0.0);
        [self addChild:scrollLayer z:1 tag:0];
        
        // create buttons
        
        float scrollTop = 336+iphoneAddY*2;
        
        for (int i=0; i < 29; i++) {
        
            CCSprite *buttonBack = [CCSprite spriteWithFile:@"county_menu_cellbg.pvr.gz"];
            buttonBack.anchorPoint = ccp(0.5,0.5);
            buttonBack.position = ccp(size.width*.5,scrollTop-buttonBack.contentSize.height*i-buttonBack.contentSize.height*.5);
            [scrollLayer addChild:buttonBack z:0];
            
            NSString *cellString;// = [NSString stringWithFormat:@"Cell %d", idx];
            
            switch (i) {
                case 0:
                    cellString = @"Alexander";
                    break;
                case 1:
                    cellString = @"Ashe";
                    break;
                case 2:
                    cellString = @"Burke";
                    break;
                case 3:
                    cellString = @"Catawba";
                    break;
                case 4:
                    cellString = @"Camden";
                    break;
                case 5:
                    cellString = @"Cherokee";
                    break;
                case 6:
                    cellString = @"Chowan";
                    break;
                case 7:
                    cellString = @"Davidson";
                    break;
                case 8:
                    cellString = @"Davie";
                    break;
                case 9:
                    cellString = @"Haywood";
                    break;
                case 10:
                    cellString = @"Hertford";
                    break;
                case 11:
                    cellString = @"Johnston";
                    break;
                case 12:
                    cellString = @"Lincoln";
                    break;
                case 13:
                    cellString = @"Madison";
                    break;
                case 14:
                    cellString = @"Mitchell";
                    break;
                case 15:
                    cellString = @"Montgomery";
                    break;
                case 16:
                    cellString = @"Northampton";
                    break;
                case 17:
                    cellString = @"Pasquotank";
                    break;
                case 18:
                    cellString = @"Person";
                    break;
                case 19:
                    cellString = @"Pitt";
                    break;
                case 20:
                    cellString = @"Robeson";
                    break;
                case 21:
                    cellString = @"Rowan";
                    break;
                case 22:
                    cellString = @"Rutherford";
                    break;
                case 23:
                    cellString = @"Sampson";
                    break;
                case 24:
                    cellString = @"Stanly";
                    break;
                case 25:
                    cellString = @"Union";
                    break;
                case 26:
                    cellString = @"Warren";
                    break;
                case 27:
                    cellString = @"Wayne";
                    break;
                case 28:
                    cellString = @"Wilson";
                    break;
            }
            
            CCLabelBMFont *label = [CCLabelBMFont labelWithString:cellString fntFile:@"county-menu-24.fnt"];
            label.anchorPoint = ccp(0.5,0.5);
            label.position = buttonBack.position;
            label.tag = i;
            [scrollLayer addChild:label];
            [items addObject:label];

        }
        
        
        CCSprite *aSmall = [CCSprite spriteWithFile:@"home_button.pvr.gz"];
        aSmall.color = ccGRAY;
        
        CCMenuItemSprite *itemA = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"home_button.pvr.gz"]
                                                          selectedSprite:aSmall
                                                                  target:self
                                                                selector:@selector(closeAction:)];
        
        CCMenu  *menuA = [CCMenu menuWithItems:itemA, nil];
        [menuA setPosition:ccp(size.width-29,size.height-28)];
        [self addChild:menuA z:70];

        [self schedule:@selector(moveTick:) interval:0.02f];
        [self setTouchEnabled:YES];

        printf("got here\n");
    }
    return self;
}

- (void) processTouch: (CGPoint)point
{
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //printf("touched!\n");
    
    //CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    dragged = NO;
    isDragging = YES;
    
    for (UITouch *touch in touches){
		
		CGPoint point = [touch locationInView: [touch view]];
		point = [[CCDirector sharedDirector] convertToGL: point];
		
        point = ccp(point.x,point.y);
        
        //printf("touch location: %f\n", point.y);
        
	}

    return;
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    dragged = YES;
    
    UITouch *touch = [touches anyObject];
    
    // simple position update
    CGPoint a = [[CCDirector sharedDirector] convertToGL:[touch previousLocationInView:touch.view]];
    CGPoint b = [[CCDirector sharedDirector] convertToGL:[touch locationInView:touch.view]];
    CGPoint nowPosition = scrollLayer.position;
    nowPosition.y += ( b.y - a.y );
    //nowPosition.y = MAX( 0, nowPosition.y );
    //nowPosition.y = MIN( contentHeight + 0, nowPosition.y );
    scrollLayer.position = nowPosition;
    
    return;
}

- (void) ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    isDragging = NO;
    
    CGPoint pos = scrollLayer.position;
    
    if ( pos.y < 0 ) {
        //printf("1\n");
        yvel = 0;
        //pos.y = 0;
        [scrollLayer runAction:[CCMoveTo actionWithDuration:0.4f position:CGPointMake(scrollLayer.position.x, 0)]];
    }
    if ( pos.y > contentHeight) {
        //printf("2\n");
        yvel = 0;
        //pos.y = contentHeight;
        [scrollLayer runAction:[CCMoveTo actionWithDuration:0.4f position:CGPointMake(scrollLayer.position.x, contentHeight)]];
    }
    
}

- (void) startMovingAgain: (id) sender
{
    [self unschedule:@selector(startMovingAgain:)];
    
    [self schedule:@selector(moveTick:) interval:0.02f];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches){
		
		CGPoint point = [touch locationInView: [touch view]];
		point = [[CCDirector sharedDirector] convertToGL: point];
		
        point = ccp(point.x,point.y);
        
        float scrollTop = 336.0+iphoneAddY*2;
        float touchInScroll = (point.y - scrollTop) * -1;
        
        //printf("end touch location: %f\n", touchInScroll);

        //printf("scrollLayer location: %f\n",scrollLayer.position.y);
        
        float touchWithScroll = touchInScroll+scrollLayer.position.y;
        
        //printf("touchWithScroll: %f\n", touchWithScroll);
        
        float indexTouched = touchWithScroll / 45.0;
        
        //printf("indexTouched: %f\n",indexTouched);
        
        
        if (!dragged) {

            int index = floor(indexTouched);
            
            if (index >= 0) {
            
                [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
                
                //printf("index: %i\n",index);
                
                touchedItem = index;
                
                CCLabelBMFont *label = [items objectAtIndex:index];
                
                label.color = ccc3(170, 170, 170);
                
                [self schedule:@selector(buttonPressed:) interval:0.2];
                
            }

        }
        
	}

    isDragging = NO;
    
    CGPoint pos = scrollLayer.position;
    
    if ( pos.y < 0 ) {
        //printf("1\n");
        yvel = 0;
        //pos.y = 0;
        [scrollLayer runAction:[CCMoveTo actionWithDuration:0.4f position:CGPointMake(scrollLayer.position.x, 0)]];
    }
    if ( pos.y > contentHeight) {
        //printf("2\n");
        yvel = 0;
        //pos.y = contentHeight;
        [scrollLayer runAction:[CCMoveTo actionWithDuration:0.4f position:CGPointMake(scrollLayer.position.x, contentHeight)]];
    }
    
    //scrollLayer.position = pos;
    
    if (!dragged) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView: [touch view]];
        point = [[CCDirector sharedDirector] convertToGL: point];
        
        //printf("touch at %f,%f\n",point.x,point.y);
        
        point.x -= scrollLayer.position.x;
        
        return;
    }
}

- (void) moveTick: (ccTime)dt {
	float friction = 0.95f;
    
	if ( !isDragging )
	{
        if ( scrollLayer.position.y < 0 ) {
            //printf("3\n");
            [self unschedule:@selector(moveTick:)];
            [scrollLayer stopAllActions];
            [scrollLayer runAction:[CCMoveTo actionWithDuration:0.3f position:CGPointMake(scrollLayer.position.x, 0)]];
            [self schedule:@selector(startMovingAgain:) interval:0.3];
        } else if ( scrollLayer.position.y > contentHeight) {
            //printf("4\n");
            [self unschedule:@selector(moveTick:)];
            [scrollLayer stopAllActions];
            [scrollLayer runAction:[CCMoveTo actionWithDuration:0.3f position:CGPointMake(scrollLayer.position.x, contentHeight)]];
            [self schedule:@selector(startMovingAgain:) interval:0.3];
        } else {
            
            //printf("5\n");
            
            // inertia
            yvel *= friction;
            CGPoint pos = scrollLayer.position;
            
            //printf("scrollLayer Y Position: %f\n",pos.y);
            
            pos.y += yvel;
            
            // *** CHANGE BEHAVIOR HERE *** //
            // to stop at bounds
            //pos.y = MAX( 320, pos.y );
            //pos.y = MIN( contentHeight + 320, pos.y );
            // to bounce at bounds
            
            if ( pos.y < 40 ) { yvel = 0; pos.y = 0; }
            if ( pos.y > contentHeight + 0 ) { yvel = 0; pos.y = contentHeight + 0; }
            
            //if ( pos.y < 0 ) { yvel *= -0.1; pos.y = 0; }
            //if ( pos.y > contentHeight) { yvel *= -0.1; pos.y = contentHeight; }
            
            scrollLayer.position = pos;
            
        }
	}
	else
	{
		yvel = ( scrollLayer.position.y - lasty ) / 2;
		lasty = scrollLayer.position.y;
	}
}

- (void) closeAction: (id)sender
{
    //myTable.delegate = nil;

    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    [delegate setScreenToggle:MENU];
    
    [delegate replaceTheScene];
}

- (void) buttonPressed: (id) sender
{
    [self unschedule:@selector(buttonPressed:)];

    CCLabelBMFont *label = [items objectAtIndex:touchedItem];
    
    label.color = ccWHITE;
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];

    [delegate setScreenToggle:MENU];
    
    [delegate replaceTheScene];
    
}

- (void)dealloc {
	
	NSLog(@"releasing CountyNode elements");
	
    [self unscheduleAllSelectors];
        
    [self removeAllChildrenWithCleanup:YES];
    
    /*
    for (int i=0; i < [items count]; i++) {
		id aPiece = [items objectAtIndex:i];
		[aPiece stopAllActions];
        [aPiece removeAllChildrenWithCleanup:YES];
		[self removeChild:aPiece cleanup:YES];
	}
	[items removeAllObjects];
	[items release];
	items = nil;
     */
    
    [[CCDirector sharedDirector] purgeCachedData];
    
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    [CCTextureCache purgeSharedTextureCache];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    
    //[super dealloc];
}

@end
