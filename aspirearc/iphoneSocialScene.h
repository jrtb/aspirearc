//
//  iphoneSocialScene.h
//
//  Created by James Bossert on 8/15/11.
//  Copyright jrtb 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "CCUIViewWrapper.h"

// HelloWorldLayer
@interface iphoneSocialScene : CCLayer <UIWebViewDelegate>
{
    
    ALuint                      soundID;
    
    BOOL                        isTouchable;
    
    float                       iphoneAddY;
    
    CCUIViewWrapper             *webViewWrapper;
    UIWebView                   *webView;
    
    BOOL                        wrapperOpen;

    CCLabelBMFont               *labelBottom;

    UIActivityIndicatorView     *spinner;
    
    BOOL                        showingSpinner;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
