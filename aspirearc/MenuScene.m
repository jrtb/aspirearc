//
//  MenuScene.m
//

#import "questionsAppDelegate.h"
#import "MenuScene.h"
#import "SoundMenuItem.h"
#import "SimpleAudioEngine.h"
#import "QuestionScene.h"
#import "OptionsScene.h"

@implementation MenuScene

+(id) scene {
	
	CCScene *s = [CCScene node];	
	MenuScene *node = [MenuScene node];
	[s addChild:node];
	return s;

}

- (id) init {
    self = [super init];
    if (self != nil) {

        [self addChild:[MenuLayer node] z:1];
		
    }
    return self;
}
@end

@implementation MenuLayer

-(void) onEnterTransitionDidFinish
{	
	[super onEnterTransitionDidFinish];
	
	printf("menu scene onEnterTransitionDidFinish\n");

	//questionsAppDelegate *delegate = (questionsAppDelegate *)[[UIApplication sharedApplication] delegate];	

	item1 = [SoundMenuItem itemFromNormalImage:@"Start-Light_1.png" selectedImage:@"Start-Dark_1.png" target:self selector:@selector(start:)];

	item2 = [SoundMenuItem itemFromNormalImage:@"Options-Light_1.png" selectedImage:@"Options-Dark_1.png" target:self selector:@selector(options:)];

	menu1 = [CCMenu menuWithItems:item1, item2, nil];
	[menu1 alignItemsHorizontallyWithPadding:0];
	menu1.position = CGPointMake(160,65);
	[self addChild: menu1 z:4];

}

- (void) start:(id)sender
{
	[[CCDirector sharedDirector] replaceScene:[QuestionScene scene]];
}

- (void) options:(id)sender
{
	[[CCDirector sharedDirector] replaceScene:[OptionsScene scene]];
}

- (id) init {
    self = [super init];
    if (self != nil) {

		printf("initing menu scene\n");
			
		CCSprite *bg = [CCSprite spriteWithFile:@"Default.png"];
		bg.position = CGPointMake(160, 240);
		[self addChild:bg z:1];
		
		//CGSize wins = [[CCDirector sharedDirector] winSize];

    }
    return self;
}

- (void)dealloc {
	NSLog(@"releasing menu scene componenets");
			
    [super dealloc];
}

@end