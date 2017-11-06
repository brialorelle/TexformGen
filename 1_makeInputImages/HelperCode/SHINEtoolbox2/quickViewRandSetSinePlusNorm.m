%function quickViewRandSet

%% load images
categories={'bigAnimals','bigObjects','bodies','faces','scenes',...
    'smallAnimals','smallObjects'}

if ~exist('imname')
    [images,numim,imname] = readImages('SHINE_INPUT','jpg');
    [templ,numtempl,templname] = readImages('SHINE_TEMPLATE','jpg');
end

%% choose a random target/distractor

% choose random targ/dist
randList=Shuffle(1:length(categories));
targCat=categories{randList(1)};
distCat=categories{randList(2)};

% get indices, randomly shuffle
targidx = Shuffle(find(~cellfun(@isempty,strfind(imname,targCat))));
distidx = Shuffle(find(~cellfun(@isempty,strfind(imname,distCat))));

% get list of images to use
N=7; % number of distractors
imnums=[targidx(1) distidx(1:N)']; % images to use as stimuli
sftarget=distidx(N+1); % image to use as spatial frequency template

%% get inputs

% images that will show in the display
showImages=images(imnums)';
showTemplates=templ(imnums)';

% image to which those images will be matched
targImages=images(sftarget);
targmag = getShineTargMag(targImages);

%% shine em up

matchedImages = SHINE_TargSpectrum_GREZ(showImages,showTemplates,targmag);
statsO = imstats(showImages);
statsM = imstats(matchedImages);
areTheseSimilar=[statsM.meanVec statsM.stdVec]

%% adjust the matched to have desired mean and STD

matchedImages=imnorm(matchedImages,130,18)
statsM = imstats(matchedImages)

%% visualize the results

figure(1);
clf;
showN=5; % how many to show
showN=N+1;
for i=1:showN
    %subplot(N+1,2,i*2-1);
    subplottight(3,showN,i);
    %subplottight(N+1,2,i*2-1);
    imshow(showImages{i});
    
    if i==1
        title(sprintf('M=%3.2f, STD=%3.3f',statsO.meanLum,statsO.meanStd)); 
    end
        
    %subplot(N+1,2,i*2);
    subplottight(3,showN,i+showN*2);
    %subplottight(N+1,2,i*2);
    imshow(matchedImages{i});
    
    if i==1
        title(sprintf('M=%3.2f, STD=%3.3f',statsM.meanLum,statsM.meanStd)); 
    end
    
end

subplottight(3,showN,showN+1);
imshow(targImages{1});
title('all matched to spectrum of this');

