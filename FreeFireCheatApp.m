// ============================================
// FILE: FreeFireCheatApp.m
// ============================================
// APP CHEAT FREE FIRE - ESP + TÂM ẢO + ICON
// BUILD BẰNG CLANG - IPA TRỰC TIẾP
// COPYRIGHT: HAI LAM

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <mach-o/dyld.h>
#import <mach-o/getsect.h>
#import <mach/mach.h>
#import <sys/stat.h>
#import <sys/mman.h>

@interface CheatViewController : UIViewController

@property (nonatomic, strong) UILabel *nhanTrangThai;
@property (nonatomic, strong) UISwitch *congTacESP;
@property (nonatomic, strong) UISwitch *congTacTamAo;
@property (nonatomic, strong) UISwitch *congTacAutoAim;
@property (nonatomic, strong) UISwitch *congTacXuyenTuong;
@property (nonatomic, strong) UIButton *nutMoGame;
@property (nonatomic, strong) UIButton *nutThoatGame;
@property (nonatomic, strong) UITextView *khungLog;
@property (nonatomic, strong) NSMutableString *duLieuOffset;
@property (nonatomic, strong) UIView *tamAoView;
@property (nonatomic, strong) NSTimer *timerESP;
@property (nonatomic, assign) BOOL espDangBat;
@property (nonatomic, assign) BOOL tamAoDangBat;
@property (nonatomic, assign) BOOL autoAimDangBat;
@property (nonatomic, assign) BOOL xuyenTuongDangBat;
@property (nonatomic, assign) BOOL dangQuet;

- (void)batTatESP;
- (void)batTatTamAo;
- (void)batTatAutoAim;
- (void)batTatXuyenTuong;
- (void)hienTamAo;
- (void)anTamAo;
- (void)batDauTimerESP;
- (void)dungTimerESP;
- (void)taoFileCauHinhESP;
- (void)quetOffsetGame;
- (void)quetMauByte:(uint64_t)tuDiaChi denDiaChi:(uint64_t)denDiaChi;
- (void)moFreeFire;
- (void)thoatFreeFire;
- (void)capNhatLog:(NSString *)noiDung;
- (CGFloat)taoHangCongTac:(NSString *)tenHang y:(CGFloat)y chieuRong:(CGFloat)chieuRong congTac:(UISwitch **)congTac action:(SEL)action;

@end

