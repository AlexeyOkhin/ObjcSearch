//
//  RightTableViewCell.m
//  gitTunsSearch
//
//  Created by Djinsolobzik on 28.06.2023.
//

#import "RightTableViewCell.h"
#import "ImageTappedDelegate.h"

@implementation RightTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(300, 0, 80, 80)];
        [self.contentView addSubview: self.imageAvatar];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.contentView.frame) - 90, 30)];
        [self.contentView addSubview: self.titleLabel];

        self.linkLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, CGRectGetWidth(self.contentView.frame) - 90, 40)];
        self.linkLabel.numberOfLines = 2;
        [self.contentView addSubview: self.linkLabel];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        [self.imageAvatar addGestureRecognizer:tapGesture];
        self.imageAvatar.userInteractionEnabled = YES;
    }
    return self;
}

- (void)imageTapped:(UITapGestureRecognizer *)gesture {
    UIImageView *tappedImageView = (UIImageView *)gesture.view;
    [self.delegate imageTappedWithImage:tappedImageView.image];
}

@end
