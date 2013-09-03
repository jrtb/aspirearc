//
//  iphoneACTCategoryScene.m
//
//  Created by James Bossert on 8/15/11.
//  Copyright jrtb 2011. All rights reserved.
//


// Import the interfaces
#import "iphoneACTCategoryScene.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

#import "Flurry.h"

// HelloWorldLayer implementation
@implementation iphoneACTCategoryScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	iphoneACTCategoryScene *layer = [iphoneACTCategoryScene node];
	
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
		
        printf("act category scene loading\n");
                
        isTouchable = NO;
        
        iphoneAddY = 0;
        
        if (IS_IPHONE5)
            iphoneAddY = 44.0;
        
        CGSize size = [CCDirector sharedDirector].winSize;
        
        CCSprite *mainBack = [CCSprite spriteWithFile:@"act_questions_background.pvr.gz"];
        mainBack.anchorPoint = ccp(0.5,1.0);
        mainBack.position = ccp(size.width*.5,size.height);
        [self addChild:mainBack z:2];
        
        CCSprite *bottom = [CCSprite spriteWithFile:@"bottom_bar.pvr.gz"];
        bottom.anchorPoint = ccp(0.5,0.5);
        bottom.position = ccp(size.width*.5,bottom.contentSize.height*.5);
        [self addChild:bottom z:2];
        
        labelBottom = [CCLabelBMFont labelWithString:@"ASPIRE - ACT Questions" fntFile:@"bottom-menu-14.fnt"];
        labelBottom.anchorPoint = ccp(0.5,0.5);
        labelBottom.position = bottom.position;
        [self addChild:labelBottom z:3];
        
        CCSprite *eSmall = [CCSprite spriteWithFile:@"act_questions_english_button.pvr.gz"];
        eSmall.color = ccGRAY;
        
        CCMenuItemSprite *itemEnglish = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"act_questions_english_button.pvr.gz"]
                                                                selectedSprite:eSmall
                                                                        target:self
                                                                      selector:@selector(englishAction:)];
        
        CCMenu  *menuEnglish = [CCMenu menuWithItems:itemEnglish, nil];
        [menuEnglish setPosition:ccp(160.0,size.height-200.0)];
        [self addChild:menuEnglish z:2];

        CCSprite *rSmall = [CCSprite spriteWithFile:@"act_questions_reading_button.pvr.gz"];
        rSmall.color = ccGRAY;
        
        CCMenuItemSprite *itemReading = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"act_questions_reading_button.pvr.gz"]
                                                                selectedSprite:rSmall
                                                                        target:self
                                                                      selector:@selector(readingAction:)];
        
        CCMenu  *menuReading = [CCMenu menuWithItems:itemReading, nil];
        [menuReading setPosition:ccp(160.0,size.height-200.0-70.0)];
        [self addChild:menuReading z:2];

        CCSprite *aSmall = [CCSprite spriteWithFile:@"home_button.png"];
        aSmall.color = ccGRAY;
        
        CCMenuItemSprite *itemA = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"home_button.png"]
                                                          selectedSprite:aSmall
                                                                  target:self
                                                                selector:@selector(closeAction:)];
        
        CCMenu  *menuA = [CCMenu menuWithItems:itemA, nil];
        [menuA setPosition:ccp(size.width-40,size.height-20)];
        [self addChild:menuA z:70];
        
        
	}
	return self;
}

- (void) englishAction: (id)sender
{
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    [delegate setCurrentCategory:@"ACT English"];
    
    [delegate setScreenToggle:QUESTIONS];
    
    [delegate replaceTheScene];
}

- (void) readingAction: (id)sender
{
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    [delegate setCurrentCategory:@"ACT Reading"];
    
    [delegate setScreenToggle:QUESTIONS];
    
    [delegate replaceTheScene];
}

- (void) closeAction: (id)sender
{
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    [delegate setScreenToggle:MENU];
    
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
    
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"act_questions_background.pvr.gz"];
    
	[[CCDirector sharedDirector] purgeCachedData];
	
	[CCSpriteFrameCache purgeSharedSpriteFrameCache];
	[CCTextureCache purgeSharedTextureCache];
	
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
	[[CCTextureCache sharedTextureCache] removeAllTextures];
    
	// don't forget to call "super dealloc"
	//[super dealloc];
}
@end
