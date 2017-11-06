function [ratiolist,Names]=CenterImageinSquare(startDir,newDir,visSize)

% directory info
codeDir=pwd;
seps=strfind(codeDir,filesep);
topDir=codeDir(1:seps(end)-1);
%
temp=dir(startDir);
dropThese=[];
for i=1:length(temp)
    if any(strfind(temp(i).name,'.'));
        dropThese(i)=1;
    else
        dropThese(i)=0;
    end
end
temp(find(dropThese))=[];
subFolders=temp;

for i=1:length(subFolders)
    if ~(exist(fullfile(newDir,subFolders(i).name)))
        mkdir(fullfile(newDir,subFolders(i).name));
    end
end
% parameters
frame       = 440; % pixels

% helpers
frameArea       = frame*frame;
visSizePxCount  = frameArea * visSize/100;

count=0;
areaChanged=0;
ratiocount=0;
allOK=0;
for i=1:length(subFolders)
    
    % get current imList
    imList=dropHiddenFiles(startDir,subFolders(i).name);
    
    for j=1:length(imList)
        startFileName=fullfile(startDir,subFolders(i).name,imList(j).name);
        newFileName=fullfile(newDir,subFolders(i).name,imList(j).name);
        ima=imread(startFileName);
        
        ima=double(ima); %% An image onto which we are going to apply any type of transformation needs to be put in "double" format
        s=size(ima);

        % resize im!
        
        % -----------------
        sqim = expandToSquareFunction_color(ima);
        imThresh    = sqim<253;
        pxCount     = sum(imThresh(:));
        pxTotal     = length(imThresh(:));
        pctArea     = pxCount/pxTotal * 100;
        Area(i,j)=pctArea;
        
        
        [areaIm flag newPxArea] = imAreaResize(sqim, visSizePxCount, frame);
        if ~flag %% if there is no flag, use what is resized
            imwrite(areaIm./255,newFileName,'jpeg','quality',100);
            Area(i,j)=newPxArea;
        else %% just use original if it won't work
            imwrite(sqim./255,newFileName,'jpeg','quality',100);
        end
        Names{i,j}=newFileName;

    end
end

end

function temp1=dropHiddenFiles(startDir,subFolders);
temp1=dir([startDir filesep subFolders]);
dropThese=[];
for i=1:length(temp1)
    if any(strfind(temp1(i).name(1),'.'));
        dropThese(i)=1;
    else
        dropThese(i)=0;
    end
end
temp1(find(dropThese))=[];
end