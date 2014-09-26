//
//  ViewController.h
//  CacheVideo
//
//  Created by Karan Kumar on 23/09/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController : UIViewController<UIWebViewDelegate,MPMediaPlayback>
{
    NSString *_fName;
}
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong)MPMoviePlayerController *player;
@property (weak, nonatomic) IBOutlet UIView *DownloadView;

@end
