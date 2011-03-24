//
//  ESFlowLayoutView.h
//  es_ios_utils
//
//  Created by Peter DeWeese on 3/23/11.
//  Copyright 2011 Eye Street Research, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

// Lays out from left to right like text, wrapping whenever the width is met.
// Resizes vertically automatically to match content.
@interface ESFlowLayoutView : UIView {
    double padding;
}

@property (nonatomic, assign) double padding;

@end
