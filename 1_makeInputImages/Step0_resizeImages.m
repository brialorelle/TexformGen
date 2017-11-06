
function Step0_resizeImages(currFolder,saveFolder)
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
conditions=folderContents

conditionNames=[];
for i=1:length(conditions)
    conditionNames{i}=conditions(i).name;
end

for i=1:length(conditions)
    condSaveFolder=[saveFolder filesep conditionNames{i}];
     if ~exist(condSaveFolder)
        mkdir(condSaveFolder)
    end

    
    % get list of images
    imList=dir(fullfile([currFolder filesep conditionNames{i}],'*.jpg'))
    numImages(i)=length(imList);
    
    % try png if something is empty..
    if any(numImages==0)
        for i=1:length(conditions)
            numImages(i)=length(dir(fullfile(currFolder,'*.png')));
        end
    end

    for imNum=1:length(imList)
        % read image
        im=imread(fullfile([currFolder filesep conditionNames{i}],imList(imNum).name));
        newImName=[pwd filesep saveFolder filesep conditionNames{i} filesep imList(imNum).name];
        im=expandToSquareFunction_green(im); % resize to square and keep green background
        imwrite(im,newImName,'png');
    end
end


fclose('all');



