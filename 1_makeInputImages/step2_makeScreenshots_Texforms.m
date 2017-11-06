function step2_makeScreenshots_Texforms(currFolder,saveFolder)
%% REQUIRES PSYCHTOOLBOX http://psychtoolbox.org/
%% Could also be done without it though....

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

% number of images
for i=1:length(conditions)
    numImages(i)=length(dir(fullfile(currFolder,'*.png')));
end


% STEP 1: BASIC SETUP
% =========================================================================

% open the main screen
window = openMainScreen;
Screen('BlendFunction',window.onScreen,GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% display parameters
numbers = [6]; % number of position...
allAngles=[0 180];
itemRadius=220;

for currItem=1:length(allAngles)
    prefs.posAngles(currItem) = allAngles(currItem);
    prefs.posX(currItem) = window.centerX+itemRadius*cosd(prefs.posAngles(currItem));
    prefs.posY(currItem) = window.centerY+itemRadius*sind(prefs.posAngles(currItem));
end


% STEP 4: LOAD IN THE IMAGES
%=========================================================================
drawCenterText('Please wait while images load...', window, window.centerX, window.centerY, [0 0 0]);
Screen('Flip', window.onScreen);
         
numImages=[];
imageTex=[];
i=1;

imageSize=180;
countIm=0;

for i=1:length(conditions)
    % get list of images
    imList=dir(fullfile([currFolder filesep conditionNames{i}],'*.png'));
    numImages(i)=length(imList);
    
for imNum=1:length(imList)
    % read image
    countIm=countIm+1;
    im=imread(fullfile([currFolder filesep conditionNames{i} filesep imList(imNum).name]));
    
    [h w d] = size(im);
    maxS=max(h,w);
    scaleFactor=imageSize/maxS;
    im=imresize(im,scaleFactor);

    imageTex(i,imNum)=Screen('MakeTexture', window.onScreen, im);
    prefs.imageName{i,imNum}=imList(imNum).name;
    prefs.images{i,imNum}=im;
    
end
end




% MAKE SCREENSHOTS
for i=1:length(conditions)
    saveDir=[saveFolder filesep conditionNames{i}];
    if ~exist(saveDir)
        mkdir(saveDir)
    end
% =========================================================================
for currImage=1:size(imageTex,2)

    thisIm=prefs.images{i,currImage};
    imColor=[130 130 130]
    Screen('FillRect', window.onScreen, imColor);
    drawCenterText('+', window, window.centerX, window.centerY, [0 0 0]);
    x=prefs.posX(:);
    y=prefs.posY(:); % y position of these items
    
    % get the size of the original image
    srcRect=Screen('Rect', imageTex(i,currImage));
    
    % get destination rect
    firstRep=1; secondRep=2;
    dstRect=CenterRectOnPoint(srcRect,x(firstRep),y(firstRep));
    dstRect2=CenterRectOnPoint(srcRect,x(secondRep),y(secondRep));

    % draw images
    Screen('DrawTexture', window.onScreen, imageTex(i,currImage), srcRect, dstRect);
    Screen('DrawTexture', window.onScreen, imageTex(i,currImage), srcRect, dstRect2);
    imageArray = Screen('GetImage', window.onScreen, [], 'backBuffer');
    
    Screen('Flip', window.onScreen);
    WaitSecs(.5);
    imwrite(imageArray, [saveDir filesep prefs.imageName{i,currImage} '_InputImage.png'], 'png');
    

end % END OF TRIAL LOOP
end



% STEP 8: CLEAN UP
% =========================================================================


Screen('Flip', window.onScreen);
fclose('all');
sca;



% =========================================================================
%                               SUBFUNCTIONS
% =========================================================================



% =========================================================================
function window = openMainScreen 

% display requirements (resolution and refresh rate)
window.requiredRes  = [];
window.requiredRefreshrate = [];

%basic drawing and screen variables
window.gray        = 130;
window.black       = 0;
window.white       = 255;
window.fontsize    = 32;
window.bcolor      = window.gray

%open main screen, get basic information about the main screen
screens=Screen('Screens'); % how many screens attached to this computer?
% window.screenNumber=max(screens); % use highest value (usually the external monitor)
window.screenNumber=0; 
window.onScreen=Screen('OpenWindow',window.screenNumber, 0, [0 0 640 640], 32, 2); % open main screen
[window.screenX, window.screenY]=Screen('WindowSize', window.onScreen); % check resolution
window.screenDiag = sqrt(window.screenX^2 + window.screenY^2); % diagonal size
window.screenRect  =[0 0 window.screenX window.screenY]; % screen rect
window.centerX = window.screenRect(3)*.5; % center of screen in X direction
window.centerY = window.screenRect(4)*.5; % center of screen in Y direction

% set some screen preferences
[sourceFactorOld, destinationFactorOld]=Screen('BlendFunction', window.onScreen, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
Screen('Preference','SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel', 0);

% get screen rate
[window.frameTime nrValidSamples stddev] =Screen('GetFlipInterval', window.onScreen, 60);
window.monitorRefreshRate=1/window.frameTime;

% paint mainscreen bcolor, show it
Screen('FillRect', window.onScreen, window.bcolor);
Screen('Flip', window.onScreen);
Screen('FillRect', window.onScreen, window.bcolor);
Screen('TextSize', window.onScreen, window.fontsize);

% =========================================================================

% =========================================================================
function drawCenterText(textStr, window, x, y, color);

[normBoundsRect, offsetBoundsRect]=Screen('TextBounds', window.onScreen, textStr);
newRect = CenterRectOnPoint(normBoundsRect,x,y);
Screen('DrawText', window.onScreen, textStr, newRect(1), newRect(2), color);
% =========================================================================

% =========================================================================
function writeTrialToFile(D, trial, fid)

try
    h = fieldnames(D);
    for i=1:length(h)
        data = D.(h{i})(trial);
        if isnumeric(data)
            fprintf(fid, '%s\t', num2str(data));
        elseif iscell(data)
            fprintf(fid, '%s\t', char(data));
        else
            error('wrong format!')
        end
    end
    fprintf(fid, '\n');
catch
    sca;
    keyboard;
end

% =========================================================================


% =========================================================================
function [pressedKey pressedKeyCode RT] = getKeypressResponse(keys, tstart)
% assumes that key struct, with all ok key values in the field
% allKeys, also assumes 'q' quits

pressedKey=0;
while (1)
    
    [keyIsDown,secs,keyCode]=KbCheck(-1);
    
    if keyCode(keys(end))
        pressedKey = find(keyCode(keys),1);
        pressedKeyCode = find(keyCode,1);
        RT=-1;
        break;
    end
    
    if any(keyCode(keys))
        pressedKey = find(keyCode(keys),1);
        pressedKeyCode = find(keyCode,1);
        RT = GetSecs - tstart;
        break;
    end
    
end

% =========================================================================

function waitForKey;

%---------------------------------------------
% wait for key to start initiate trial
%---------------------------------------------
% make sure no key is currently pressed
[keyIsDown,secs,keyCode]=KbCheck(-1);
while(keyIsDown)
    [keyIsDown,secs,keyCode]=KbCheck(-1);
end
% get keyquit
while(1)
    [keyIsDown,secs,keyCode]=KbCheck(-1);
    if keyIsDown
        break;
    end
end


% =========================================================================

function [R, G, B] = Lab2RGB(L, a, b)
%LAB2RGB Convert an image from CIELAB to RGB
%
% function [R, G, B] = Lab2RGB(L, a, b)
% function [R, G, B] = Lab2RGB(I)
% function I = Lab2RGB(...)
%
% Lab2RGB takes L, a, and b double matrices, or an M x N x 3 double
% image, and returns an image in the RGB color space.  Values for L are in
% the range [0,100] while a* and b* are roughly in the range [-110,110].
% If 3 outputs are specified, the values will be returned as doubles in the
% range [0,1], otherwise the values will be uint8s in the range [0,255].
%
% This transform is based on ITU-R Recommendation BT.709 using the D65
% white point reference. The error in transforming RGB -> Lab -> RGB is
% approximately 10^-5.  
%
% See also RGB2LAB. 

% By Mark Ruzon from C code by Yossi Rubner, 23 September 1997.
% Updated for MATLAB 5 28 January 1998.
% Fixed a bug in conversion back to uint8 9 September 1999.
% Updated for MATLAB 7 30 March 2009.

if nargin == 1
  b = L(:,:,3);
  a = L(:,:,2);
  L = L(:,:,1);
end

% Thresholds
T1 = 0.008856;
T2 = 0.206893;

[M, N] = size(L);
s = M * N;
L = reshape(L, 1, s);
a = reshape(a, 1, s);
b = reshape(b, 1, s);

% Compute Y
fY = ((L + 16) / 116) .^ 3;
YT = fY > T1;
fY = (~YT) .* (L / 903.3) + YT .* fY;
Y = fY;

% Alter fY slightly for further calculations
fY = YT .* (fY .^ (1/3)) + (~YT) .* (7.787 .* fY + 16/116);

% Compute X
fX = a / 500 + fY;
XT = fX > T2;
X = (XT .* (fX .^ 3) + (~XT) .* ((fX - 16/116) / 7.787));

% Compute Z
fZ = fY - b / 200;
ZT = fZ > T2;
Z = (ZT .* (fZ .^ 3) + (~ZT) .* ((fZ - 16/116) / 7.787));

% Normalize for D65 white point
X = X * 0.950456;
Z = Z * 1.088754;

% XYZ to RGB
MAT = [ 3.240479 -1.537150 -0.498535;
       -0.969256  1.875992  0.041556;
        0.055648 -0.204043  1.057311];

RGB = max(min(MAT * [X; Y; Z], 1), 0);

R = reshape(RGB(1,:), M, N);
G = reshape(RGB(2,:), M, N);
B = reshape(RGB(3,:), M, N); 

if nargout < 2
  R = uint8(round(cat(3,R,G,B) * 255));
end

% =========================================================================

function [angle, radius] = xy2polar(h,v,centerH,centerV)

% George Alvarez: alvarez@mit.edu
% Version: 1.0
% Last Modified: 09.29.2005 
% [angle, radius] = xy2polar(1,1,250,250)
% [angle, radius] = xy2polar([1 1],[1 1],[250 250],[250 250])
% [angle, radius] = xy2polar([1 1; 1 1],[1 1; 1 1],[250 250; 250 250],[250 250; 250 250])

% ********** Input Variables
% h = current horizontal position
% v = current vertical position
% centerH = horizontal center position
% centerv = vertical center position
% **********  

% ********** Return Values
% angle     = angular position in degrees
% radius    = radius in pixels
% ********** 

% ********** Purpose (what this function does)
% given a horizontal and vertical position,
% determine polar coordinates with respect to some center point
% ********** 

% ********** Outline
% This function is broken down into 2 main steps
% 1. Get Polar Coordinates
% ********** 


% 1. Get Polar Coordinates ************************************************

hdist   = h-centerH;
vdist   = v-centerV;
hyp     = sqrt(hdist.*hdist + vdist.*vdist);

% determine angle using cosine (hyp will never be zero)
tempAngle = acos(hdist./hyp)./pi*180;

% correct angle depending on quadrant
tempAngle(find(hdist == 0 & vdist > 0)) = 90;
tempAngle(find(hdist == 0 & vdist < 0)) = 270;
tempAngle(find(vdist == 0 & hdist > 0)) = 0;
tempAngle(find(vdist == 0 & hdist < 0)) = 180;
tempAngle(find(hdist < 0 & vdist < 0))=360-tempAngle(find(hdist < 0 & vdist < 0));
tempAngle(find(hdist > 0 & vdist < 0))=360-tempAngle(find(hdist > 0 & vdist < 0));

angle   = tempAngle;
radius  = hyp;

% *************************************************************************





