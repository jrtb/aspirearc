//
//  iphoneACTResultsScene.m
//
//  Created by James Bossert on 8/15/11.
//  Copyright jrtb 2011. All rights reserved.
//


// Import the interfaces
#import "iphoneACTResultsScene.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

#import "Flurry.h"

// HelloWorldLayer implementation
@implementation iphoneACTResultsScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	iphoneACTResultsScene *layer = [iphoneACTResultsScene node];
	
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
        
        CCSprite *mainBack = [CCSprite spriteWithFile:@"act_results_background.pvr.gz"];
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
                
        CCSprite *aSmall = [CCSprite spriteWithFile:@"home_button.png"];
        aSmall.color = ccGRAY;
        
        CCMenuItemSprite *itemA = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"home_button.png"]
                                                          selectedSprite:aSmall
                                                                  target:self
                                                                selector:@selector(closeAction:)];
        
        CCMenu  *menuA = [CCMenu menuWithItems:itemA, nil];
        [menuA setPosition:ccp(size.width-40,size.height-20)];
        [self addChild:menuA z:70];
        
        AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];

        CCLabelTTF* titleLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"You scored %i out of %i.",[delegate numCorrect],[delegate numQuestions]] fontName:@"HelveticaNeue-Light" fontSize:32 dimensions:CGSizeMake(size.width-20, 240) hAlignment:UITextAlignmentCenter];
        titleLabel.position = ccp(size.width/2, size.height-320);
        titleLabel.color = ccc3(0,0,0);
        [self addChild:titleLabel z:20];

	}
	return self;
}

- (void) closeAction: (id)sender
{
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    [delegate setNumCorrect:0];
    [delegate setCurrentQuestionIndex:0];

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
