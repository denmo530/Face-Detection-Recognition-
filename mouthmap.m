function [result] = mouthmap(input)
%Generates mouthmap from image.

%Convert Image
img_ycbcr = rgb2ycbcr(input);
img_ycbcr = im2double(img_ycbcr);

Y = img_ycbcr(:,:,1);
Cb = img_ycbcr(:,:,2);
Cr = img_ycbcr(:,:,3);
%[Y, Cb, Cr] = imsplit(img_ycbcr);


%eta = η
n = numel(input);
eta = 0.95 * ((1/n) * sum(sum(Cr.^2)))/((1/n)*sum(sum(Cr./Cb)));

%TODO Mouthmap doesnt seem to work atm
%MouthMap:
result = (Cr.^2) .* (Cr.^2 - eta * (Cr./Cb)).^2;

end