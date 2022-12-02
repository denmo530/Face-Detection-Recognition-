function [result, left, right] = createEyemap(input)
%This function will produce an eyemap from an input image

% TODO remove imshow and disp() texts

% TODO make use of face masks where needed

img = input;
% % figure;
% % disp("Original image")
% % imshow(img);

% Eye map: Chrominance
eyeChrome = eyemapC(img);

% Eye map: Luminance
eyeLum = eyemapL(img);

eyemap = eyeChrome.*eyeLum; 
    
    %Make binary mask
    eyemap = eyemap >= 0.75; 
    
    % Morphological operations to remove unnecessary blobs from EyeMap
    SE = strel('disk',8);
    eyemap = imdilate(eyemap, SE);
    eyemap = imdilate(eyemap, SE);
    eyemap = imerode(eyemap, SE);
    eyemap = imclearborder(eyemap);

    % Remove impossible eye candidates
    [height, width] = size(eyemap);
    
    statsEye = regionprops(eyemap, 'centroid',  'PixelIdxList', 'MaxFeretProperties');
    centAxisEyes = cat(1, statsEye.MaxFeretDiameter);
    centroidseye = cat(1, statsEye.Centroid);
    [numOfEyes, ~] = size(centroidseye);

     for i=1:numOfEyes  
       if centroidseye(i,2) > height*0.66 || centroidseye(i,2) < height*0.3
         eyemap(statsEye(i).PixelIdxList) = 0;
       end
       if centAxisEyes(i,1) > 70
           eyemap(statsEye(i).PixelIdxList) = 0;
       end
     end

% % figure;
% % disp("Eye map: Chrominance")
% % imshow(eyeChrome)
% % figure;
% % disp("Eye map: Luminance")
% % imshow(eyeLum)


% Illumination-based method
% illumination = eyeChrome.*eyeLum;

% figure;
% disp("Combined chrominance and luminance")
% imshow(illumination)

% % figure;
% % disp("After thresholding")
% % illumination = illumination >= 0.5;
% % imshow(illumination)

% Color-based method
%colorBased = im2double(histeq(im2gray(img)));
%colorBased = colorBased >= 0.999;

% % figure;
% % disp("Color-based method")
% % imshow(colorBased)

% Edge density-based method
%edgeBased = im2double(edge(im2gray(img)));
%se = strel('disk', 8);
%edgeBased = imdilate(edgeBased, se);
%edgeBased = imerode(edgeBased, se);
%edgeBased = edgeBased >= 0.99;

% % figure;
% % disp("Edge density-based method")
% % imshow(edgeBased)

%Combine Illumination-, Color-, Edge density-based methods

%img1 = illumination.*colorBased;
%img2 = illumination.*edgeBased;
%img3 = colorBased.*edgeBased;

%img1 = imbinarize(img1);
%img2 = imbinarize(img2);
%img3 = imbinarize(img3);

%combined = (img1 == 1) | (img2 == 1) | (img3 == 1);

% % figure;
% % disp("Combined images")
% % imshow(img1)
% % figure;
% % imshow(img2)
% % figure;
% % imshow(img3)

% % figure;
% % disp("combined")
% % imshow(combined);


% Apply facemask
% TODO maybe add condition to skip facemask if it barely has any values
mask = facemask(img);
if(sum(sum(mask)) == 0)
    disp("Face mask is empty, face mask will not be applied")
else
    optimImg = optimMethods(input,eyemap, mask)
    combined = optimImg;
% %     figure;
% %     disp("combined + facemask")
% %     imshow(combined);
end

% result
result = combined;
left = geteyecoord(result);
end

