function [leftcenter] = geteyecoord(result)


se1 = strel('disk', 8);
result = bwareaopen(result, 200);
result = imdilate(result, se1);

L = bwlabel(im2double(result));
%Get the area and center point of all mouth candidates
stats = regionprops(L, "Area", "Centroid");
area = zeros(size(stats));
center = zeros(length(stats),2);
%save intermidate variables
for i = 1:length(stats)
    area(i) = stats(i).Area;
    center(i,:) = stats(i).Centroid;
end

largestMouth = find(max(area));

newMouthMask = zeros(size(result));
if largestMouth == 1
    newMouthMask(L == largestMouth) = 1;
end

leftcenter = center(largestMouth, :);
%rightcenter = center(largestMouth[2], :);

end