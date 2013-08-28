//
//  AppDelegate.m
//  aspirearc
//
//  Created by jrtb on 7/16/13.
//  Copyright ncsu 2013. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"

#import "iphoneMenuScene.h"
#import "iphoneCountyScene.h"
#import "iphoneSocialScene.h"
#import "iphoneAboutMenuScene.h"

#import "iphoneQuestionScene.h"
#import "iphoneACTCategoryScene.h"

#import "iphoneIntroNode.h"

#import "SimpleAudioEngine.h"

#import "Flurry.h"

#import "NSMutableArray+Shuffling.h"

// http://bentrengrove.com/blog/2012/10/23/the-easiest-way-to-enable-arc-for-cocos2d

/*
 I. About ASPIRE
 a. overview of ASPIRE (pg 1 and 2)
 b. Brochure (pg 1 and 2)
 c. ASPIRE Application
 d. Student packet
 e. Website
 2. About CALS
 a. where are you going pdf
 b. all the pdf's we gave you last week?
 3. ACT Practice Q's
 Emailed PR today and they said they are still waiting to hear back from their IT people
 4. Schedules and Class locations
 a. Pick a county?
 i. PDF for each county- at top of each PDF there is the location
 5. Social Media
 a. Facebook
 b. Twitter
 c. Message board- emailed Kim Cox about this and waiting to hear back
 6. Contact your teacher
 a. Select your county again?
 i. PDF info for each teacher
*/

@implementation MyNavigationController

// The available orientations should be defined in the Info.plist file.
// And in iOS 6+ only, you can override it in the Root View controller in the "supportedInterfaceOrientations" method.
// Only valid for iOS 6+. NOT VALID for iOS 4 / 5.
-(NSUInteger)supportedInterfaceOrientations {
	
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationMaskPortrait;
	
	// iPad only
	return UIInterfaceOrientationMaskPortrait;
}

// Supported orientations. Customize it for your own needs
// Only valid on iOS 4 / 5. NOT VALID for iOS 6.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// iPhone only
	if( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone )
		return UIInterfaceOrientationIsPortrait(interfaceOrientation);
	
	// iPad only
	// iPhone only
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

// This is needed for iOS4 and iOS5 in order to ensure
// that the 1st scene has the correct dimensions
// This is not needed on iOS6 and could be added to the application:didFinish...
-(void) directorDidReshapeProjection:(CCDirector*)director
{
	if(director.runningScene == nil) {
		// Add the first scene to the stack. The director will draw it immediately into the framebuffer. (Animation is started automatically when the view is displayed.)
		// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
		[director runWithScene: [iphoneIntroNode scene]];
	}
}
@end


@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;

@synthesize screenToggle, deviceMode, deviceLevel, isRetina, muted, nextScreen, selectedCounty, currentMenuItem, afterCounty, loadPDFInMenu;

@synthesize questions, currentQuestionIndex, doneWithAssessment, currentCategory, numQuestions;

- (NSDictionary *) getNextQuestion {
    
	// figure out how many questions there are in the current category
    
	numQuestions = 0;
	
	NSDictionary *question;
	
	if ([currentCategory isEqualToString:@"All categories"]) {
		numQuestions = [questions count];
	} else {
		for (question in questions) {
			
			if ([[question objectForKey:@"category"] isEqualToString:currentCategory]) {
				numQuestions++;
			}
			
		}
	}
	
	int i=0;
	printf("total questions: %i\n",numQuestions);
    
	for (question in questions) {
		if (i == currentQuestionIndex && ([[question objectForKey:@"category"] isEqualToString:currentCategory] || [currentCategory isEqualToString:@"All categories"])) {
			currentQuestionIndex++;
			if (currentQuestionIndex == numQuestions) {
				doneWithAssessment = YES;
			}
			return question;
		} else if (i == currentQuestionIndex) {
			// go to the next question
		} else {
			i++;
		}
	}
	return nil;
}		

