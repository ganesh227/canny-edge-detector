function [outimage, gradx, grady] = MyCannyEdgeDetector_18csm1008(image, threshold)
    if size(size(image),2) ~= 2
        image = rgb2gray(image);
    end
    image = im2double(image);
    sobelx = [-1 0 1;-2 0 2;-1 0 1];
    sobely = [-1 -2 -1;0 0 0;1 2 1];
    
    hsize = 31;
    sigma = 1;
    h = fspecial('gaussian',hsize, sigma);
    
    h = h ./ sum(h(:));
    filtx = conv2(h,sobelx) .* 1/8;
    filty = conv2(h,sobely) .* 1/8;
 
    gradx = conv2(filtx,image);
    grady = conv2(filty,image);
    
   
    
    %figure, imshow(gradx), title("gradx");
    %figure, imshow(grady), title("grady");
    magntude = sqrt(gradx .* gradx + grady .* grady);
    magntude = magntude ./ max(magntude(:));
    orientation = (atan2(grady, gradx) * 180) / pi;
    %figure,imshow(magntude), title("mag");
    outimage = NonMaxSup2(magntude,orientation);
    outimage = NonMaxSup2(outimage,orientation); 
    
    %figure, imshow(outimage), title("nms");
    
    outimage = hysteresis(outimage,threshold * 0.5,threshold);
    %figure, imshow(outimage), title("hysteresis2");
    gradx = imfilter(image, sobelx);
    grady = imfilter(image, sobely);
end