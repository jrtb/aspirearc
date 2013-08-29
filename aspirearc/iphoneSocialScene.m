//
//  iphoneSocialScene.m
//
//  Created by James Bossert on 8/15/11.
//  Copyright jrtb 2011. All rights reserved.
//


// Import the interfaces
#import "iphoneSocialScene.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

#import "Flurry.h"

// HelloWorldLayer implementation
@implementation iphoneSocialScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	iphoneSocialScene *layer = [iphoneSocialScene node];
	
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
		
        printf("social scene loading\n");
        
        showingSpinner = NO;

        wrapperOpen = NO;
        
        isTouchable = NO;
        
        iphoneAddY = 0;
        
        if (IS_IPHONE5)
            iphoneAddY = 44.0;
        
        CGSize size = [CCDirector sharedDirector].winSize;
        
        CCSprite *mainBack = [CCSprite spriteWithFile:@"social_bg.pvr.gz"];
        mainBack.anchorPoint = ccp(0.5,1.0);
        mainBack.position = ccp(size.width*.5,size.height);
        [self addChild:mainBack z:2];
        
        CCSprite *bottom = [CCSprite spriteWithFile:@"bottom_bar.pvr.gz"];
        bottom.anchorPoint = ccp(0.5,0.5);
        bottom.position = ccp(size.width*.5,bottom.contentSize.height*.5);
        [self addChild:bottom z:2];
        
        labelBottom = [CCLabelBMFont labelWithString:@"ASPIRE - Social Media" fntFile:@"bottom-menu-14.fnt"];
        labelBottom.anchorPoint = ccp(0.5,0.5);
        labelBottom.position = bottom.position;
        [self addChild:labelBottom z:3];

        CCSprite *twitterSmall = [CCSprite spriteWithFile:@"twitter.pvr.gz"];
        twitterSmall.color = ccGRAY;
        
        CCMenuItemSprite *itemTwitter = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"twitter.pvr.gz"]
                                                          selectedSprite:twitterSmall
                                                                  target:self
                                                                selector:@selector(twitterAction:)];
        
        CCMenu  *menuTwitter = [CCMenu menuWithItems:itemTwitter, nil];
        [menuTwitter setPosition:ccp(320-85.0,304.0+iphoneAddY*2)];
        [self addChild:menuTwitter z:2];

        CCSprite *fbSmall = [CCSprite spriteWithFile:@"facebook.pvr.gz"];
        fbSmall.color = ccGRAY;
        
        CCMenuItemSprite *itemFB = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"facebook.pvr.gz"]
                                                                selectedSprite:fbSmall
                                                                        target:self
                                                                      selector:@selector(fbAction:)];
        
        CCMenu  *menuFB = [CCMenu menuWithItems:itemFB, nil];
        [menuFB setPosition:ccp(85.0,304.0+iphoneAddY*2)];
        [self addChild:menuFB z:2];

        CCSprite *webSmall = [CCSprite spriteWithFile:@"web.pvr.gz"];
        webSmall.color = ccGRAY;
        
        CCMenuItemSprite *itemWeb = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"web.pvr.gz"]
                                                           selectedSprite:webSmall
                                                                   target:self
                                                                 selector:@selector(webAction:)];
        
        CCMenu  *menuWeb = [CCMenu menuWithItems:itemWeb, nil];
        [menuWeb setPosition:ccp(160.0,122.0+iphoneAddY*2)];
        [self addChild:menuWeb z:2];

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

- (void) closeAction: (id)sender
{
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}

    if (wrapperOpen) {
        
        [self removeChild:webViewWrapper];
        webViewWrapper = nil;
        
        wrapperOpen = NO;
        
        labelBottom.string = @"ASPIRE - Social Media";
        
    } else {
    
        [delegate setScreenToggle:MENU];
        
        [delegate replaceTheScene];
        
    }
}

