//
//  ReadGoogle.h
//  TextScanner
//
//  Created by manhhung on 8/17/17.
//  Copyright © 2017 evict. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ReadGoogle : NSObject
- (NSURL *) playSoundSource: (NSString * )text and: (NSString *) codeLang;
- (void) playSoundTarget: (NSString * )text and: (NSString *) codeLang;
- (void)  stopSound;
@end
