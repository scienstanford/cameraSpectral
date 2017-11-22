%% simple ISP to process Raw images captured from JedEye dev kit

clear all; close all; 

%%
ccmD50 = [1.8164, -0.7656, -0.0508;...
        -0.2305,  1.3008, -0.0703;...
        0.1133, -0.4766,  1.3633]; % D50

rawBits = 12;
blackLevel = 240; 
height = 2064; 
width = 1552; 
bayerPattern = 'rggb';

% Orange
fname = 'vcap0_w2064_h1552_12bit_RGGB_Expt_29992us_ag_22403_126.raw'; %

% Blue
% fname = 'vcap0_w2064_h1552_12bit_RGGB_Expt_29992us_ag_22403_66.raw';

fp  = fopen(fullfile(csRootPath,'local',fname),'rb');
raw = double(fread(fp,[height width],'uint16'));
fclose(fp);

%% black level correction
raw = raw-blackLevel;
raw(raw<0)=0;

%% Crop the image
rawF = figure; imagesc(raw); colormap(gray)
rawRect = round(getrect(rawF));

% For the pixel to be an R pixel
if ~isodd(rawRect(1)), rawRect(1) = rawRect(1) + 1; end
if ~isodd(rawRect(2)), rawRect(2) = rawRect(2) + 1; end
if isodd(rawRect(3)), rawRect(3) = rawRect(3) - 1; end
if isodd(rawRect(4)), rawRect(4) = rawRect(4) - 1; end

rawPortion = imcrop(raw,rawRect);
vcNewGraphWin; imagesc(rawPortion);

%%
%% Insert auto white blance code here

%% Insert auto exposure code here

rgb = demosaic(uint16(rawPortion),bayerPattern); 

%% Insert color correction code here

rgb = double(rgb)/(2.^rawBits-1);
rgb = rgb.^(1/2.2);

figure; imshow(rgb);

%%  This is how we get the RGB data from the image

% Pick out the rectangle from the image
rect = round(getrect(gcf));

% This was the rectangle for one case
% rect = [784        1170         106          74];

% Convert the rgb image to space by color format
[img,r,c] = RGB2XWFormat(rgb);

% Find the locations of the points within the rectangle
roiLocs = ieRoi2Locs(rect); 

% Keep the data in bounds, but probably nothing happens here
roiLocs(:,1) = ieClip(roiLocs(:,1),1,r);
roiLocs(:,2) = ieClip(roiLocs(:,2),1,c);

% These are now the locations in the image
imgLocs = sub2ind([r,c],roiLocs(:,1),roiLocs(:,2));

% Go get them
roiData = img(imgLocs,:);

mean(roiData)

%% This is how we put the RGB data into an ISET image processing object

ip = ipCreate;
ip = ipSet(ip,'display output',rgb);

vcAddObject(ip); ipWindow;

%% This is how we put the data into an ISET sensor object

sensor = sensorCreate;
sensor = sensorSet(sensor,'cfa pattern',[1 2 ; 2 3]);
rawScaled = single(rawPortion/(2^12));
sensor = sensorSet(sensor,'volts',rawScaled);
vcAddObject(sensor); sensorWindow;

%%

