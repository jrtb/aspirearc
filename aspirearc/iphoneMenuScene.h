//
//  iphoneMenuScene.h
//
//  Created by James Bossert on 8/15/11.
//  Copyright jrtb 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "ReaderViewController.h"
#import "CustomScrollLayer.h"

#import <StoreKit/StoreKit.h>

// HelloWorldLayer
@interface iphoneMenuScene : CCLayer <ReaderViewControllerDelegate, CCScrollLayerDelegate, SKStoreProductViewControllerDelegate>
{
    
    ALuint                      soundID;
    
    BOOL                        isTouchable;
    
    float                       iphoneAddY;
    
    //NSMutableArray              *items;

    ReaderViewController        *readerViewController;
    
    NSMutableArray              *pages;
    NSMutableArray              *items;
    
    BOOL                        touched;
    
    UIActivityIndicatorView     *spinner;
    
    BOOL                        showingSpinner;

}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
