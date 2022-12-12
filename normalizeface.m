function [result] = normalizeface(input)
%Take image of a face and normalize the image in terms of scale, rotation
%and tone values. The image will have a set resolution which is important
%for later steps.


input = im2double(input); %Not sure if this is prefered

%Automatic White Balancing, AWB
input = whiteworld(input);
%input = grayworld(input);
%input = imresize(input, 0.7);

%Calls function for eyecoordinates
eyeCoords=geteyecoord2(input);


%if eyecoords doesnt exist, set a default value
%eyeCoords
expected_dimension = [2,2];

    % Attempt to use function "3"
[~, mouthCoords] = mouthmap(input);
[eye1, eye2, numberOfEyes] = geteyecoord4(input, mouthCoords);

leftEye = [185 271];
rightEye = [307 278];
%disp("before")
if numberOfEyes == 2
    %disp("1")
    leftEye = eye1;
    rightEye = eye2;
elseif size(eyeCoords) == expected_dimension
    %disp("2")
    leftEye = eyeCoords(1, :);
    rightEye = eyeCoords(2, :);
else
    %disp("3")
    leftEye = [185 271];
    rightEye = [307 278];
end

angle = atan2(rightEye(2) - leftEye(2), rightEye(1) - leftEye(1));
angle = angle * 180 / pi;

rotated = imrotate(input, angle, "bicubic", "loose");
rotated = rotateAround(input, leftEye(2), leftEye(1), angle, 'bicubic');

    %TODO update to new eye positions
% eyeCoords=geteyecoord2(input);
% leftEye = eyeCoords(1, :)
% rightEye = eyeCoords(2, :)

%Crop image
hypotenuse = norm(leftEye-rightEye);
center = leftEye + [hypotenuse/2, 0];
Ltop = center + [hypotenuse*-0.75, -hypotenuse*0.5];
Rbottom = center + [hypotenuse*0.75, hypotenuse*1.5];
result = imresize(imcrop(rotated, [Ltop Rbottom-Ltop]), [400, 300]);


result = im2gray(result);
%result = input;
end