function [rgbImg] = eyemapC(input)

img_ycbcr = rgb2ycbcr(input);

%[Cr, ~, Cb] = imsplit(img_ycbcr);
img_ycbcr = im2double(img_ycbcr);
Y = img_ycbcr(:,:,1);
Cb = img_ycbcr(:,:,2);
Cr = img_ycbcr(:,:,3);

% Chromincance eyemap
eyeMapC = ((Cb.^2)+((1-Cr).^2)+(Cb./Cr))./3; 

%Histogram normalization
normImg = histeq(eyeMapC);
rgbImg = normImg; 

end