function cropTexforms(metamerOutputFolder, croppedFolder, screenshotSize)
% crops texfrom output
% cropTexforms(metamerOutputFolder, croppedFolder, screenshotSize)

% folder set up
if ~exist(croppedFolder)
    mkdir(croppedFolder)
end

if ~exist(metamerOutputFolder)
    error('output folder doesn ot exist!')
end

%% Set up position parameters for cropping
% Need to specify these manually, not super elegant but will do.
itemRadius=220; %% how far out we put them
imSizeFull=192; % and how big the images were
%%
numPositions=2; %% positions in screenshot
allAngles=[0 180]; %% on horizontal meridian
window.centerX=screenshotSize/2; %% half of screenshot size / input metamer size
window.centerY=screenshotSize/2;
imSize=imSizeFull/2;

% Get the exact position back that we used in screeshots
for currItem=1:length(allAngles)
    prefs.posAngles(currItem) = allAngles(currItem);
    prefs.posX(currItem) = window.centerX+itemRadius*cosd(prefs.posAngles(currItem));
    prefs.posY(currItem) = window.centerY+itemRadius*sind(prefs.posAngles(currItem));
end

%% Get directory structure back out
folderContents=dir(metamerOutputFolder);
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


%% For each category in a directory
for c=1:length(conditionNames)
    currCat=conditionNames{c};
    metPath=([pwd filesep metamerOutputFolder filesep currCat]);
    croppedPath=([pwd filesep croppedFolder filesep currCat]);
    if ~exist(croppedPath)
        mkdir(croppedPath)
    end
    %% get images to crop
    imList=dir([metPath filesep '*.png']);
    cd(metPath)
    %% go through the list of images, crop and save
    for image=1:length(imList)
        currImage=imread(imList(image).name);
        for curPos=1:numPositions
%             newFileName=[croppedPath filesep imList(image).name(1:end-8) '-Pos' num2str(curPos) '.png']; % you may want to modify this for your own needs
            newFileName=[croppedPath filesep imList(image).name '-Pos' num2str(curPos) '.png']; % for any filename
            vals=[prefs.posX(curPos)-imSize,prefs.posX(curPos)+imSize,prefs.posY(curPos)-imSize,prefs.posY(curPos)+imSize];
            cropped_image=imcrop(currImage,[prefs.posX(curPos)-imSize,prefs.posY(curPos)-imSize,imSizeFull,imSizeFull]);
            imwrite(uint8(cropped_image),newFileName,'png');
        end
    end
end


end