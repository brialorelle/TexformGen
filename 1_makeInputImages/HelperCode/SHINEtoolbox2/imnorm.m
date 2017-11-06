function images=imnorm(im,nM,nSTD)
% im = input cell array of images
% give images new mean (nM) anc standard deviation (nSTD)
% using z-score method
for i=1:length(im)
    M=mean(double(im{i}(:)));
    STD=std(double(im{i}(:)));
    zIm=(double(im{i})-M)/STD;
    newIm=uint8(nM+zIm*nSTD);
    images{i,1}=newIm;
end
