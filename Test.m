%% image detail enhancement
sigma_s = 12;
sigma_r = 0.04;

Img = imread("./Images/flower.png");
Img = im2double(Img);  % Image should be normalized into [0, 1]

S = BLF_LS(Img, Img, sigma_s, sigma_r);

ImgE = Img + 3 * (Img - S);

figure
imshow([Img, ImgE])

%% flash/no flash filtering
sigma_s = 12;
sigma_r = 0.003;

Img = imread("./Images/no_flash.png");
Img = im2double(Img);  % Image should be normalized into [0, 1]
Guide = imread("./Images/flash.png");
Guide = im2double(Guide);

S = BLF_LS(Img, Guide, sigma_s, sigma_r);

figure
imshow([Img, S])