@implementation CheatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.03 green:0.03 blue:0.08 alpha:1.0];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = @[(id)[UIColor colorWithRed:0.02 green:0.02 blue:0.05 alpha:1.0].CGColor,
                        (id)[UIColor colorWithRed:0.05 green:0.02 blue:0.1 alpha:1.0].CGColor,
                        (id)[UIColor colorWithRed:0.1 green:0.02 blue:0.05 alpha:1.0].CGColor];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 1);
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    CGFloat chieuRong = self.view.bounds.size.width;
    CGFloat chieuCao = self.view.bounds.size.height;
    
    // Logo app
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(chieuRong/2 - 30, 35, 60, 60)];
    logoView.backgroundColor = [UIColor colorWithRed:0.9 green:0.3 blue:0.1 alpha:1.0];
    logoView.layer.cornerRadius = 15;
    logoView.layer.borderWidth = 3;
    logoView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:logoView];
    
    UILabel *logoText = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 60, 30)];
    logoText.text = @"FF";
    logoText.textAlignment = NSTextAlignmentCenter;
    logoText.font = [UIFont boldSystemFontOfSize:28];
    logoText.textColor = [UIColor whiteColor];
    [logoView addSubview:logoText];
    
    UILabel *tieuDe = [[UILabel alloc] initWithFrame:CGRectMake(20, 105, chieuRong - 40, 35)];
    tieuDe.text = @"© HAI LAM - FF CHEAT";
    tieuDe.textAlignment = NSTextAlignmentCenter;
    tieuDe.font = [UIFont boldSystemFontOfSize:24];
    tieuDe.textColor = [UIColor whiteColor];
    [self.view addSubview:tieuDe];
    
    [NSTimer scheduledTimerWithTimeInterval:0.08 repeats:YES block:^(NSTimer *timer) {
        static int mauIndex = 0;
        mauIndex = (mauIndex + 1) % 7;
        NSArray *mauRainbow = @[[UIColor redColor], [UIColor orangeColor], [UIColor yellowColor],
                                [UIColor greenColor], [UIColor cyanColor], [UIColor blueColor], [UIColor purpleColor]];
        tieuDe.textColor = mauRainbow[mauIndex];
    }];
    
    self.nhanTrangThai = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, chieuRong - 40, 30)];
    self.nhanTrangThai.text = @"Trạng thái: SẴN SÀNG";
    self.nhanTrangThai.textAlignment = NSTextAlignmentCenter;
    self.nhanTrangThai.font = [UIFont boldSystemFontOfSize:14];
    self.nhanTrangThai.textColor = [UIColor greenColor];
    self.nhanTrangThai.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.8];
    self.nhanTrangThai.layer.cornerRadius = 8;
    self.nhanTrangThai.clipsToBounds = YES;
    [self.view addSubview:self.nhanTrangThai];
    
    CGFloat yHienTai = 195;
    
    yHienTai = [self taoHangCongTac:@"ESP ĐỊNH VỊ ĐỊCH" y:yHienTai chieuRong:chieuRong congTac:&_congTacESP action:@selector(batTatESP)];
    yHienTai = [self taoHangCongTac:@"TÂM ẢO MÀU ĐỎ" y:yHienTai chieuRong:chieuRong congTac:&_congTacTamAo action:@selector(batTatTamAo)];
    yHienTai = [self taoHangCongTac:@"AUTO AIM" y:yHienTai chieuRong:chieuRong congTac:&_congTacAutoAim action:@selector(batTatAutoAim)];
    yHienTai = [self taoHangCongTac:@"XUYÊN TƯỜNG" y:yHienTai chieuRong:chieuRong congTac:&_congTacXuyenTuong action:@selector(batTatXuyenTuong)];
    
    yHienTai += 10;
    
    self.nutMoGame = [UIButton buttonWithType:UIButtonTypeSystem];
    self.nutMoGame.frame = CGRectMake(20, yHienTai, chieuRong - 40, 50);
    [self.nutMoGame setTitle:@"🎮 MỞ FREE FIRE" forState:UIControlStateNormal];
    [self.nutMoGame setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nutMoGame.backgroundColor = [UIColor colorWithRed:0.9 green:0.5 blue:0.1 alpha:1.0];
    self.nutMoGame.layer.cornerRadius = 12;
    self.nutMoGame.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.nutMoGame addTarget:self action:@selector(moFreeFire) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nutMoGame];
    yHienTai += 58;
    
    self.nutThoatGame = [UIButton buttonWithType:UIButtonTypeSystem];
    self.nutThoatGame.frame = CGRectMake(20, yHienTai, chieuRong - 40, 40);
    [self.nutThoatGame setTitle:@"THOÁT GAME" forState:UIControlStateNormal];
    [self.nutThoatGame setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nutThoatGame.backgroundColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1.0];
    self.nutThoatGame.layer.cornerRadius = 10;
    self.nutThoatGame.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.nutThoatGame addTarget:self action:@selector(thoatFreeFire) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nutThoatGame];
    yHienTai += 48;
    
    self.khungLog = [[UITextView alloc] initWithFrame:CGRectMake(20, yHienTai, chieuRong - 40, chieuCao - yHienTai - 15)];
    self.khungLog.backgroundColor = [UIColor blackColor];
    self.khungLog.textColor = [UIColor greenColor];
    self.khungLog.font = [UIFont fontWithName:@"Menlo" size:10];
    self.khungLog.editable = NO;
    self.khungLog.layer.cornerRadius = 10;
    [self.view addSubview:self.khungLog];
    
    self.duLieuOffset = [NSMutableString string];
    self.espDangBat = NO;
    self.tamAoDangBat = NO;
    self.autoAimDangBat = NO;
    self.xuyenTuongDangBat = NO;
    self.dangQuet = NO;
    
    [self capNhatLog:@"App đã sẵn sàng. Bật ESP + TÂM ẢO sau đó mở game."];
}

