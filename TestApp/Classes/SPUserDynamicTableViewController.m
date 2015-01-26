//
//  SPUserDynamicTableViewController.m
//  SponsorPayTestApp
//
//  Created by Piotr  on 28/07/14.
//  Copyright (c) 2014 SponsorPay. All rights reserved.
//

#import "SPUserDynamicTableViewController.h"
#import "SPUserSettingsModel+Mapping.h"
#import "SPDoubleTextFieldCell.h"
#import "SPTextFieldCell.h"
#import "SponsorPaySDK.h"
#import "SPUser.h"

typedef NS_ENUM(NSUInteger, SPTextFieldCellType) {
    SPTextFieldCellTypeSingle,
    SPTextFieldCellTypeDouble,
};

static NSString * const SPCellSingleTextField   = @"Cell Text Field";
static NSString * const SPCellDoubleTextField   = @"Cell Double Text Field";

@interface SPUserDynamicTableViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray        *collection;
@property (nonatomic, assign) SPTextFieldCellType   cellType;
@property (nonatomic, assign) SPUserDataSection     section;
@property (nonatomic, assign) NSUInteger            dataType;

@end

@implementation SPUserDynamicTableViewController

#pragma mark - Life cycle

- (id)initWithStyle:(UITableViewStyle)style cellStructure:(NSIndexPath *)indexPath {
    self = [super initWithStyle:style];
    if (self) {

        _section    = (NSUInteger)indexPath.section;
        _dataType   = 1 << indexPath.row;

        if (_section == SPUserDataSectionExtra && _dataType & SPBasicDataTypeInterests) {
            self.cellType = SPTextFieldCellTypeSingle;
        } else if (_section == SPUserDataSectionExtra && _dataType & SPExtraDataTypeCustomParameters) {
            self.cellType = SPTextFieldCellTypeDouble;
        }

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Register 2 cells - Single text field and double text field
    UINib *nib = [UINib nibWithNibName:@"SPTextFieldCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:SPCellSingleTextField];

    nib = [UINib nibWithNibName:@"SPDoubleTextFieldCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:SPCellDoubleTextField];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self
                                                                                 action:@selector(addCell:)];
    addButton.tintColor = [UIColor colorWithRed:0 green:182.f/255.f blue:1 alpha:1];
    self.navigationItem.rightBarButtonItem = addButton;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // Add parameters to user
    if (self.section == SPUserDataSectionBasic) {
        if (self.dataType & SPBasicDataTypeInterests) {
            [[SponsorPaySDK instance].user setInterests:[self.collection copy]];
        }

    } else if (self.section == SPUserDataSectionExtra) {
        if (self.dataType & SPExtraDataTypeCustomParameters) {
            [[SponsorPaySDK instance].user setCustomParameters:self.customParameters];
        }
    }
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.collection count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // There are 2 type of cells available to display - cell with 1 entry field and cell for key-value entry field
    // They all depends what data type is a requester
    // If requester is `SPBasicDataTypeInterests` then 1 entry field is displayed
    // If requester however is `SPExtraDataTypeCustomParameters` then 2 field are needed for key value combination

    if (self.cellType == SPTextFieldCellTypeSingle) {

        SPTextFieldCell *cell = (SPTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:SPCellSingleTextField
                                                                  forIndexPath:indexPath];

        NSString *value = [self.collection objectAtIndex:indexPath.row];
        if ([value length]) {
            cell.textField.text = value;
        } else {
            cell.textField.placeholder = @"Value";
        }
        cell.textField.delegate = self;

        return cell;

    } else if (self.cellType == SPTextFieldCellTypeDouble){

        SPDoubleTextFieldCell *cell = (SPDoubleTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:SPCellDoubleTextField
                                                                        forIndexPath:indexPath];

        NSMutableDictionary *params = [self.collection objectAtIndex:indexPath.row];
        NSString *key               = [[params allKeys] lastObject];
        NSString *obj               = [params objectForKey:key];
        if ([key length] && [obj length]) {
            cell.keyTextField.text      = key;
            cell.valueTextField.text    = obj;
        } else {
            // Clear text anyway
            // The cells are re-usable and they may contain text from previous assignment
            cell.keyTextField.text          = nil;
            cell.valueTextField.text        = nil;
            cell.keyTextField.placeholder   = @"Key";
            cell.valueTextField.placeholder = @"Value";
        }

        cell.keyTextField.delegate      = self;
        cell.valueTextField.delegate    = self;

        return cell;
    }

    return nil;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Update data source first
        [self.collection removeObjectAtIndex:indexPath.row];

        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {

    SPBaseCell *cell        = (SPBaseCell *)[textField findSuperViewWithClass:[SPBaseCell class]];
    NSIndexPath *indexPath  = [self.tableView indexPathForCell:cell];

    if (self.cellType == SPTextFieldCellTypeSingle) {

        if ([self.collection count] - 1 > indexPath.row) {
            SPTextFieldCell *nextCell = (SPTextFieldCell *)[self nextCellOfIndexPath:indexPath];
            [nextCell.textField becomeFirstResponder];
        } else {
            [((SPTextFieldCell *)cell).textField resignFirstResponder];
        }

    } else if (self.cellType == SPTextFieldCellTypeDouble){

        SPDoubleTextFieldCell *doubleTextField = (SPDoubleTextFieldCell *)cell;
        if (textField == doubleTextField.keyTextField) {
            [doubleTextField.valueTextField becomeFirstResponder];
            return YES;
        }

        SPDoubleTextFieldCell *nextCell = (SPDoubleTextFieldCell *)[self nextCellOfIndexPath:indexPath];
        [nextCell.keyTextField becomeFirstResponder];

    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *replacement   = [textField.text stringByReplacingCharactersInRange:range withString:string];
    SPBaseCell *cell        = (SPBaseCell *)[textField findSuperViewWithClass:[SPBaseCell class]];
    NSIndexPath *indexPath  = [self.tableView indexPathForCell:cell];

    id obj = [self.collection objectAtIndex:(NSUInteger)indexPath.row];

    if ([obj isKindOfClass:[NSString class]]) {
        NSMutableString *value  = (NSMutableString *)obj;
        value.string            = replacement;
    } else if ([obj isKindOfClass:[NSDictionary class]]) {

        // Extract all existing values and keys from dictionary
        // It is necessary to do so in order to keep data synchronized and avoid any duplications
        // We will update extracted data and insert to mutable dictionary,
        // but before inserting we will clear mutable dictionary

        NSString *key   = [[(NSMutableDictionary *)obj allKeys] lastObject];
        NSString *value = [(NSMutableDictionary *)obj objectForKey:key];

        if (textField == [(SPDoubleTextFieldCell *)cell keyTextField]) {
            key = replacement;
        } else {
            value = replacement;
        }

        // The value or key may happen to be nil.
        // As setting nil is not allowed, pointer to empty placeholder is needed
        if (![key length])      key = @"";
        if (![value length])    value = @"";

        [(NSMutableDictionary *)obj removeAllObjects];
        [(NSMutableDictionary *)obj setObject:value forKey:key];
    }

    return YES;
}

#pragma mark - Private

- (SPBaseCell *)nextCellOfIndexPath:(NSIndexPath *)indexPath {

    const NSUInteger i[2]       = {0, indexPath.row+1};
    NSIndexPath *nextIndexPath  = [NSIndexPath indexPathWithIndexes:i length:2];
    SPBaseCell *nextCell        = (SPBaseCell *)[self.tableView cellForRowAtIndexPath:nextIndexPath];

    return nextCell;
}

- (NSDictionary *)customParameters {
    if (self.cellType == SPTextFieldCellTypeDouble) {
        __block NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
        for (NSMutableDictionary *entity in self.collection) {
            [entity enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
                [mutableDict setObject:value forKey:key];
            }];
        }
        return [mutableDict copy];
    }
    return nil;
}


#pragma mark - Actions

-(IBAction)addCell:(id)sender {

    if (self.cellType == SPTextFieldCellTypeSingle) {
        NSMutableString *mutableString = [NSMutableString string];
        [self.collection addObject:mutableString];
    } else if (self.cellType == SPTextFieldCellTypeDouble) {
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
        [self.collection addObject:mutableDict];
    }

    const NSUInteger i[2] = {0, [self.collection count]-1};
    NSIndexPath *indexPath = [NSIndexPath indexPathWithIndexes:i length:2];

    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];

    // Become first responder
    // When user adds new cell it is nice to have him focus on new cell

    if (self.cellType == SPTextFieldCellTypeSingle) {

        SPTextFieldCell *nextCell = (SPTextFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [nextCell.textField becomeFirstResponder];

    } else if (self.cellType == SPTextFieldCellTypeDouble){

        SPDoubleTextFieldCell *doubleTextField = (SPDoubleTextFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [doubleTextField.keyTextField becomeFirstResponder];
        
    }
}

#pragma mark - Accessors 

-(NSMutableArray *)collection {
    if (!_collection) {
        _collection = [NSMutableArray array];

        // Data already exists?
        SPUser *user = [SponsorPaySDK instance].user;
        if (self.cellType == SPTextFieldCellTypeDouble) {
            NSDictionary *params = [user customParameters];
            [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[key] = obj;
                [_collection addObject:dict];
            }];
        } else if (self.cellType == SPTextFieldCellTypeSingle) {
            [_collection addObjectsFromArray:[user interests]];
        }

    }
    return _collection;
}

#pragma mark - Housekeeping

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
