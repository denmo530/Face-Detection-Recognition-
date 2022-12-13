function [eyemapL] = eyemapL(input)

%image format
input = im2uint8(input);

%Luma component
img_ycbcr = rgb2ycbcr(input);
Y = img_ycbcr(:,:,1);

%Structure element size based on height
SE_height = round(length(input(:,1))/24);
SE = strel('disk',SE_height,8);

eyemapL=double(imdilate(Y,SE))./double(imerode(Y,SE) + 1);

% Normalizing EyeMapL between 0 and 255 
eyemapL = uint8(255 * mat2gray(eyemapL));

end