-(void) replaceTheScene
{
    
    if (deviceMode == IPAD) {
        
    } else {
        
        switch (screenToggle) {
            case INTRO:
                [[CCDirector sharedDirector] replaceScene: [iphoneIntroNode scene]];
                break;
            case MENU:
                [[CCDirector sharedDirector] replaceScene: [iphoneMenuScene scene]];
                break;
            case ABOUT:
                [[CCDirector sharedDirector] replaceScene: [iphoneAboutMenuScene scene]];
                break;
            case COUNTY:
                [[CCDirector sharedDirector] replaceScene: [iphoneCountyScene scene]];
                break;
            case SOCIAL:
                [[CCDirector sharedDirector] replaceScene: [iphoneSocialScene scene]];
                break;
            case QUESTIONS:
                [[CCDirector sharedDirector] replaceScene: [iphoneQuestionScene scene]];
                break;
            case CATEGORY:
                [[CCDirector sharedDirector] replaceScene: [iphoneACTCategoryScene scene]];
                break;
        }
        
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
 
#ifdef ANDROID
    [UIScreen mainScreen].currentMode =
    [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
#endif
    
    loadPDFInMenu = NO;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults stringForKey:@"selectedCounty"]) {
        printf("selectedCounty preference doesn't exist, setting to blank\n");
        [userDefaults setObject:@"" forKey:@"selectedCounty"];
        [userDefaults synchronize];
        selectedCounty = @"";
    } else {
        selectedCounty = [userDefaults stringForKey:@"selectedCounty"];
        NSLog(@"selectedCounty preference does exist, setting to %@",selectedCounty);
    }

	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		NSLog(@"iPad Idiom");
		deviceMode = IPAD;
	}
	else
		
#endif
		
	{
		NSLog(@"iPhone Idiom");
		deviceMode = IPHONE;
		
	}
    
    currentMenuItem = 0;

	// CCGLView creation
	// viewWithFrame: size of the OpenGL view. For full screen use [_window bounds]
	//  - Possible values: any CGRect
	// pixelFormat: Format of the render buffer. Use RGBA8 for better color precision (eg: gradients). But it takes more memory and it is slower
	//	- Possible values: kEAGLColorFormatRGBA8, kEAGLColorFormatRGB565
	// depthFormat: Use stencil if you plan to use CCClippingNode. Use Depth if you plan to use 3D effects, like CCCamera or CCNode#vertexZ
	//  - Possible values: 0, GL_DEPTH_COMPONENT24_OES, GL_DEPTH24_STENCIL8_OES
	// sharegroup: OpenGL sharegroup. Useful if you want to share the same OpenGL context between different threads
	//  - Possible values: nil, or any valid EAGLSharegroup group
	// multiSampling: Whether or not to enable multisampling
	//  - Possible values: YES, NO
	// numberOfSamples: Only valid if multisampling is enabled
	//  - Possible values: 0 to glGetIntegerv(GL_MAX_SAMPLES_APPLE)
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565
								   depthFormat:0
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];
	
	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
	
	director_.wantsFullScreenLayout = YES;
	
	// Display FSP and SPF
	//[director_ setDisplayStats:YES];
	
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];
	
	// attach the openglView to the director
	[director_ setView:glView];
	
	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
	//	[director setProjection:kCCDirectorProjection3D];
	
    // load questions
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"];
	
	questions = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
	// randomize questions
	[questions shuffle];
    
	currentQuestionIndex = 0;
	
	doneWithAssessment = NO;
	
    currentCategory = @"All categories";
	
	// figure out how many questions there are in the current category
	
	NSDictionary *question;
	printf("total questions: %i\n",[questions count]);
	
	numQuestions = 0;
	
	if ([currentCategory isEqualToString:@"All categories"]) {
		numQuestions = [questions count];
	} else {
		for (question in questions) {
			
			if ([[question objectForKey:@"category"] isEqualToString:currentCategory]) {
				numQuestions++;
			}
			
		}
	}
    
	printf("total questions in current category: %i\n",numQuestions);

    
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] ) {
		CCLOG(@"Retina Display Not supported");
        isRetina = NO;
    } else {
        isRetina = YES;
    }
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change this setting at any time.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"
	
	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
	
	// Create a Navigation Controller with the Director
	navController_ = [[MyNavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;

	// for rotation and other messages
	[director_ setDelegate:navController_];
	
	// set the Navigation Controller as the root view controller
	[window_ setRootViewController:navController_];
	
	// make main window visible
	[window_ makeKeyAndVisible];
	
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"click2.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"knock.caf"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"short_whoosh.caf"];

    [Flurry startSession:@"NWKS59N3N2PZBH2QGKP2"];
	
    return YES;
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];	
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

@end