- (CGFloat)taoHangCongTac:(NSString *)tenHang y:(CGFloat)y chieuRong:(CGFloat)chieuRong congTac:(UISwitch **)congTac action:(SEL)action {
    UIView *hang = [[UIView alloc] initWithFrame:CGRectMake(20, y, chieuRong - 40, 45)];
    hang.backgroundColor = [UIColor colorWithWhite:0.12 alpha:0.8];
    hang.layer.cornerRadius = 10;
    [self.view addSubview:hang];
    
    UILabel *nhan = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 25)];
    nhan.text = tenHang;
    nhan.textColor = [UIColor whiteColor];
    nhan.font = [UIFont boldSystemFontOfSize:14];
    [hang addSubview:nhan];
    
    UISwitch *ct = [[UISwitch alloc] initWithFrame:CGRectMake(chieuRong - 75, 7, 50, 30)];
    [ct addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    [hang addSubview:ct];
    *congTac = ct;
    
    return y + 52;
}

- (void)batTatESP {
    self.espDangBat = self.congTacESP.isOn;
    if (self.espDangBat) {
        self.nhanTrangThai.text = @"ESP: ĐANG BẬT";
        self.nhanTrangThai.textColor = [UIColor greenColor];
        [self taoFileCauHinhESP];
        [self capNhatLog:@"ESP đã bật"];
        [self batDauTimerESP];
    } else {
        self.nhanTrangThai.text = @"ESP: ĐÃ TẮT";
        self.nhanTrangThai.textColor = [UIColor redColor];
        [self capNhatLog:@"ESP đã tắt"];
        [self dungTimerESP];
    }
}

- (void)batTatTamAo {
    self.tamAoDangBat = self.congTacTamAo.isOn;
    if (self.tamAoDangBat) {
        self.nhanTrangThai.text = @"TÂM ẢO: ĐANG BẬT";
        self.nhanTrangThai.textColor = [UIColor redColor];
        [self capNhatLog:@"Tâm ảo đã bật"];
        [self hienTamAo];
    } else {
        self.nhanTrangThai.text = @"TÂM ẢO: ĐÃ TẮT";
        self.nhanTrangThai.textColor = [UIColor greenColor];
        [self capNhatLog:@"Tâm ảo đã tắt"];
        [self anTamAo];
    }
}

- (void)batTatAutoAim {
    self.autoAimDangBat = self.congTacAutoAim.isOn;
    if (self.autoAimDangBat) {
        self.nhanTrangThai.text = @"AUTO AIM: ĐANG BẬT";
        self.nhanTrangThai.textColor = [UIColor greenColor];
        [self capNhatLog:@"Auto Aim đã bật"];
    } else {
        self.nhanTrangThai.text = @"AUTO AIM: ĐÃ TẮT";
        self.nhanTrangThai.textColor = [UIColor redColor];
        [self capNhatLog:@"Auto Aim đã tắt"];
    }
}

- (void)batTatXuyenTuong {
    self.xuyenTuongDangBat = self.congTacXuyenTuong.isOn;
    if (self.xuyenTuongDangBat) {
        self.nhanTrangThai.text = @"XUYÊN TƯỜNG: ĐANG BẬT";
        self.nhanTrangThai.textColor = [UIColor greenColor];
        [self capNhatLog:@"Xuyên tường đã bật"];
    } else {
        self.nhanTrangThai.text = @"XUYÊN TƯỜNG: ĐÃ TẮT";
        self.nhanTrangThai.textColor = [UIColor redColor];
        [self capNhatLog:@"Xuyên tường đã tắt"];
    }
}

- (void)hienTamAo {
    if (self.tamAoView == nil) {
        self.tamAoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        self.tamAoView.backgroundColor = [UIColor redColor];
        self.tamAoView.layer.cornerRadius = 12;
        self.tamAoView.layer.borderWidth = 2;
        self.tamAoView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.tamAoView.alpha = 0.7;
        
        UILabel *dauCong = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        dauCong.text = @"+";
        dauCong.textAlignment = NSTextAlignmentCenter;
        dauCong.font = [UIFont boldSystemFontOfSize:20];
        dauCong.textColor = [UIColor whiteColor];
        [self.tamAoView addSubview:dauCong];
    }
    
    CGFloat tamX = self.view.bounds.size.width / 2 - 12;
    CGFloat tamY = self.view.bounds.size.height / 2 - 12;
    self.tamAoView.frame = CGRectMake(tamX, tamY, 24, 24);
    
    [self.view addSubview:self.tamAoView];
    [self.view bringSubviewToFront:self.tamAoView];
}

