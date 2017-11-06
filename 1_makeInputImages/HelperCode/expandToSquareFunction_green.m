function squareIm = expandToSquareFunction_green(im)

outputim.size = [440 440];
blank = repmat(0, [outputim.size(1), outputim.size(2), 1]);
blank(:,:,2) = repmat(255, [outputim.size(1), outputim.size(2), 1]);
blank(:,:,3) = repmat(0, [outputim.size(1), outputim.size(2), 1]);


% find the size of the image
imW = size(im,2);
imH = size(im,1);

%resize the image so that it fits in the output image size (don't change
%the proportions of the object!
if (imH/imW > outputim.size(1)/outputim.size(2))
    %object is taller than the output im
    % set the height of the input to the height of the ouput and scale/center the
    % width of the input accordingly
    
    %get the height and width
    newsize(1) = outputim.size(1);
    newsize(2) = round((imW*outputim.size(1))/imH);
    
    %scale it
    im2 = imresize(im, [newsize], 'bilinear');
%     im2=uint8(im2);
    %center it
    top1 = 1;
    top2 = round(outputim.size(2)/2) - round(newsize(2)/2)+1;
    bot1 = top1+newsize(1)-1;
    bot2 = top2+newsize(2)-1;
    

    
    tempim = blank;
    tempim=uint8(tempim);
    tempim(top1:bot1, top2:bot2,1) = im2(:,:,1);
    tempim(top1:bot1, top2:bot2,2) = im2(:,:,2);
    tempim(top1:bot1, top2:bot2,3) = im2(:,:,3);
else
    %object is fatter than the output im    
    %get the height and width
    newsize(2) = outputim.size(2);
    newsize(1) = round((imH*outputim.size(2))/imW);
    
    %scale it
    im2 = imresize(im, [newsize], 'bilinear');
%     im2=uint8(im2);
    
    %center it
    top1 = round(outputim.size(1)/2) - round(newsize(1)/2)+1;
    top2 = 1;
    bot1 = top1+newsize(1)-1;
    bot2 = top2+newsize(2)-1;
    

    tempim = blank;
    tempim=uint8(tempim);
    tempim(top1:bot1, top2:bot2,1) = im2(:,:,1);
    tempim(top1:bot1, top2:bot2,2) = im2(:,:,2);
    tempim(top1:bot1, top2:bot2,3) = im2(:,:,3);

    
end

squareIm = tempim;