%% Texform demo code
% bria long, brialorelle@gmail.com, november 2017.

%% NOTES
% Created in Matlab 2015a
% uses toolbox  written by Freeman & Simoncelli, https://github.com/freeman-lab/metamers
% Often run on a cluster to speed up processing time (~8 hours per image)

%% Inputs: needs a path to an image file (see "load original" image. Takes screenshots made in previous step)
%% Ouputs: each iteration of the metamer algorithm

clear; clc; close all;
addpath(genpath('metamercode'))

% load original image
oim = double(imread([pwd filesep 'inputImages/Screenshots/Animals/0.89_cat-tigerwhite.jpg_LCMatched.png_InputImage.png'])); % can sub in an image here
oim = mean(oim,3); % make sure it's b&w and only 1d
oim = imresize(oim, [512 512]); % minimum dimensions

% set options
opts = metamerOpts(oim,'windowType=radial','scale=0.5','aspect=1'); % parameters used in Long et al., 2016/2017

% set reasonable output directory
saveDir=[pwd filesep 'output' filesep 'texformTest'];
if ~exist(saveDir)
    mkdir(saveDir)
end
opts.outputPath=saveDir;

% make windows
m = mkImMasks(opts);

% plot windows
plotWindows(m,opts);

% do metamer analysis on original (measure statistics)
params = metamerAnalysis(oim,m,opts);

% do metamer synthesis (generate new image matched for statistics)
res = metamerSynthesis(params,size(oim),m,opts);
