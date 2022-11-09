function [rgbImg] = eyemapC(input)

img_ycbcr = rgb2ycbcr(input);

%[Cr, ~, Cb] = imsplit(img_ycbcr);
img = im2double(img_ycbcr);
Y = img(:,:,1);
Cb = img(:,:,2);
Cr = img(:,:,3);

% Chromincance eyemap
eyeMapC = ((Cb.^2)+((1-Cr).^2)+(Cb./Cr))/3; 

%Histogram normalization
normImg = histeq(eyeMapC)
rgbImg = normImg; 


end