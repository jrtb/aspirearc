//
//  MenuScene.h
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "SoundMenuItem.h"
#import "questionsAppDelegate.h"

@interface MenuScene : CCScene {}
+(id) scene;
@end

@interface MenuLayer : CCLayer {
	
	SoundMenuItem *item1;
	SoundMenuItem *item2;

	CCMenu *menu1;
	
}

- (void) start:(id)sender;
- (void) options:(id)sender;


@end