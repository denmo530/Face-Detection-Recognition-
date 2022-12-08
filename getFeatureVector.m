function [result] = getFeatureVector(input, eigenfaces, meanface)
%Takes an image "input", and creates a feature vector from eigenfaces "u_i"
% and the meanface "u" of the eigenvectors

input = reshape(input(:,:),1, []);

featureVector = zeros(1,size(eigenfaces, 2));
Phi = input - meanface;

featureVector = eigenfaces'*Phi';

result = featureVector;
end

