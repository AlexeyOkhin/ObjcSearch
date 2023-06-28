//
//  LeftTableViewCell.m
//  gitTunsSearch
//
//  Created by Djinsolobzik on 27.06.2023.
//

#import "LeftTableViewCell.h"
#import "ImageTappedDelegate.h"

@implementation LeftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.imageAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [self.contentView addSubview: self.imageAvatar];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, CGRectGetWidth(self.contentView.frame) - 30, 30)];
        [self.contentView addSubview: self.titleLabel];

        self.linkLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, CGRectGetWidth(self.contentView.frame) - 30, 40)];
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
