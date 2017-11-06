function targmag=getShineTargMag(images)
% compute power spectrum for a set of images (or single image)
% return average

numim = max(size(images));
[xs,ys] = size(images{1});
angs = zeros(xs,ys,numim);
mags = zeros(xs,ys,numim);
for im = 1:numim
    if ndims(images{im}) == 3
        images{im} = rgb2gray(images{im});
    end
    im1 = double(images{im})/255;
    [xs1,ys1] = size(im1);
    if xs~=xs1 || ys~=ys1
        error('All images must have the same size.')
    end
    fftim1 = fftshift(fft2(im1));
    [angs(:,:,im),mags(:,:,im)] = cart2pol(real(fftim1),imag(fftim1));
end

targmag = mean(mags,3);
    