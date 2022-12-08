function [outImg] = optimMethods(img_grayscaled, eyemap, mask)

colorBase = histeq(im2gray(img_grayscaled));
colorBase = colorBase >= 0.9;

IlluminBase = eyemap >= 0.5; 
IlluminBase = IlluminBase.*mask;

se = strel('disk', 8);
edgeBase = edge(im2gray(img_grayscaled), "sobel"); 
edgeBase = imerode(edgeBase, se);
edgeBase = edgeBase >= 0.99;
edgeBase = edgeBase.*mask; 

colIll = colorBase.*IlluminBase; 
colIll = imbinarize(colIll); 

IllEdge = IlluminBase.*edgeBase; 
IllEdge = imbinarize(IllEdge); 

edgeCol = edgeBase.*colorBase;
edgeCol = imbinarize(edgeCol); 

finalComb = (colIll == 1) | (IllEdge == 1) | (edgeCol == 1); 

outImg = double(finalComb);
end