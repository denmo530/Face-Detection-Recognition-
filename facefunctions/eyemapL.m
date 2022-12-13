function [eyemaplum] = eyemapL(input)

[Y, ~, ~] = imsplit(input);

se1 = strel('disk', 16,8);

eyemaplum=imdilate(Y,se1)./(1+imerode(Y,se1));

eyemaplum = im2double(histeq(eyemaplum));
end