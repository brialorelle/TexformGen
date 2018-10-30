%% Makes stimuli for use in texform generation
% Bria Long, Nov 2017, brialorelle@gmail.com

%% NOTES
% Inputs: Requires input as images as isolated objects on a green (RGB 0,0,255) background for easy segmentation from masks; 
% these are usually made in photoshop or a similar prgoram beforehand

% Outputs: Screenshots with stimuli embedded in the "peripehery" of the scene that can be fed to the texform algorith.

% Steps
% Resizes images to squares on green backgrounds
% Luminance/contrast matches them to have a low-ish contrast on a specific gray background (same for all texforms, rgb=130 130 130)
% Embeds these images on a "screen" in specific positions and saves
% screenshots

% NOTE: not currently robust to different kinds of images (e.g., not on
% green background!) Adapt and use at your own risk.
%% Step 1: Resize images

addpath(genpath('HelperCode')) % contains SHINE toolbox
clear; clc; dbstop if error;

currFolder='OriginalsGreen'
saveFolder='OriginalsResized'
Step0_resizeImages(currFolder,saveFolder)

%% Step 2: lum contrast across images 
% % SHINE options    [1=default, 2=custom]: 2
% % Matching mode    [1=luminance, 2=spatial frequency, 3=both]: 1
% % Luminance option [1=lumMatch, 2=histMatch]: 1
% % Matching region  [1=whole image, 2=foreground/background]: 2

currFolder='OriginalsResized';
saveFolder='OriginalsLumContMatched';
[imageTex_LumContMatch]=step1_lumContrastOriginals_fromGreen(currFolder, saveFolder)

 %% Step 3: Make screenshots
imageFolder='OriginalsLumContMatched';
saveFolder='Screenshots';
step2_makeScreenshots_Texforms(imageFolder,saveFolder)




