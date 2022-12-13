function [result] = normalizeface(input)
%Take image of a face and normalize the image in terms of scale, rotation
%and tone values. The image will have a set resolution which is important
%for later steps.

addpath(genpath("utilfunctions"));

input = im2double(input); %Not sure if this is prefered

%Automatic White Balancing, AWB
input = whiteworld(input);

%Get eyes
[eye1, eye2] = geteyecoord4(input);

leftEye = eye1;
rightEye = eye2;

angle = atan2(rightEye(2) - leftEye(2), rightEye(1) - leftEye(1));
angle = angle * 180 / pi;

%Rotate image based on eye position
rotated = imrotate(input, angle, "bicubic", "loose");
rotated = rotateAround(input, leftEye(2), leftEye(1), angle, 'bicubic');

%Crop image
hypotenuse = norm(leftEye-rightEye);
center = leftEye + [hypotenuse/2, 0];
Ltop = center + [hypotenuse*-0.75, -hypotenuse*0.5];
Rbottom = center + [hypotenuse*0.75, hypotenuse*1.5];
result = imresize(imcrop(rotated, [Ltop Rbottom-Ltop]), [400, 300]);


result = im2gray(result);
end