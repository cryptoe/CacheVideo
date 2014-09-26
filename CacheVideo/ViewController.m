//
//  ViewController.m
//  CacheVideo
//
//  Created by Karan Kumar on 23/09/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "ASIHTTPRequest.h"
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController ()

@end

@implementation ViewController
@synthesize webView;
@synthesize progressBar=_progressBar, player=_player;
@synthesize DownloadView=_DownloadView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.view addSubview:webView];
    self.webView.delegate = self;
    _DownloadView.hidden=YES;
    [self.webView addSubview:_DownloadView];
    [    self.view bringSubviewToFront:_DownloadView];
    // _progressBar.hidden=YES;
    [_progressBar setTransform:CGAffineTransformMakeScale(2.0, 10.0)];
    
    NSURL *myUrl=[NSURL URLWithString:@"http://wedup.net/index6.php?usernamePrefix=demo&s=4F449517-0085-4F84-BB27-DF09A395D4FB#videos"];
    
    NSURLRequest *myRequest=[NSURLRequest requestWithURL:myUrl];
    [webView loadRequest:myRequest];
    
    NSLog(@"here");
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{   NSURL *url = request.URL;
    NSLog(@"printing url");
    NSLog(url.description);
    if([url.pathExtension isEqual:@"mp4"])
    {
        NSArray *stringArray=[url.description componentsSeparatedByString:@"/"];
        NSLog([[stringArray lastObject] description]);
        NSString *fileName=[[stringArray lastObject]description];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *folderPath=[documentsDirectory stringByAppendingString:@"/videos/"];
        NSString *dataPath=[folderPath stringByAppendingString:fileName];
        
        if(![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        {
            NSLog(@"dont have dir creating it");
            [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
        }
        
        if([[NSFileManager defaultManager] fileExistsAtPath:folderPath])
        {NSLog(@"folder is already created");
        }
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        {NSLog(@"Dont have file");
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            _fName=dataPath;
            [request setDownloadDestinationPath:[NSString stringWithFormat:@"%@",dataPath]]; //use the path from earlier
            [request setDelegate:self];
            [request setDownloadProgressDelegate:_progressBar];
            [request startAsynchronous];
            _DownloadView.hidden=NO;
            return NO;
            
        }
        else
        {
            NSLog(@"have mp4\n");
            _player =  [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:dataPath]];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_player];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(doneButtonClick:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:_player];
            [[_player view] setFrame:[self.view bounds]]; // Frame must match parent view
            [self.view addSubview:[_player view]];
            _player.fullscreen = NO;
            [_player play];
            return NO;
        }
    }
    
    NSLog(@"here in load");
    return YES;
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    _DownloadView.hidden=YES;
    NSLog(@"have mp4\n");
    _player =  [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:_fName]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doneButtonClick:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    [[_player view] setFrame:[self.view bounds]]; // Frame must match parent view
    [self.view addSubview:[_player view]];
    _player.fullscreen = NO;
    [_player play];
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog([request error].description);
}
-(void)doneButtonClick:(NSNotification*)aNotification{
    [_player stop];
    [_player.view removeFromSuperview];
    
}
- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    
    MPMoviePlayerController *player = [notification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
}

@end
