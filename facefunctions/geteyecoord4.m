function [eye1, eye2] = geteyecoord4(Im)

%Path
addpath(genpath("facefunctions"));
addpath(genpath("eigenfacefunctions"));

%image format
image = whiteworld(Im);
image = im2uint8(image);

%Chrominance Eye map
eyeMapC = eyemapC(image);

%Luminance Eye map
eyeMapL = eyemapL(image);

%Combined eye map
    % Eye Map L + C
    eyeMapFinal = imfuse(eyeMapL, eyeMapC, 'blend');

    %Strucute element based on height
    SE_height = round(length(image(:,1))/36);
    SE = strel('disk',SE_height,8);

    %Final dilute
    eyeMapFinal = imdilate(eyeMapFinal, SE);

    % Normalizing the final eye map between 0 and 255
    eyeMapFinal = uint8(im2gray(eyeMapFinal));

    % Threshold to create binary image
    eyeMapFinal = (eyeMapFinal >= 170);
    BW = logical(eyeMapFinal);



%Remove sections of eye map based on mouth position
[~, mouthPos] = mouthmap(image);
mouthX = round(mouthPos(1));
mouthY = round(mouthPos(2));

[rows, cols] = size(image(:,:,1));

%Only remove as long as 2 regions remain
    %Remove bottom
    BW_new = BW;
    BW_new( mouthY - round((1/8)*rows) : rows , : ) = 0; % bottom
    if size(regionprops(BW_new, "area"),1) >= 2
        BW = BW_new;
    end
        
    %Remove top
    BW_new = BW;
    BW_new( 1 : round((1/3.0)*rows), :) = 0;                  % top
    if size(regionprops(BW_new, "area"),1) >= 2
        BW = BW_new;
    end
        
    %Remove left
    BW_new = BW;
    BW_new( : , 1 : mouthX - round((1/5)*cols) ) = 0;    % left
    if size(regionprops(BW_new, "area"),1) >= 2
        BW = BW_new;
    end

    %Remove bottom
    BW_new = BW;
    BW_new( : , mouthX + round((1/4)*cols) : cols ) = 0; % right
    if size(regionprops(BW_new, "area"),1) >= 2
        BW = BW_new;
    end



%Result
    %IF AT LEAST 2 ISLANDS NOT FOUND, return a default set of eyes
    if size(regionprops(BW_new, "area"),1) <= 1
        default_left_eye = [round(cols/3), round(rows*(0.45))];
        default_right_eye = [round(cols - cols/3), round(rows*(0.45))];
    
        eye1 = default_left_eye;
        eye2 = default_right_eye;
        return
    end

    %Set eyes
    eyemap = BW;
    mm = bwareafilt(eyemap,2); % Get 2 largest islands

    % Get centers of those islands
    labeledImage = logical(mm);
    measurements = regionprops(labeledImage, mm, 'Centroid');
    
    % Set eye positions
    centroid1 = measurements(1).Centroid;
    centroid2 = measurements(2).Centroid;

    centroid1 = round(centroid1);
    centroid2 = round(centroid2);

    mm(centroid1(2),centroid1(1),:) = 0;
    mm(centroid2(2),centroid2(1),:) = 0;

    eye1 = centroid1;
    eye2 = centroid2;
end