- (void) twitterAction: (id)sender
{
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    [Flurry logEvent:@"Accessed Twitter"];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
        
    labelBottom.string = @"ASPIRE - Twitter";
    
    wrapperOpen = YES;
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
        
        // twitter installed natively, use it
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=aspirencstate"]];
        
    } else {
    
        CGSize size = [CCDirector sharedDirector].winSize;
        
        CGRect frame = CGRectMake(0, 64, size.width, size.height-64-24);
        webView = [[UIWebView alloc] initWithFrame:frame];
        webView.delegate = self;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://twitter.com/aspirencstate"]]];
        
        // put a wrappar around the slider
        webViewWrapper = [CCUIViewWrapper wrapperForUIView:webView];
        [self addChild:webViewWrapper];
        
        if (showingSpinner) {
            showingSpinner = NO;
            [spinner stopAnimating];
            [spinner removeFromSuperview];
            //[spinner release];
            //spinner = nil;
        }
        showingSpinner = YES;
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.color = [UIColor grayColor];
        spinner.hidesWhenStopped = YES;
        [spinner startAnimating];
        spinner.frame = CGRectMake(160-60, 240-60, 120, 120);
        
        [[[CCDirector sharedDirector] view] addSubview:spinner];

        //[webView release];

    }

}

- (void) fbAction: (id)sender
{
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    [Flurry logEvent:@"Accessed Facebook"];

    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //[delegate setScreenToggle:INTRO];
    
    //[delegate replaceTheScene];
    
    /*
    // create slider programatically
    CGRect frame = CGRectMake(20, 240, 280, 20);
    slider= [[UISlider alloc] initWithFrame:frame];
    slider.minimumValue=0;
    slider.maximumValue=100;
    slider.continuous=YES;
    [slider addTarget:self action:@selector(sliderMoved) forControlEvents:UIControlEventValueChanged];
    
	// put a wrappar around the slider
	sliderWrapper = [CCUIViewWrapper wrapperForUIView:slider];
	[self addChild:sliderWrapper];
     */
    
    labelBottom.string = @"ASPIRE - Facebook";

    wrapperOpen = YES;
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        
        // twitter installed natively, use it
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile?id=436155226481887"]];
        
    } else {
    
        CGSize size = [CCDirector sharedDirector].winSize;
        
        CGRect frame = CGRectMake(0, 64, size.width, size.height-64-24);
        webView = [[UIWebView alloc] initWithFrame:frame];
        webView.delegate = self;
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.facebook.com/pages/ACT-Supplemental-Preparation-in-Rural-Education/436155226481887?fref=ts"]]];
        
        // put a wrappar around the slider
        webViewWrapper = [CCUIViewWrapper wrapperForUIView:webView];
        [self addChild:webViewWrapper];
        
        if (showingSpinner) {
            showingSpinner = NO;
            [spinner stopAnimating];
            [spinner removeFromSuperview];
            //[spinner release];
            //spinner = nil;
        }
        showingSpinner = YES;
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinner.color = [UIColor grayColor];
        spinner.hidesWhenStopped = YES;
        [spinner startAnimating];
        spinner.frame = CGRectMake(160-60, 240-60, 120, 120);
        
        [[[CCDirector sharedDirector] view] addSubview:spinner];
        
        //[webView release];

    }
    
}

- (void) webAction: (id)sender
{
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    [Flurry logEvent:@"Accessed ASPIRE Website"];

    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    labelBottom.string = @"ASPIRE - Web";
    
    wrapperOpen = YES;
    
    CGSize size = [CCDirector sharedDirector].winSize;
    
    CGRect frame = CGRectMake(0, 64, size.width, size.height-64-24);
    webView = [[UIWebView alloc] initWithFrame:frame];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://harvest.cals.ncsu.edu/aspire/"]]];
    
    // put a wrappar around the slider
	webViewWrapper = [CCUIViewWrapper wrapperForUIView:webView];
	[self addChild:webViewWrapper];
    
    if (showingSpinner) {
        showingSpinner = NO;
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        //[spinner release];
        //spinner = nil;
    }
    showingSpinner = YES;
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.color = [UIColor grayColor];
    spinner.hidesWhenStopped = YES;
    [spinner startAnimating];
    spinner.frame = CGRectMake(160-60, 240-60, 120, 120);
    
    [[[CCDirector sharedDirector] view] addSubview:spinner];

    //[webView release];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (showingSpinner) {
        showingSpinner = NO;
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        //[spinner release];
        //spinner = nil;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (showingSpinner) {
        showingSpinner = NO;
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        //[spinner release];
        //spinner = nil;
    }
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
