function [leftcenter, secondlargestMouth] = geteyecoord(result)


se1 = strel('disk', 2);
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

largesteye = find(max(area));
secondlargestMouth = find(max(area(area<max(area))));


newMouthMask = zeros(size(result));
if largesteye == 1
    newMouthMask(L == largesteye) = 1;
end

%newMouthMask2 = zeros(size(result));
%if secondlargestMouth == 1
%    newMouthMask2(L == secondlargestMouth) = 1;
%end

leftcenter = center(largesteye, :);
%rightcenter = center(secondlargestMouth, :);

end