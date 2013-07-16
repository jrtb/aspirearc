//
//  iphoneMenuScene.m
//
//  Created by James Bossert on 8/15/11.
//  Copyright jrtb 2011. All rights reserved.
//


// Import the interfaces
#import "iphoneMenuScene.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

// HelloWorldLayer implementation
@implementation iphoneMenuScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	iphoneMenuScene *layer = [iphoneMenuScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        printf("menu scene loading\n");
        
        items = [[NSMutableArray alloc] init];

        isTouchable = NO;

        iphoneAddY = 0;
        
        if (IS_IPHONE5)
            iphoneAddY = 44.0;

        CGSize size = [CCDirector sharedDirector].winSize;

        CCSprite *mainBack = [CCSprite spriteWithFile:@"main_menu_bg.pvr.gz"];
        mainBack.anchorPoint = ccp(0.5,1.0);
        mainBack.position = ccp(size.width*.5,size.height);
        [self addChild:mainBack z:2];

        if (IS_IPHONE5) {
            CCSprite *calsNew = [CCSprite spriteWithFile:@"cals_new.pvr.gz"];
            calsNew.anchorPoint = ccp(1.0,0.0);
            calsNew.position = ccp(size.width,12);
            [self addChild:calsNew z:2];
        }
        
        float menuStartY = 300.5+iphoneAddY*2;
        float sepY = 38.0;
        
        CCMenuItemSprite *itemA = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                          selectedSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                                  target:self
                                                                selector:@selector(aAction:)];
        
        CCMenu  *menuA = [CCMenu menuWithItems:itemA, nil];
        [menuA setPosition:ccp(size.width*.5,menuStartY - sepY*0)];
        [self addChild:menuA z:2];

        CCLabelBMFont *labelA = [CCLabelBMFont labelWithString:@"About A.S.P.I.R.E." fntFile:@"main-menu-24.fnt"];
        labelA.anchorPoint = ccp(0.5,0.6);
        labelA.position = menuA.position;
        [self addChild:labelA z:3];
        [items addObject:labelA];

        CCMenuItemSprite *itemB = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                          selectedSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                                  target:self
                                                                selector:@selector(bAction:)];
        
        CCMenu  *menuB = [CCMenu menuWithItems:itemB, nil];
        [menuB setPosition:ccp(size.width*.5,menuStartY - sepY*1)];
        [self addChild:menuB z:2];
        
        CCLabelBMFont *labelB = [CCLabelBMFont labelWithString:@"About CALS" fntFile:@"main-menu-24.fnt"];
        labelB.anchorPoint = ccp(0.5,0.6);
        labelB.position = menuB.position;
        [self addChild:labelB z:3];
        [items addObject:labelB];

        CCMenuItemSprite *itemC = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                          selectedSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                                  target:self
                                                                selector:@selector(cAction:)];
        
        CCMenu  *menuC = [CCMenu menuWithItems:itemC, nil];
        [menuC setPosition:ccp(size.width*.5,menuStartY - sepY*2)];
        [self addChild:menuC z:2];
        
        CCLabelBMFont *labelC = [CCLabelBMFont labelWithString:@"ACT Practice Questions" fntFile:@"main-menu-24.fnt"];
        labelC.anchorPoint = ccp(0.5,0.6);
        labelC.position = menuC.position;
        [self addChild:labelC z:3];
        [items addObject:labelC];

        CCMenuItemSprite *itemD = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                          selectedSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                                  target:self
                                                                selector:@selector(dAction:)];
        
        CCMenu  *menuD = [CCMenu menuWithItems:itemD, nil];
        [menuD setPosition:ccp(size.width*.5,menuStartY - sepY*3)];
        [self addChild:menuD z:2];
        
        CCLabelBMFont *labelD = [CCLabelBMFont labelWithString:@"Schedules and Class Locations" fntFile:@"main-menu-24.fnt"];
        labelD.anchorPoint = ccp(0.5,0.6);
        labelD.position = menuD.position;
        [self addChild:labelD z:3];
        [items addObject:labelD];

        CCMenuItemSprite *itemE = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                          selectedSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                                  target:self
                                                                selector:@selector(eAction:)];
        
        CCMenu  *menuE = [CCMenu menuWithItems:itemE, nil];
        [menuE setPosition:ccp(size.width*.5,menuStartY - sepY*4)];
        [self addChild:menuE z:2];
        
        CCLabelBMFont *labelE = [CCLabelBMFont labelWithString:@"Social Media & Message Board" fntFile:@"main-menu-24.fnt"];
        labelE.anchorPoint = ccp(0.5,0.6);
        labelE.position = menuE.position;
        [self addChild:labelE z:3];
        [items addObject:labelE];

        CCMenuItemSprite *itemF = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                          selectedSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                                  target:self
                                                                selector:@selector(fAction:)];
        
        itemF.opacity = 0;
        
        CCMenu  *menuF = [CCMenu menuWithItems:itemF, nil];
        [menuF setPosition:ccp(size.width*.5,menuStartY - sepY*5)];
        [self addChild:menuF z:2];
        
        CCLabelBMFont *labelF = [CCLabelBMFont labelWithString:@"Contact Your Teacher" fntFile:@"main-menu-24.fnt"];
        labelF.anchorPoint = ccp(0.5,0.6);
        labelF.position = menuF.position;
        [self addChild:labelF z:3];
        [items addObject:labelF];

	}
	return self;
}

