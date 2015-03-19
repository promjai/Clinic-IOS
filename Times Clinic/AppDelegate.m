//
//  AppDelegate.m
//  Times Clinic
//
//  Created by Pariwat Promjai on 2/27/2558 BE.
//  Copyright (c) 2558 Pariwat Promjai. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

BOOL newMedia;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (IS_OS_8_OR_LATER) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [self tabbar];
    
    return YES;
}

- (void)tabbar {
    
    self.update = [[PFUpdateViewController alloc] init];
    self.service = [[PFServiceViewController alloc] init];
    self.times = [[PFTimesViewController alloc] init];
    self.contact = [[PFContactViewController alloc] init];
    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    tbc.delegate = self;
    
    if(IS_WIDESCREEN) {
        
        self.update = [[PFUpdateViewController alloc] initWithNibName:@"PFUpdateViewController_Wide" bundle:nil];
        self.service = [[PFServiceViewController alloc] initWithNibName:@"PFServiceViewController_Wide" bundle:nil];
        self.times = [[PFTimesViewController alloc] initWithNibName:@"PFTimesViewController_Wide" bundle:nil];
        self.contact = [[PFContactViewController alloc] initWithNibName:@"PFContactViewController_Wide" bundle:nil];
        
    } else {

        self.update = [[PFUpdateViewController alloc] initWithNibName:@"PFUpdateViewController" bundle:nil];
        self.service = [[PFServiceViewController alloc] initWithNibName:@"PFServiceViewController" bundle:nil];
        self.times = [[PFTimesViewController alloc] initWithNibName:@"PFTimesViewController" bundle:nil];
        self.contact = [[PFContactViewController alloc] initWithNibName:@"PFContactViewController" bundle:nil];
        
    }
    
    /* Update */
    
    UINavigationController *navUpdate = [[UINavigationController alloc] initWithRootViewController:self.update];
    [[navUpdate navigationBar] setBarTintColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    [[navUpdate navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f], NSForegroundColorAttributeName, nil]];
    
    navUpdate.navigationBar.tintColor = [UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    
    [self.update.tabBarItem setTitle:@"ข่าวสาร"];
    
    [self.update.tabBarItem setImage:[UIImage imageNamed:@"ic_tab_update_off"]];
    [self.update.tabBarItem setSelectedImage:[UIImage imageNamed:@"ic_tab_update_on"]];
    
    /* Service */
    
    UINavigationController *navService = [[UINavigationController alloc] initWithRootViewController:self.service];
    [[navService navigationBar] setBarTintColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    [[navService navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f], NSForegroundColorAttributeName, nil]];
    
    navService.navigationBar.tintColor = [UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    
    [self.service.tabBarItem setTitle:@"บริการ"];
    
    [self.service.tabBarItem setImage:[UIImage imageNamed:@"ic_tab_service_off"]];
    [self.service.tabBarItem setSelectedImage:[UIImage imageNamed:@"ic_tab_service_on"]];
    
    /* Times */
    
    UINavigationController *navTimes = [[UINavigationController alloc] initWithRootViewController:self.times];
    [[navTimes navigationBar] setBarTintColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    [[navTimes navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f], NSForegroundColorAttributeName, nil]];
    
    navTimes.navigationBar.tintColor = [UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    
    [self.times.tabBarItem setTitle:@"บัตรคลินิก"];
    
    [self.times.tabBarItem setImage:[UIImage imageNamed:@"ic_tab_card_off"]];
    [self.times.tabBarItem setSelectedImage:[UIImage imageNamed:@"ic_tab_card_on"]];
    
    /* Contact */
    
    UINavigationController *navContact = [[UINavigationController alloc] initWithRootViewController:self.contact];
    [[navContact navigationBar] setBarTintColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    [[navContact navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f], NSForegroundColorAttributeName, nil]];
    
    navContact.navigationBar.tintColor = [UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    
    [self.contact.tabBarItem setTitle:@"ติดต่อ"];
    
    [self.contact.tabBarItem setImage:[UIImage imageNamed:@"ic_tab_contact_off"]];
    [self.contact.tabBarItem setSelectedImage:[UIImage imageNamed:@"ic_tab_contact_on"]];
    
    /* tabbar controller */
    
    self.update.delegate = self;
    self.service.delegate = self;
    self.times.delegate = self;
    self.contact.delegate = self;
    
    [tbc.tabBar setTintColor:[UIColor colorWithRed:0.0f/255.0f green:175.0f/255.0f blue:0.0f/255.0f alpha:1.0f]];
    [tbc setViewControllers:[NSArray arrayWithObjects:navUpdate ,navService ,navTimes ,navContact ,nil]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self.window setRootViewController:tbc];
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController  {
    if (tabBarController.selectedIndex == 0) {

        //[self.update viewDidLoad];
        
    } else if (tabBarController.selectedIndex == 1) {

        //[self.service viewDidLoad];
        
    } else if (tabBarController.selectedIndex == 2) {

        [self.times viewDidLoad];
        
    } else if (tabBarController.selectedIndex == 3) {

        //[self.contact viewDidLoad];
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:   (UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"My token is : %@", dt);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:dt forKey:@"deviceToken"];
    [defaults synchronize];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)PFImageViewController:(id)sender viewPicture:(UIImage *)image{
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    
    photo = [MWPhoto photoWithImage:image];
    [photos addObject:photo];
    
    enableGrid = NO;
    self.photos = photos;
    self.thumbs = thumbs;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = NO;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    [browser setCurrentPhotoIndex:0];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.window.rootViewController presentViewController:nc animated:YES completion:nil];
    
}

- (void)PFGalleryViewController:(id)sender sum:(NSMutableArray *)sum current:(NSString *)current {
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = NO;
    BOOL startOnGrid = NO;
    
    for (int i=0; i<[sum count]; i++) {
        NSString *t = [[NSString alloc] initWithFormat:@"%@",[sum objectAtIndex:i]];
        photo = [MWPhoto photoWithURL:[[NSURL alloc] initWithString:t]];
        [photos addObject:photo];
    }
    
    enableGrid = NO;
    self.photos = photos;
    self.thumbs = thumbs;
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = NO;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    [browser setCurrentPhotoIndex:[current intValue]];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.window.rootViewController presentViewController:nc animated:YES completion:nil];
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser DoneTappedDelegate:(NSUInteger)index {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

// In order to process the response you get from interacting with the Facebook login process,
// you need to override application:openURL:sourceApplication:annotation:
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

@end
