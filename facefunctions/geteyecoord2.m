function [eye1, eye2, numberOfEyes] = geteyecoord2(result)

image = result;

%Get face mask
localFacemask = facemask(image);

%Get mouth mask
[mouthImg, ~] = mouthmap(image);

%Remove mouth from facemask
localFacemask = localFacemask - mouthImg;

%clamps from [0, 1]
localFacemask = min(max(localFacemask, -1),1);

%transform to YCbCr color space 
chroma_img = rgb2ycbcr(image);

Y = chroma_img(:,:,1);
Cb = chroma_img(:,:,2);
Cr = chroma_img(:,:,3);
Cr_c = 1 - Cr; %complement of Cr

%precompute values for chroma eye mask
cbcb = Cb .* Cb;
crcr_c = Cr_c .* Cr_c;
cbcr = Cb./Cr;

%Normalize squared values between 0 and 1 - this guarantees that eyemapc
%has values between 0 and 1

maxvalue_cbcb = max(max(cbcb));
maxvalue_crcr_c = max(max(crcr_c));
maxvalue_cbcr = max(max(cbcr));

minvalue_cbcb = min(min(cbcb));
minvalue_crcr_c = min(min(crcr_c));
minvalue_cbcr = min(min(cbcr));

cbcb = (cbcb - minvalue_cbcb) / (maxvalue_cbcb - minvalue_cbcb);
crcr_c = (crcr_c - minvalue_crcr_c) / (maxvalue_crcr_c - minvalue_crcr_c);
cbcr = (cbcr - minvalue_cbcr) / (maxvalue_cbcr - minvalue_cbcr);

eyemapc = 1/3 .* (cbcb + crcr_c + cbcr);

%histogram equalize to pop eyes better
eyemapc = histeq(eyemapc);

%compute luminance eye map, test different structure elements and sizes
%disk with radius 10 works fairly well for db1
se = strel('disk', 10);
eyemapl = imdilate(Y, se) ./ (imerode(Y, se) + 1);
%Combine both eye maps and mask with facemask
%using facemask here gives better result when normalizing the image
%facemask removes a lot of false eye candidates
eyemap = double(eyemapc).*double(eyemapl).*double(localFacemask);
%eyemap = eyemap .* facemask;
eyemap = imdilate(eyemap, se);
%normalize to bring the highest values to 1 -> easier to choose threshold 

%Add weight image ontop to reduce outer values 
bw = zeros(size(eyemap));
bwSize = size(bw);
ycenter = floor(bwSize(1)/2.2);
height = 10;
bw(ycenter-height:ycenter+height,:) = 1;
%imshow(bw);
D1 = bwdist(bw,'euclidean');
weights = rgb2gray(repmat(rescale(D1), [1 1 3]));
eyemap = eyemap .* (1-weights);

eyemap_max = max(max(eyemap));

eyemap_min = min(min(eyemap));

eyemap = (eyemap - eyemap_min) / (eyemap_max - eyemap_min);

%create binary eyemap
imbinary = eyemap > 0.75; %0.75 works fairly well for db1

se = strel('disk', 3);
%close small gaps between objects, 
%useful for ex. when eyebrows are misstaken as eye candidates
imbinary = imclose(imbinary, se);

eyemap = imbinary; 
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


% stats = regionprops(imbinary, "centroid");
% 
% %concatinate all centroids found in the image 
% centroid = cat(1, stats.Centroid);
% 
% %If we have more than 2 eye candidates go through all pairs
% %and compare their y-value differences, the pair of points with
% %lowest y-diff are more probable to be the true eyes
% if(length(centroid) > 2) 
%     eyepoints = zeros(2);
%     minY = realmax; %keep track of global y-minimum
%     for i = 1:length(centroid)
%         for j = i+1:length(centroid)
%             y1 = centroid(i,2);
%             y2 = centroid(j,2);
%             
%             heightdiff = abs(y1 - y2);
%             
%             if(heightdiff < minY)
%                 eyepoints(1,:) = centroid(i,:);
%                 eyepoints(2,:) = centroid(j,:);
%                 minY = heightdiff;
%                 %This can be improved further by checking the distance of the pair
%                 % of points to the middle in y-direction, the closer to the middle
%                 % the better and probably more accurate that those are the eyes
%                 
%                 %can also check distance in x-direction from the center of
%                 %mouth and make sure 1 eye candidate is on each side of the
%                 %mouth. Use mouthCenter as the center point of the mouth 
%             end
%         end
%     end
%     eyecoords = eyepoints;
% else
%     %found 2 or less eye candidates use the given candidates as eye points
%     %should have a backup case here if we only find one eye 
%     %eg take the given eye and another point to the left or right side of
%     %the mouth at the same height
%     eyecoords = centroid;
% end
% 
%     %Make sure left and right eye are in correct order of matrix given the
%     %x-coordinate of the eyes found, ie. [lefteye; righteye]
%     eyeSize = size(eyecoords);
%     if eyeSize(1) == 2 && eyeSize(2) == 2
%         if(eyecoords(1,1) < eyecoords(2,1))
%             lefteye = eyecoords(1,:);
%             righteye = eyecoords(2,:);
%         else
%             lefteye = eyecoords(2,:);
%             righteye = eyecoords(1,:);
%         end
%         eyecoords = [lefteye; righteye];
%     else
%         eyecoords = 0;
%     end
end