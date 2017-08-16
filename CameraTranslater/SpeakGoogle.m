//
//  SpeakGoogle.m
//  CameraTranslater
//
//  Created by manhhung on 8/16/17.
//  Copyright © 2017 manhhung. All rights reserved.
//

#import "SpeakGoogle.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>


@implementation SpeakGoogle

- (void) speakGoogle {
    NSLog(@"SomeMethod Ran");
    NSString *urlString = [NSString stringWithFormat:@"http://www.translate.google.com/translate_tts?tl=en&q=hello"];
    NSURL *reqUrl = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:reqUrl];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1) Gecko/20100101 Firefox/4.0.1" forHTTPHeaderField:@"User-Agent"];
    
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData* audioData = [NSURLConnection sendSynchronousRequest:request returningResponse: &response error: &error];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *audioPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"playFile.mp3"]; [audioData writeToFile:audioPath atomically:YES];
    
    NSError *err;
    if ([[NSFileManager defaultManager] fileExistsAtPath:audioPath])
    {
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioPath] error:&err];
        player.volume = 0.8f;
        [player prepareToPlay];
        [player setNumberOfLoops:0];
        [player play];
    }
}

@end