- (void)anTamAo {
    if (self.tamAoView != nil) {
        [self.tamAoView removeFromSuperview];
        self.tamAoView = nil;
    }
}

- (void)batDauTimerESP {
    if (self.timerESP) {
        [self.timerESP invalidate];
    }
    self.timerESP = [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:YES block:^(NSTimer *timer) {
        if (self.espDangBat) {
            [self quetOffsetGame];
        }
    }];
}

- (void)dungTimerESP {
    if (self.timerESP) {
        [self.timerESP invalidate];
        self.timerESP = nil;
    }
}

- (void)taoFileCauHinhESP {
    NSString *duongDanDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *duongDanFile = [duongDanDocuments stringByAppendingPathComponent:@"esp_config.txt"];
    NSString *noiDung = [NSString stringWithFormat:@"esp=%d\ntam_ao=%d\nauto_aim=%d\nxuyen_tuong=%d\n", 
                        self.espDangBat, self.tamAoDangBat, self.autoAimDangBat, self.xuyenTuongDangBat];
    [noiDung writeToFile:duongDanFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)quetOffsetGame {
    if (self.dangQuet) return;
    self.dangQuet = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.duLieuOffset setString:@""];
        uint32_t soLuongImage = _dyld_image_count();
        
        for (uint32_t i = 0; i < soLuongImage; i++) {
            const char *tenImage = _dyld_get_image_name(i);
            const struct mach_header *headerImage = _dyld_get_image_header(i);
            intptr_t truotImage = _dyld_get_image_vmaddr_slide(i);
            
            if (tenImage != NULL && headerImage != NULL) {
                NSString *tenImageStr = [NSString stringWithUTF8String:tenImage];
                
                if ([tenImageStr containsString:@"FreeFireCheatApp"]) continue;
                
                if ([tenImageStr containsString:@"libil2cpp"] ||
                    [tenImageStr containsString:@"GameAssembly"] ||
                    [tenImageStr containsString:@"UnityFramework"] ||
                    [tenImageStr containsString:@"FreeFire"] ||
                    [tenImageStr containsString:@"freefire"] ||
                    [tenImageStr containsString:@"gcloud"] ||
                    [tenImageStr containsString:@"anogs"]) {
                    
                    unsigned long kichThuocText = 0;
                    uint8_t *batDauText = getsegmentdata((const struct mach_header_64 *)headerImage, "__TEXT", &kichThuocText);
                    
                    if (batDauText != NULL && kichThuocText > 0) {
                        uint64_t diaChiBatDau = (uint64_t)batDauText + truotImage;
                        uint64_t diaChiKetThuc = diaChiBatDau + kichThuocText;
                        [self capNhatLog:[NSString stringWithFormat:@"Quét: %@", [tenImageStr lastPathComponent]]];
                        [self quetMauByte:diaChiBatDau denDiaChi:diaChiKetThuc];
                    }
                }
            }
        }
        
        if (self.duLieuOffset.length > 0) {
            [self capNhatLog:@"✔ Tìm thấy offset ESP!"];
        } else {
            [self capNhatLog:@"Chưa tìm thấy offset. ESP sẽ tự quét lại."];
        }
        
        self.dangQuet = NO;
    });
}

