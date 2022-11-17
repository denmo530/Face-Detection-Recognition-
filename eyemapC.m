function [rgbImg] = eyemapC(input)

img_ycbcr = rgb2ycbcr(input);

%[Cr, ~, Cb] = imsplit(img_ycbcr);
%img = im2double(img_ycbcr);
Y = uint16(255 * mat2gray(img_ycbcr(:,:,1)));
Cb = uint16(255 * mat2gray(img_ycbcr(:,:,2)));
Cr = uint16(255 * mat2gray(img_ycbcr(:,:,3)));

% Chromincance eyemap
eyeMapC = im2double(((Cb.^2)+((1-Cr).^2)+(Cb./Cr))./3); 

%Histogram normalization
normImg = histeq(eyeMapC);
rgbImg = normImg; 

end