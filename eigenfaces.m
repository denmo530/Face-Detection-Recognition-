function [result] = eigenfaces(input)
%Create eigenface from a image that is normalized in rotation, scaling &
%tonevalues. The image will be the same size as the other images.


% 2. Represent the image as a n-vector "X_i"
M = size(input,3);   % M is the total number of images

for i = 1:1:M
    n_vector = reshape(input(:,:,i),1, []);
    X(i,:) = n_vector(1,:);
end

%"Create Eigenfaces using PCA"
% 3. Find average face vector, "u" represents the "mean face" for the training data set.

u = (1/M) * sum(X);

imshow(reshape(u,400,[]))

% 4. Subtract the mean, "u", face for each face vector, "X_i"
phi = X(:,:) - u;


% 5. Find the covariance matrix, C
A = phi';

v = transpose(A)*A;

u_i = A*v;

for i = 1:1:M
    imshow(reshape(u_i(:,i),400,[]))
end


result = u_i;

end