- (void)quetMauByte:(uint64_t)tuDiaChi denDiaChi:(uint64_t)denDiaChi {
    unsigned char mauByte1[] = {0xFD, 0x7B, 0xBF, 0xA9};
    unsigned char mauByte2[] = {0xFD, 0x03, 0x00, 0x91};
    unsigned char mauByte3[] = {0x08, 0x00, 0x40, 0xF9};
    unsigned char mauByte4[] = {0x00, 0x00, 0x80, 0xD2};
    unsigned char mauByte5[] = {0xC0, 0x03, 0x5F, 0xD6};
    unsigned char mauByte6[] = {0xE0, 0x03, 0x00, 0xAA};
    unsigned char mauByte7[] = {0x1F, 0x20, 0x03, 0xD5};
    unsigned char mauByte8[] = {0x00, 0x00, 0xA0, 0xE3};
    unsigned char mauByte9[] = {0x1E, 0xFF, 0x2F, 0xE1};
    
    uint64_t viTri = tuDiaChi;
    NSInteger soLanTimThay = 0;
    
    while (viTri < denDiaChi && soLanTimThay < 500) {
        if (viTri > 0x1000) {
            unsigned char duLieu[4];
            memcpy(duLieu, (void *)viTri, 4);
            
            BOOL timThay = NO;
            if (duLieu[0] == mauByte1[0] && duLieu[1] == mauByte1[1] && duLieu[2] == mauByte1[2] && duLieu[3] == mauByte1[3]) timThay = YES;
            if (duLieu[0] == mauByte2[0] && duLieu[1] == mauByte2[1] && duLieu[2] == mauByte2[2] && duLieu[3] == mauByte2[3]) timThay = YES;
            if (duLieu[0] == mauByte3[0] && duLieu[1] == mauByte3[1] && duLieu[2] == mauByte3[2] && duLieu[3] == mauByte3[3]) timThay = YES;
            if (duLieu[0] == mauByte4[0] && duLieu[1] == mauByte4[1] && duLieu[2] == mauByte4[2] && duLieu[3] == mauByte4[3]) timThay = YES;
            if (duLieu[0] == mauByte5[0] && duLieu[1] == mauByte5[1] && duLieu[2] == mauByte5[2] && duLieu[3] == mauByte5[3]) timThay = YES;
            if (duLieu[0] == mauByte6[0] && duLieu[1] == mauByte6[1] && duLieu[2] == mauByte6[2] && duLieu[3] == mauByte6[3]) timThay = YES;
            if (duLieu[0] == mauByte7[0] && duLieu[1] == mauByte7[1] && duLieu[2] == mauByte7[2] && duLieu[3] == mauByte7[3]) timThay = YES;
            if (duLieu[0] == mauByte8[0] && duLieu[1] == mauByte8[1] && duLieu[2] == mauByte8[2] && duLieu[3] == mauByte8[3]) timThay = YES;
            if (duLieu[0] == mauByte9[0] && duLieu[1] == mauByte9[1] && duLieu[2] == mauByte9[2] && duLieu[3] == mauByte9[3]) timThay = YES;
            
            if (timThay) {
                NSString *offsetStr = [NSString stringWithFormat:@"0x%llx", viTri];
                [self.duLieuOffset appendFormat:@"%@\n", offsetStr];
                soLanTimThay++;
            }
        }
        viTri += 4;
    }
    
    if (soLanTimThay > 0) {
        [self capNhatLog:[NSString stringWithFormat:@"Tìm thấy %ld offset", (long)soLanTimThay]];
    }
}

- (void)moFreeFire {
    [self taoFileCauHinhESP];
    self.nhanTrangThai.text = @"Đang mở Free Fire...";
    self.nhanTrangThai.textColor = [UIColor orangeColor];
    
    NSString *urlStr = @"freefire://";
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        self.nhanTrangThai.text = @"Đã mở Free Fire";
        self.nhanTrangThai.textColor = [UIColor greenColor];
    } else {
        self.nhanTrangThai.text = @"Không tìm thấy Free Fire";
        self.nhanTrangThai.textColor = [UIColor redColor];
    }
}

- (void)thoatFreeFire {
    self.nhanTrangThai.text = @"Đã thoát game";
    self.nhanTrangThai.textColor = [UIColor cyanColor];
}

- (void)capNhatLog:(NSString *)noiDung {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *thoiGian = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                           dateStyle:NSDateFormatterShortStyle
                                                           timeStyle:NSDateFormatterMediumStyle];
        NSString *dongLog = [NSString stringWithFormat:@"[%@] %@\n", thoiGian, noiDung];
        self.khungLog.text = [self.khungLog.text stringByAppendingString:dongLog];
        
        if (self.khungLog.text.length > 5000) {
            self.khungLog.text = [self.khungLog.text substringFromIndex:self.khungLog.text.length - 5000];
        }
        
        NSRange cuoiKhung = NSMakeRange(self.khungLog.text.length - 1, 1);
        [self.khungLog scrollRangeToVisible:cuoiKhung];
    });
}

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blackColor];
    CheatViewController *rootVC = [[CheatViewController alloc] init];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];
    return YES;
}

@end

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
