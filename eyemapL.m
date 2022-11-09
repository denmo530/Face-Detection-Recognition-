function [eyemaplum] = eyemapL(input)

[Y, ~, ~] = imsplit(input);

se = strel('disk', 4);

eyemaplum=imdilate(Y,se)./(1+imerode(Y,se));

eyemaplum = im2double(histeq(eyemaplum));

end