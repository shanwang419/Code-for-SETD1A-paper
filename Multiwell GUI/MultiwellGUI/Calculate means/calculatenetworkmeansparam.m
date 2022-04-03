% Get parameters to calculate the networkmeans
% initialize variables (in case they are not assigned)
%ELINE
function [Param] = calculatenetworkmeansparam()
Param = struct('reclength',[],'recfreq',[]);
% user inputs
PopupPrompt  = {'length of recording [minutes]','frequency [hz]'};
PopupTitle   = 'Calculate network means';
PopupLines   = 1;
PopupDefault = {'10','10000'};
%----------------------------------- PARAMETER CONVERSION
Ianswer = inputdlg(PopupPrompt,PopupTitle,PopupLines,PopupDefault,'on');
if isempty(Ianswer) % halt condition
    return
else
    Param.reclength = str2double(Ianswer{1,1});
    Param.recfreq = str2double(Ianswer{2,1});     
end