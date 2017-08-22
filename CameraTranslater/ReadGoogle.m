//
//  ReadGoogle.m
//  TextScanner
//
//  Created by manhhung on 8/17/17.
//  Copyright © 2017 evict. All rights reserved.
//

#import "ReadGoogle.h"
#import <AVFoundation/AVFoundation.h>



@interface ReadGoogle () <AVAudioPlayerDelegate>
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end


@implementation ReadGoogle
#pragma mark - Action methods
SystemSoundID soundID;
- (NSURL *) playSoundSource: (NSString * )text and: (NSString *) codeLang {
 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"source.mp3"];
    
//    NSString *text = @"Người theo hương hoa mây mù giăng lối. Làn sương khói phôi phai đưa bước ai xa rồi.  Đơn côi mình ta vấn vương hồi ức trong men say chiều mưa buồn. Ngăn giọt lệ ngừng khiến khoé mi sầu bi. "; //@"You are one chromosome away from being a potato.";
    NSString *urlString = [NSString stringWithFormat:@"http://translate.google.com/translate_tts?tl=%@&q=%@&client=tw-ob",codeLang, text];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@", url);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url] ;
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1) Gecko/20100101 Firefox/4.0.1" forHTTPHeaderField:@"User-Agent"];
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    NSLog(@"%@", error);
    [data writeToFile:path atomically:YES];
    

    NSURL *url2 = [NSURL fileURLWithPath:path];
//    NSLog(@"%@", url2);
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url2, &soundID);
//    AudioServicesPlaySystemSound (soundID);
    return url2;
    
  
}

- (void) playSoundTarget: (NSString * )text and: (NSString *) codeLang {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"target.mp3"];
    
    //    NSString *text = @"Người theo hương hoa mây mù giăng lối. Làn sương khói phôi phai đưa bước ai xa rồi.  Đơn côi mình ta vấn vương hồi ức trong men say chiều mưa buồn. Ngăn giọt lệ ngừng khiến khoé mi sầu bi. "; //@"You are one chromosome away from being a potato.";
    NSString *urlString = [NSString stringWithFormat:@"http://translate.google.com/translate_tts?tl=%@&q=%@&client=tw-ob",codeLang, text];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@", url);
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url] ;
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:2.0.1) Gecko/20100101 Firefox/4.0.1" forHTTPHeaderField:@"User-Agent"];
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    NSLog(@"%@", error);
    [data writeToFile:path atomically:YES];
    
    
    NSURL *url2 = [NSURL fileURLWithPath:path];
    NSLog(@"%@", url2);
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url2, &soundID);
//    AudioServicesPlaySystemSound (soundID);
    
    [self playAudioFromURL:url2];
    
}


- (void)  stopSound {
    AudioServicesDisposeSystemSoundID(soundID);
}

- (void) btnStopTapped {
    [self stopAudioPlayer];
    
}

- (void) btnDoneTapped {
    
}

- (void) btnLanguageTapped {
    
}

#pragma mark - Audio methods

- (void) initAudioSession {
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
    
    NSError *activationError = nil;
    [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
}

- (void) playAudioFromURL: (NSURL*) url {
    NSLog(@"%@", url);
    NSError *error = NULL;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

- (void) stopAudioPlayer {
    self.audioPlayer.delegate = nil;
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}

#pragma mark - AVAudioPlayerDelegate implementation

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self btnStopTapped];
}

#pragma mark - UITextViewDelegate implementation


#pragma mark - File methods

- (NSURL*) fileURLWithFileName: (NSString*) fileName {
    NSURL *documentDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentDirectory URLByAppendingPathComponent:fileName];
}



@end
