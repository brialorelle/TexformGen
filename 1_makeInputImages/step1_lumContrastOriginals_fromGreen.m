function [imageTex_LumContMatch]=step1_lumContrastOriginals_fromGreen(currFolder,saveFolder)
homedir=pwd;

if ~exist(saveFolder)
    mkdir(saveFolder)
end

% get conditions by reading image files folder
folderContents=dir(currFolder);
dropThese=[];
for i=1:length(folderContents)
    if strfind(folderContents(i).name,'.')
        dropThese(end+1)=i;
    end
end
folderContents(dropThese)=[];
conditions=folderContents;

conditionNames=[];
for i=1:length(conditions)
    conditionNames{i}=conditions(i).name;
end

imageSize=180;
countIm=0;

for i=1:length(conditions)
    % get list of images
    imList=dir(fullfile([currFolder filesep conditionNames{i}],'*.jpg'));
    numImages(i)=length(imList);
    % try png if something is empty..
    if any(numImages==0)
        for i=1:length(conditions)
            numImages(i)=length(dir(fullfile(currFolder,'*.png')));
        end
    end
    
for imNum=1:length(imList)
    % read image
    countIm=countIm+1;
    im=imread(fullfile([currFolder filesep conditionNames{i}],imList(imNum).name));
    im=expandToSquareFunction_color(im);
    imR=im(:,:,1);
    imG=im(:,:,2);
    imB=im(:,:,3);
    
    greenPix=(imG>150 & imR<20 & imB < 20); % DETERMINE THE RGB OF BACKROUND
    objectPix=(~(greenPix));
    
    
%     % sanity check
%     subplot(1,2,1)
%     imshow(im./255)
%     subplot(1,2,2)
%     imshow(objectPix)

    prefs.imageName{i,imNum}=imList(imNum).name;
    AllImagesBW{countIm}=mean(im,3);
    AllImagesMask{countIm}=objectPix; %% will have 1 for object, 0 for background
end
end

assert(length(unique(numImages))==1,'uneven number of images per category!')
    

%% SHINE IMAGES for LUM/CONTRAST
disp('using background RGB=[130 130 130]')
AllImages_LumCont=SHINE_lum130(AllImagesBW,AllImagesMask);%% special script so that background is always 130
% AllImages_LumCont=SHINE(AllImagesBW,AllImagesMask);%% default

imPerCat=length(imList);
imageTex_LumContMatch(1,1:imPerCat)=AllImages_LumCont(1:imPerCat); %1:30
imageTex_LumContMatch(2,1:imPerCat)=AllImages_LumCont(imPerCat+1:imPerCat*2); %31:60

if size(conditions,1)<3 %% if only 2 folders, or else go to max of 4 folders
else
    imageTex_LumContMatch(3,1:imPerCat)=AllImages_LumCont(imPerCat*2+1:imPerCat*3); %61:90
    imageTex_LumContMatch(4,1:imPerCat)=AllImages_LumCont(imPerCat*3+1:end); % 91:120
end



for i=1:length(conditions)
    saveDir=[homedir filesep saveFolder filesep conditionNames{i}]
    if ~exist(saveDir)
        mkdir(saveDir)
    end
    for imNum=1:length(imList)
        im=imageTex_LumContMatch{i,imNum};
        imwrite(im, [saveDir filesep prefs.imageName{i,imNum} '_LCMatched.png'], 'png');
    end
    
end

disp('all done! images matched and saved.')



