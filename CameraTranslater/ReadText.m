//
//  ReadText.m
//  CameraTranslater
//
//  Created by manhhung on 8/16/17.
//  Copyright © 2017 manhhung. All rights reserved.
//

#import "ReadText.h"
#import <AVFoundation/AVFoundation.h>

#import "GoogleTTSAPI.h"


@interface ReadText () <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@end

@implementation ReadText

- (void) playAudioFromURL: (NSURL*) url {
    NSError *error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    if (error != Nil) {
        NSLog(@"%@", error.localizedDescription);
    }
}

- (void) stopAudioPlayer {
    self.audioPlayer.delegate = nil;
    [self.audioPlayer stop];
    self.audioPlayer = nil;
}

- (NSURL*) fileURLWithFileName: (NSString*) fileName {
    NSURL *documentDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSLog(@"%@", [documentDirectory URLByAppendingPathComponent:fileName]);
    return [documentDirectory URLByAppendingPathComponent:fileName];
}

- (void) btnPlayTapped {
    
    [GoogleTTSAPI textToSpeechWithText:@"Hello I am teacher" andLanguage:@"eng" success:^(NSData *data) {
        NSURL *audioFileURL = [self fileURLWithFileName:@"converted.mp3"];
        NSLog(@"%@", audioFileURL);
        [data writeToURL:audioFileURL atomically:YES];
        [self playAudioFromURL:audioFileURL];
        printf("success");
       
    } failure:^(NSError *error) {
        printf("error !");
    }];
}



@end
