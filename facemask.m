function [outImg] = facemask(inputImg)
% Function to create a facemask from a given image.

% Transform to hsv color space
inputImg = double(inputImg); 
img_hsv = rgb2hsv(inputImg);

[H,S,V] = imsplit(img_hsv); 
[w h] = size(inputImg(:,:,1)); 
for i=1:w
    for j=1:h
        if((H(i,j) < 30/360 || H(i,j) > 250/360) && S(i,j) < 0.52 && V(i,j) > 0.5)
            mask(i,j) = 1;
        else
            mask(i,j) = 0; 
        end
    end
end

%Morphological operations to remove blobs
SE = strel('disk',8);
SE2 = strel('disk', 4)
mask = imerode(mask, SE);

while(bweuler(mask) ~= 1)
    mask = imerode(mask, SE2);
    mask = imdilate(mask, SE);
    mask = imerode(mask, SE2)
    disp("One iteration")
end
SE3 = strel('rectangle', [10, 40])
mask = imerode(mask, SE3)



im(:,:,1)=inputImg(:,:,1).*mask;   
im(:,:,2)=inputImg(:,:,2).*mask; 
im(:,:,3)=inputImg(:,:,3).*mask;



outImg = double(im); 
end