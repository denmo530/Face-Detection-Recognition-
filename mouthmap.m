function [result] = mouthmap(input)
%Generates mouthmap from image.

%Convert Image
img_ycbcr = (rgb2ycbcr(input));

Y = mat2gray(img_ycbcr(:,:,1)) +1;
Cb = mat2gray(img_ycbcr(:,:,2)) +1;
Cr = mat2gray(img_ycbcr(:,:,3)) +1;

%eta = η
%n = numel(input);

eta = 0.95 * (mean(Cr(:).^2))/(mean(Cr(:)./Cb(:)));


%TODO Mouthmap doesnt seem to work atm
%MouthMap:
result = (Cr.^2).*((Cr.^2) - eta*(Cr./Cb)).^2;

%result = histeq(result);

result = (result- min(result(:)))/(max(result(:)) - min(result(:)));

%se1 = strel('disk', 12);


%result = result > 0.2;

%result = bwareaopen(result, 200);
%result = imdilate(result, se1);

end