- (void) aAction: (id)sender
{
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    CCLabelBMFont *label = [items objectAtIndex:0];
    
    label.color = ccc3(170, 170, 170);
    
    [self schedule:@selector(buttonPressedA:) interval:0.1];

}

- (void) buttonPressedA: (ccTime)sender
{
    [self unschedule:@selector(buttonPressedA:)];
    
    CCLabelBMFont *label = [items objectAtIndex:0];
    
    label.color = ccWHITE;
    
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //[delegate setScreenToggle:INTRO];
    
    //[delegate replaceTheScene];
    
}

- (void) bAction: (id)sender
{
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    CCLabelBMFont *label = [items objectAtIndex:1];
    
    label.color = ccc3(170, 170, 170);
    
    [self schedule:@selector(buttonPressedB:) interval:0.1];
    
}

- (void) buttonPressedB: (ccTime)sender
{
    [self unschedule:@selector(buttonPressedB:)];
    
    CCLabelBMFont *label = [items objectAtIndex:1];
    
    label.color = ccWHITE;
    
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //[delegate setScreenToggle:INTRO];
    
    //[delegate replaceTheScene];
    
}

- (void) cAction: (id)sender
{
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    CCLabelBMFont *label = [items objectAtIndex:2];
    
    label.color = ccc3(170, 170, 170);
    
    [self schedule:@selector(buttonPressedC:) interval:0.1];
    
}

- (void) buttonPressedC: (ccTime)sender
{
    [self unschedule:@selector(buttonPressedC:)];
    
    CCLabelBMFont *label = [items objectAtIndex:2];
    
    label.color = ccWHITE;
    
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //[delegate setScreenToggle:INTRO];
    
    //[delegate replaceTheScene];
    
}

- (void) dAction: (id)sender
{
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    CCLabelBMFont *label = [items objectAtIndex:3];
    
    label.color = ccc3(170, 170, 170);
    
    [self schedule:@selector(buttonPressedD:) interval:0.1];
    
}

- (void) buttonPressedD: (ccTime)sender
{
    [self unschedule:@selector(buttonPressedD:)];
    
    CCLabelBMFont *label = [items objectAtIndex:3];
    
    label.color = ccWHITE;
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    [delegate setScreenToggle:COUNTY];
    
    [delegate replaceTheScene];
    
}

- (void) eAction: (id)sender
{
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    CCLabelBMFont *label = [items objectAtIndex:4];
    
    label.color = ccc3(170, 170, 170);
    
    [self schedule:@selector(buttonPressedE:) interval:0.1];
    
}

- (void) buttonPressedE: (ccTime)sender
{
    [self unschedule:@selector(buttonPressedE:)];
    
    CCLabelBMFont *label = [items objectAtIndex:4];
    
    label.color = ccWHITE;
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    [delegate setScreenToggle:SOCIAL];
    
    [delegate replaceTheScene];
    
}

- (void) fAction: (id)sender
{
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    CCLabelBMFont *label = [items objectAtIndex:5];
    
    label.color = ccc3(170, 170, 170);
    
    [self schedule:@selector(buttonPressedF:) interval:0.1];
    
}

- (void) buttonPressedF: (ccTime)sender
{
    [self unschedule:@selector(buttonPressedF:)];
    
    CCLabelBMFont *label = [items objectAtIndex:5];
    
    label.color = ccWHITE;
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    [delegate setScreenToggle:COUNTY];
    
    [delegate replaceTheScene];
    
}

-(void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];
    
    //CGSize screenSize = [CCDirector sharedDirector].winSize;

    [self setTouchEnabled:YES];
         
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
    printf("menu deallocing\n");
    
    if (soundID != -6000) {
        [[SimpleAudioEngine sharedEngine] stopEffect:soundID];
        soundID = -6000;
    }
    
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
    
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"menu_background.pvr.gz"];
    
	[[CCDirector sharedDirector] purgeCachedData];
	
	[CCSpriteFrameCache purgeSharedSpriteFrameCache];
	[CCTextureCache purgeSharedTextureCache];
	
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
	[[CCTextureCache sharedTextureCache] removeAllTextures];

	// don't forget to call "super dealloc"
	//[super dealloc];
}
@end
