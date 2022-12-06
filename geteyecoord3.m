function [eye1, eye2, numberOfEyes] = newEyeMap(Im, mouthPos)
   
    image = im2uint8(Im);
    
    % Convert to YCbCr color space and extract the components
    ycbcrmap = rgb2ycbcr(image);
    Y = ycbcrmap(:,:,1);
    Cb = ycbcrmap(:,:,2);
    Cr = ycbcrmap(:,:,3);
    
    % Calculate Cb^2
    dCb = double(Cb);
    CbPow = power(dCb,2);
    
    % Normalize Cb^2 to range between 0 and 255
    normCbPow = CbPow./max(max(CbPow));
    CbPow = normCbPow.*255;

    % Calculate the negative of Cr
    CrNeg = 255 - Cr;
    
    % Calculate CrNeg^2
    dCrNeg = double(CrNeg);
    CrNegPow = power(dCrNeg,2);
    
    % Normalize the negative of Cr between 0 and 255
    normCrNegPow = CrNegPow./max(max(CrNegPow));
    CrNegPow = normCrNegPow.*255;
    % Calculate Cb/Cr
    CbDivCr = double(Cb)./double(Cr);

    % Normalize Cb/Cr between 0 and 255
    normCbDCr = CbDivCr./max(max(CbDivCr));
    CbDCrFinal = normCbDCr.*255;

    % Calculate eyeMapC
    eyeMapC = (1/3).*CbPow + (1/3).*CrNegPow + (1/3).*CbDCrFinal;

    % Histogram equalization to enhance contrast
    eyeMapC = histeq(uint8(eyeMapC));

    % Structuring element for dilation and erosion
    SE = strel('sphere',20);

    % Erosion of the luma component
    erosion = imerode(Y,SE);
    erosion = erosion + 1;
    
    % Dilation of the luma component
    dilation = imdilate(Y,SE);

    % Calculating EyeMapL
    eyeMapL = double(dilation)./double(erosion);

    % Normalizing EyeMapL between 0 and 255 
    eyeMapLN = eyeMapL./max(max(eyeMapL));
    eyeMapLFinal = uint8(eyeMapLN.*255);

    % Fusing EyeMapC and EyeMapL to create the final eye map
    eyeMapFinal = imfuse(eyeMapLFinal, eyeMapC, 'blend');

    % Dilating the final eye map
    SE2 = strel('sphere',15);
    eyeMapFinal = imdilate(eyeMapFinal, SE2);

    % Normalizing the final eye map between 0 and 255
    eyeMapFinal = 255.*double(eyeMapFinal)./max(max(double(eyeMapFinal)));
    [rows, cols] = size(eyeMapFinal);

    % Thresholding the map to create map with intensities of only 0 and 255
    for row = 1:rows
        for col = 1:cols
            if(eyeMapFinal(row,col) > 201)
                eyeMapFinal(row,col) = 255;
            else
                eyeMapFinal(row,col) = 0;
            end
        end
    end
    % Makes the map binary
    BW = logical(eyeMapFinal);
    % Cropping eyemap 
    %disp(mouthPos);
    BW( round(mouthPos(2)) - round((1/7)*rows) : rows , : ) = 0; % bottom
    BW( 1 : round((1/3.0)*rows), :) = 0;                  % top
    BW( : , 1 : round(mouthPos(1)) - round((1/5)*cols) ) = 0;    % left
    BW( : , round(mouthPos(1)) + round((1/4)*cols) : cols ) = 0; % right
    %figure
    %imshow(BW)
    %title('cropped eye map')
    
    eyemap = BW;
    
    mm = bwareafilt(eyemap,2); % Selecting 2 largest object of image
    % Calculates the center of each object
    labeledImage = logical(mm);
    measurements = regionprops(labeledImage, mm, 'Centroid');
    [a, ~] = size(measurements);
    
    % If two centriods are found, they become the eye positions 
    if(a == 2)
        centroid1 = measurements(1).Centroid;
        centroid2 = measurements(2).Centroid;

        centroid1 = round(centroid1);
        centroid2 = round(centroid2);

        mm(centroid1(2),centroid1(1),:) = 0;
        mm(centroid2(2),centroid2(1),:) = 0;

        eye1 = centroid1;
        eye2 = centroid2;
        numberOfEyes = 2;
        return
    else 
        if(a == 1) 
            eye1 = [];              % If there is only one centroid found, eye positions are not set 
            eye2 = [];              % and number of eyes are set to one.
            numberOfEyes = 1;
            return
        else
            eye1 = [];              % If there is less than one centroid, eye positions are are also not set
            eye2 = [];              % and number of eyes are set to zero
            numberOfEyes = 0;        
            return
        end

    end


end