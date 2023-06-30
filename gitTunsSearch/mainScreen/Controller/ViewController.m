//
//  ViewController.m
//  gitTunsSearch
//
//  Created by Djinsolobzik on 23.06.2023.
//

#import "ViewController.h"
#import "LeftTableViewCell.h"
#import "RightTableViewCell.h"
#import "NetworkService.h"
#import "GitModel.h"
#import "TunesModel.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *searchSegmentedControl;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataModels;
@property (nonatomic, strong) NetworkService *networkService;
@property (nonatomic, strong) NSString *searchString;
@property (nonatomic, strong) UIImageView *expandedImageView;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation ViewController

// MARK: - Init

- (void)awakeFromNib {
    [super awakeFromNib];

    self.searchString = @"";
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.networkService = [[NetworkService alloc] init];
}

// MARK: - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setLayout];
    [self settingTableView];
    [self settingSearchBar];
    [self settingNavigationBar];
    [self hiddenKeyboard];

}

// MARK: - Private Methods

-(void)setLayout {
    self.tableView = [[UITableView alloc] init];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview: self.tableView];
    [NSLayoutConstraint activateConstraints:@[
           [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
           [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
           [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
           [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]

       ]];
}

-(void)settingTableView {

    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;
    [self.tableView registerClass: [LeftTableViewCell class] forCellReuseIdentifier: @"LeftImageCellIdentifier"];
    [self.tableView registerClass: [RightTableViewCell class] forCellReuseIdentifier: @"RightImageCellIdentifier"];
}

-(void)settingSearchBar {
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.showsCancelButton = NO;
    self.navigationItem.searchController = self.searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    self.navigationItem.searchController.hidesNavigationBarDuringPresentation = NO;

}

- (void)settingNavigationBar {
    if (@available(iOS 15, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = UIColor.whiteColor;
        self.navigationController.navigationBar.standardAppearance = appearance;
    }
}

- (void)hiddenKeyboard {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.tableView addGestureRecognizer:tapGesture];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    [self.searchController.searchBar resignFirstResponder];
}

- (void)showSearchAlert:(NSString *) message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Внимание!!!" message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"ОК" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];

    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)fetchGitHub {
    [self.networkService fetchRepositoriesForGitHub: _searchString completion: ^(NSArray *repositories, NSError *error) {
        if (error != nil) {
            [self showSearchAlert:error.localizedDescription];
            return;
        }
        self.dataModels = repositories;
        [self.tableView reloadData];
        if (self.dataModels.count == 0) {
            [self showSearchAlert:@"Поиск не дал результата"];
        }
    }];
}

- (void)fetchTunes {
    [self.networkService fetchRepositoriesForTunes: _searchString completion: ^(NSArray *models, NSError *error) {
        if (error != nil) {
            [self showSearchAlert:error.localizedDescription];
            return;
        }
        self.dataModels = models;
        [self.tableView reloadData];
        if (self.dataModels.count == 0) {
            [self showSearchAlert:@"Поиск не дал результата"];
        }
    }];
}

// MARK: - Switch search

- (IBAction)segmentSearchAction:(UISegmentedControl *)sender {
    NSInteger selectedSegmentIndex = sender.selectedSegmentIndex;
    switch (selectedSegmentIndex) {
        case 0:
            [self fetchGitHub];
            break;
        case 1:
            [self fetchTunes];
            break;
    }
}

// MARK: - SearchBarDelegate

- (void)searchBar: (UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    _searchString = searchText;
    if ([_searchString  isEqual: @""]) {
        self.dataModels = nil;
        [self.tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    switch (_searchSegmentedControl.selectedSegmentIndex) {
        case 0:
            [self fetchGitHub];
            break;

        case 1:
            [self fetchTunes];
            break;
    }
}

- (void)loadImageFromURL:(NSURL *)url completion:(void (^)(UIImage *image))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    });
}

- (void)imageTappedWithImage:(UIImage *)image {
    self.expandedImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.expandedImageView.image = image;
    self.expandedImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.expandedImageView.backgroundColor = [UIColor blackColor];
    self.expandedImageView.userInteractionEnabled = YES;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandedImageTapped:)];
    [self.expandedImageView addGestureRecognizer:tapGesture];

    self.expandedImageView.alpha = 0;
    [self.view addSubview:self.expandedImageView];

    [UIView animateWithDuration:0.4 animations:^{
        self.expandedImageView.alpha = 1;
    }];
}

- (void)expandedImageTapped:(UITapGestureRecognizer *)gesture {
    [UIView animateWithDuration:0.8 animations:^{
        self.expandedImageView.alpha = 0;
    } completion:^(BOOL finished) {
        if(finished) {
            [self.expandedImageView removeFromSuperview];
        }
    }];

}

//MARK: - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([_dataModels[0] isKindOfClass:[GitModel class]]) {
        GitModel *model = [[GitModel alloc] init];
        model = self.dataModels[indexPath.row];
        if (indexPath.row % 2 == 0) {
            LeftTableViewCell *cell = (LeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LeftImageCellIdentifier" forIndexPath:indexPath];
            cell.titleLabel.text = model.login;
            cell.linkLabel.text = model.url;
            NSURL *imageURL = [NSURL URLWithString: model.avatarUrl];
            [self loadImageFromURL:imageURL completion:^(UIImage *image) {
                cell.imageAvatar.image = image;

            }];
            cell.delegate = self;
            return cell;

        } else {
            RightTableViewCell *cell = (RightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RightImageCellIdentifier" forIndexPath:indexPath];
            cell.titleLabel.text = model.login;
            cell.linkLabel.text = model.url;
            NSURL *imageURL = [NSURL URLWithString: model.avatarUrl];
            [self loadImageFromURL:imageURL completion:^(UIImage *image) {
                cell.imageAvatar.image = image;

            }];

            cell.delegate = self;
            return cell;
        }
    } else {
        TunesModel *model = [[TunesModel alloc] init];
        model = self.dataModels[indexPath.row];
        if (indexPath.row % 2 == 0) {
            LeftTableViewCell *cell = (LeftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"LeftImageCellIdentifier" forIndexPath:indexPath];
            cell.titleLabel.text = model.trackName;
            cell.linkLabel.text = model.artistName;
            NSURL *imageURL = [NSURL URLWithString: model.artworkUrl100];
            [self loadImageFromURL:imageURL completion:^(UIImage *image) {
                cell.imageAvatar.image = image;

            }];

            cell.delegate = self;
            return cell;

        } else {
            RightTableViewCell *cell = (RightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RightImageCellIdentifier" forIndexPath:indexPath];
            cell.titleLabel.text = model.trackName;
            cell.linkLabel.text = model.artistName;
            NSURL *imageURL = [NSURL URLWithString: model.artworkUrl100];
            [self loadImageFromURL:imageURL completion:^(UIImage *image) {
                cell.imageAvatar.image = image;

            }];

            cell.delegate = self;
            return cell;
        }
    }

}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO; 
}

@end
